$ErrorActionPreference = "Stop"

$workdir = "C:\Accredia\Sviluppo\AU"
$ports = @(7000, 7100, 7001, 7002, 7003)

Write-Host "Workdir: $workdir"
if (-not (Test-Path $workdir)) { throw "Workdir non esiste: $workdir" }

Write-Host "dotnet version:"
dotnet --version

Write-Host "Controllo porte occupate..."
foreach ($p in $ports) {
  $used = Get-NetTCPConnection -LocalPort $p -ErrorAction SilentlyContinue
  if ($used) {
    Write-Host "PORTA OCCUPATA: $p" -ForegroundColor Red
    $used | Select-Object LocalAddress,LocalPort,State,OwningProcess | Format-Table -AutoSize
  } else {
    Write-Host "OK libera: $p" -ForegroundColor Green
  }
}
