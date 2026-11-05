# Confronta lo schema versionato con il database reale e segnala il drift.
# Non applica nulla: produce solo un report. Da eseguire in pipeline e in locale.
[CmdletBinding()]
param(
    [string]$Server   = 'accsqlmigration-sql-itn-dev.database.windows.net',
    [string]$Database = 'Accredia_SIDAC',
    [string]$Dacpac   = (Join-Path $PSScriptRoot '..\bin\Debug\Accredia.SIDAC.Database.dacpac'),
    [switch]$FailOnDrift
)
$ErrorActionPreference = 'Stop'

$reportDir = Join-Path $PSScriptRoot '..\_drift'
New-Item -ItemType Directory -Force -Path $reportDir | Out-Null
$stamp  = Get-Date -Format 'yyyyMMdd_HHmmss'
$xml    = Join-Path $reportDir "deployreport_$stamp.xml"
$script = Join-Path $reportDir "diff_$stamp.sql"

Write-Host "Confronto $Database con lo schema versionato ..." -ForegroundColor Cyan

sqlpackage /Action:DeployReport `
    /SourceFile:"$Dacpac" `
    /TargetServerName:"$Server" `
    /TargetDatabaseName:"$Database" `
    /UniversalAuthentication:True `
    /OutputPath:"$xml" `
    /p:BlockOnPossibleDataLoss=True `
    /p:IgnorePermissions=True `
    /p:IgnoreUserSettingsObjects=True `
    /p:DropObjectsNotInSource=False
if ($LASTEXITCODE -ne 0) { throw "DeployReport fallito (exit $LASTEXITCODE)" }

sqlpackage /Action:Script `
    /SourceFile:"$Dacpac" `
    /TargetServerName:"$Server" `
    /TargetDatabaseName:"$Database" `
    /UniversalAuthentication:True `
    /OutputPath:"$script" `
    /p:DropObjectsNotInSource=False | Out-Null

[xml]$rep = Get-Content $xml
$ops = @($rep.DeploymentReport.Operations.Operation)
if ($ops.Count -eq 0) {
    Write-Host "NESSUN DRIFT: schema versionato allineato al database." -ForegroundColor Green
    exit 0
}

Write-Host "" ; Write-Host "DRIFT RILEVATO" -ForegroundColor Yellow
$ops | ForEach-Object {
    $name = $_.Name
    $items = @($_.Item)
    "  {0,-10} {1} oggetto(i)" -f $name, $items.Count
    $items | Select-Object -First 15 | ForEach-Object { "      - $($_.Value)" }
    if ($items.Count -gt 15) { "      ... e altri $($items.Count - 15)" }
}
Write-Host ""
Write-Host "Report: $xml"
Write-Host "Script: $script"
if ($FailOnDrift) { exit 1 }
