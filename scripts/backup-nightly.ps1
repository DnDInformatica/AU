param(
    [string]$ComposeFile = "docker-compose.staging.yml",
    [string]$EnvFile = ".env",
    [string]$SqlService = "sqlserver",
    [string]$SqlContainer = "sigad-sqlserver",
    [string]$DatabaseName = "Accredia2025",
    [string]$OutputDir = "artifacts/backup",
    [int]$RetentionCount = 7
)

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

if ($RetentionCount -lt 1) {
    throw "RetentionCount deve essere >= 1."
}

$saPassword = Get-EnvValue -Path $EnvFile -Key "SQL_SA_PASSWORD"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$bakName = "${DatabaseName}_${timestamp}.bak"
$containerBakDir = "/var/opt/mssql/backup"
$containerBakPath = "$containerBakDir/$bakName"

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

$mkdirCmd = @(
    "compose", "-f", $ComposeFile, "--env-file", $EnvFile,
    "exec", "-T", $SqlService, "bash", "-lc", "mkdir -p $containerBakDir"
)
& docker @mkdirCmd | Out-Null

$backupSql = "BACKUP DATABASE [$DatabaseName] TO DISK = N'$containerBakPath' WITH INIT, COPY_ONLY, COMPRESSION, STATS = 10;"
$backupCmd = @(
    "compose", "-f", $ComposeFile, "--env-file", $EnvFile,
    "exec", "-T", $SqlService,
    "/opt/mssql-tools18/bin/sqlcmd", "-C", "-S", "localhost", "-U", "sa", "-P", $saPassword,
    "-Q", $backupSql
)
& docker @backupCmd

$localBakPath = Join-Path $OutputDir $bakName
$copyCmd = @("cp", "${SqlContainer}:${containerBakPath}", $localBakPath)
& docker @copyCmd | Out-Null

$pattern = "${DatabaseName}_*.bak"
$allBackups = Get-ChildItem -Path $OutputDir -Filter $pattern -File | Sort-Object LastWriteTime -Descending
$toDelete = $allBackups | Select-Object -Skip $RetentionCount
foreach ($f in $toDelete) {
    Remove-Item -Path $f.FullName -Force
}

Write-Output "Backup creato: $localBakPath"
Write-Output "Retention attiva: ultimi $RetentionCount file '$pattern' in '$OutputDir'"
