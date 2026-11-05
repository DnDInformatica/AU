# Estrae lo schema di Accredia_SIDAC in file .sql versionabili (uno per oggetto,
# organizzati per schema e tipo).
# Autenticazione: token Entra ID via Azure CLI. Nessuna credenziale nei file.
[CmdletBinding()]
param(
    [string]$Server   = 'accsqlmigration-sql-itn-dev.database.windows.net',
    [string]$Database = 'Accredia_SIDAC',
    [string]$OutDir   = (Join-Path (Split-Path $PSScriptRoot -Parent) 'src')
)
$ErrorActionPreference = 'Stop'

if (Test-Path $OutDir) {
    $stray = Get-ChildItem -Path $OutDir -Recurse -File | Where-Object Extension -ne '.sql'
    if ($stray) { throw "La cartella $OutDir contiene file non .sql: rimuoverla a mano." }
    Write-Host "Rimozione estrazione precedente: $OutDir" -ForegroundColor DarkGray
    Remove-Item -Path $OutDir -Recurse -Force
}

Write-Host "Acquisizione token Entra per Azure SQL ..." -ForegroundColor Cyan
$token = az account get-access-token --resource https://database.windows.net/ --query accessToken -o tsv
if ([string]::IsNullOrWhiteSpace($token)) {
    throw "Token non ottenuto. Eseguire prima: az login"
}

Write-Host "Estrazione schema di $Database in $OutDir" -ForegroundColor Cyan
Write-Host ""

sqlpackage /Action:Extract `
    /TargetFile:"$OutDir" `
    /SourceServerName:"$Server" `
    /SourceDatabaseName:"$Database" `
    /AccessToken:"$token" `
    /p:ExtractTarget=SchemaObjectType `
    /p:ExtractAllTableData=False `
    /p:IgnorePermissions=True `
    /p:IgnoreUserLoginMappings=True `
    /p:VerifyExtraction=False

$exit = $LASTEXITCODE
$token = $null
if ($exit -ne 0) { throw "Estrazione fallita (exit $exit)" }

$sql = Get-ChildItem -Path $OutDir -Recurse -Filter *.sql -File
Write-Host ""
Write-Host ("Estratti {0} file .sql" -f $sql.Count) -ForegroundColor Green
$sql | Group-Object { Split-Path $_.DirectoryName -Leaf } |
       Sort-Object Count -Descending | Select-Object -First 20 |
       ForEach-Object { "  {0,-30} {1}" -f $_.Name, $_.Count }
