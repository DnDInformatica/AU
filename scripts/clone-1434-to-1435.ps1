param(
    [string]$ComposeFile = "docker-compose.staging.yml",
    [string]$EnvFile = ".env",
    [string]$SqlService = "sqlserver",
    [string]$TargetContainer = "sigad-sqlserver",
    [string]$SourceServer = "host.docker.internal,1434",
    [string]$SourceUser = "sa",
    [string]$SourcePassword = $env:SIGAD_SOURCE_SQL_PASSWORD,
    [string]$SourceDatabase = "Accredia2025",
    [string]$TargetDatabase = "Accredia2025",
    [string]$SourceContainer = "",
    [string]$TransferDir = "artifacts/transfer"
)

if ([string]::IsNullOrWhiteSpace($SourcePassword)) {
    throw "Password della sorgente assente: impostare la variabile d'ambiente SIGAD_SOURCE_SQL_PASSWORD o passare -SourcePassword."
}

$ErrorActionPreference = "Stop"

function Get-EnvValue {
    param(
        [string]$Path,
        [string]$Key
    )

    if (-not (Test-Path $Path)) {
        throw "File env non trovato: $Path"
    }

    $line = Get-Content $Path | Where-Object { $_ -match "^$([Regex]::Escape($Key))=" } | Select-Object -First 1
    if (-not $line) {
        throw "Chiave '$Key' non trovata in $Path"
    }

    return ($line -split "=", 2)[1]
}

function Invoke-ComposeSqlcmd {
    param(
        [string]$Server,
        [string]$User,
        [string]$Password,
        [string]$Query,
        [string]$Database = ""
    )

    $args = @(
        "compose", "-f", $ComposeFile, "--env-file", $EnvFile,
        "exec", "-T", $SqlService,
        "/opt/mssql-tools18/bin/sqlcmd",
        "-C", "-S", $Server, "-U", $User, "-P", $Password
    )

    if (-not [string]::IsNullOrWhiteSpace($Database)) {
        $args += @("-d", $Database)
    }

    $args += @("-Q", $Query)
    & docker @args
}

function Resolve-SourceContainer {
    param([string]$ExplicitName)

    if (-not [string]::IsNullOrWhiteSpace($ExplicitName)) {
        return $ExplicitName
    }

    $rows = & docker ps --format "{{.Names}}|{{.Ports}}"
    $match = @($rows | Where-Object { $_ -match "[:]{1}1434->1433/tcp" })

    if ($match.Count -eq 0) {
        throw "Impossibile trovare il container sorgente che espone la porta 1434. Passa -SourceContainer."
    }

    if ($match.Count -gt 1) {
        throw "Trovati piu' container su porta 1434. Passa -SourceContainer esplicitamente."
    }

    return ($match[0] -split "\|", 2)[0]
}

$targetPassword = Get-EnvValue -Path $EnvFile -Key "SQL_SA_PASSWORD"
$resolvedSourceContainer = Resolve-SourceContainer -ExplicitName $SourceContainer

New-Item -ItemType Directory -Force -Path $TransferDir | Out-Null

# Check source/target major versions before restore.
$sourceMajor = Invoke-ComposeSqlcmd -Server $SourceServer -User $SourceUser -Password $SourcePassword -Query "SET NOCOUNT ON; SELECT CAST(SERVERPROPERTY('ProductMajorVersion') AS int);" |
    Select-Object -Last 1
$targetMajor = Invoke-ComposeSqlcmd -Server "localhost" -User "sa" -Password $targetPassword -Query "SET NOCOUNT ON; SELECT CAST(SERVERPROPERTY('ProductMajorVersion') AS int);" |
    Select-Object -Last 1

$sourceMajorInt = [int]("$sourceMajor".Trim())
$targetMajorInt = [int]("$targetMajor".Trim())

if ($sourceMajorInt -gt $targetMajorInt) {
    throw "Restore non compatibile: sorgente SQL major=$sourceMajorInt > target SQL major=$targetMajorInt. Aggiorna il target."
}

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$bakFile = "${SourceDatabase}_from1434_${timestamp}.bak"
$sourceBakPath = "/var/opt/mssql/data/$bakFile"
$targetBakPath = "/var/opt/mssql/backup/$bakFile"
$localBakPath = Join-Path $TransferDir $bakFile

# 1) Backup on source server (1434)
$backupSql = "BACKUP DATABASE [$SourceDatabase] TO DISK = N'$sourceBakPath' WITH INIT, COPY_ONLY, COMPRESSION, STATS = 10;"
Invoke-ComposeSqlcmd -Server $SourceServer -User $SourceUser -Password $SourcePassword -Query $backupSql

# 2) Copy source backup to local workspace and target container
& docker cp "${resolvedSourceContainer}:$sourceBakPath" $localBakPath | Out-Null
& docker exec $TargetContainer bash -lc "mkdir -p /var/opt/mssql/backup" | Out-Null
& docker cp $localBakPath "${TargetContainer}:$targetBakPath" | Out-Null

# 3) Restore to target server (1435 / container sqlserver)
$restoreSql = @"
USE [master];
IF DB_ID(N'$TargetDatabase') IS NOT NULL
BEGIN
    ALTER DATABASE [$TargetDatabase] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
END;
RESTORE DATABASE [$TargetDatabase]
FROM DISK = N'$targetBakPath'
WITH REPLACE, RECOVERY, STATS = 10;
ALTER DATABASE [$TargetDatabase] SET MULTI_USER;
"@
Invoke-ComposeSqlcmd -Server "localhost" -User "sa" -Password $targetPassword -Query $restoreSql

# 4) Verify restore history + quick sanity count
$verifySql = @"
SELECT TOP 1 destination_database_name, restore_date, [replace]
FROM msdb.dbo.restorehistory
WHERE destination_database_name = N'$TargetDatabase'
ORDER BY restore_date DESC;
SELECT COUNT(1) AS OrganizzazioneRows FROM [$TargetDatabase].[Organizzazioni].[Organizzazione];
"@
Invoke-ComposeSqlcmd -Server "localhost" -User "sa" -Password $targetPassword -Query $verifySql

Write-Output "Clone completato."
Write-Output "Source container: $resolvedSourceContainer"
Write-Output "Backup locale: $localBakPath"
