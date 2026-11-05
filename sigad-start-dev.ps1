# Avvia SIGAD con il profilo di sviluppo, SENZA Identity.Api (in dismissione).
# L'identita' e' simulata e risolta su IAM come in esercizio.
$ErrorActionPreference = 'Stop'
$root = 'C:\Accredia\Sviluppo\AU'
$oid  = '885f0c42-97b7-4ab0-b171-d6372d6bdf10'   # admin@accredia.local, censito in IAM.Utente

Get-Process -Name 'Accredia.SIGAD*' -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

$env:ASPNETCORE_ENVIRONMENT = 'Development'
$env:SIGAD_DEV_AUTH = '1'
$env:SIGAD_DEV_OID  = $oid

$servizi = @(
    @{ Nome = 'Tipologiche.Api';  Porta = 7002 },
    @{ Nome = 'Anagrafiche.Api';  Porta = 7003 },
    @{ Nome = 'RisorseUmane.Api'; Porta = 7004 },
    @{ Nome = 'RisorseUmane.Bff.Api'; Porta = 7005 },
    @{ Nome = 'Gateway';          Porta = 7100 },
    @{ Nome = 'Web';              Porta = 7000 }
)

foreach ($s in $servizi) {
    $dir = Join-Path $root ("Accredia.SIGAD." + $s.Nome)
    if (-not (Test-Path $dir)) { Write-Host "SALTATO (assente): $($s.Nome)" -ForegroundColor DarkGray; continue }
    Start-Process -FilePath 'dotnet' -ArgumentList 'run --no-build' -WorkingDirectory $dir -WindowStyle Minimized
    Write-Host ("avviato  {0,-20} porta {1}" -f $s.Nome, $s.Porta) -ForegroundColor Cyan
    Start-Sleep -Seconds 4
}

Write-Host ""
Write-Host "Attesa avvio (30s)..." -ForegroundColor DarkGray
Start-Sleep -Seconds 30

Write-Host ""
foreach ($s in $servizi) {
    $ok = (Test-NetConnection -ComputerName localhost -Port $s.Porta -WarningAction SilentlyContinue).TcpTestSucceeded
    $col = if ($ok) { 'Green' } else { 'Red' }
    Write-Host ("{0,-20} porta {1}  attivo={2}" -f $s.Nome, $s.Porta, $ok) -ForegroundColor $col
}

Write-Host ""
Write-Host "Interfaccia: http://localhost:7000" -ForegroundColor Yellow
Write-Host "Identita' simulata (oid): $oid" -ForegroundColor Yellow
