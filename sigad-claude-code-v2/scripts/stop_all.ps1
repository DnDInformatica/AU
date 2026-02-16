# stop_all.ps1 - Ferma tutti i servizi SIGAD
# Esegui da: C:\Accredia\Sviluppo\AU

$ErrorActionPreference = "Continue"

function Write-Info { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }

$ports = @(7000, 7001, 7002, 7003, 7100)

Write-Info "Ricerca processi SIGAD sulle porte: $($ports -join ', ')"

foreach ($port in $ports) {
    $connections = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
    
    if ($connections) {
        foreach ($conn in $connections) {
            $pid = $conn.OwningProcess
            $proc = Get-Process -Id $pid -ErrorAction SilentlyContinue
            
            if ($proc) {
                Write-Info "Porta $port - PID $pid ($($proc.ProcessName))"
                try {
                    Stop-Process -Id $pid -Force
                    Write-Success "Processo $pid terminato"
                } catch {
                    Write-Warn "Impossibile terminare processo $pid"
                }
            }
        }
    } else {
        Write-Info "Porta $port - Nessun processo in ascolto"
    }
}

# Cleanup processi dotnet orfani relativi a SIGAD
$dotnetProcs = Get-Process -Name "dotnet" -ErrorAction SilentlyContinue | 
    Where-Object { $_.MainWindowTitle -match "SIGAD" -or $_.CommandLine -match "SIGAD" }

if ($dotnetProcs) {
    Write-Info "Trovati $($dotnetProcs.Count) processi dotnet SIGAD aggiuntivi"
    $dotnetProcs | ForEach-Object {
        try {
            Stop-Process -Id $_.Id -Force
            Write-Success "Processo $($_.Id) terminato"
        } catch {
            Write-Warn "Impossibile terminare processo $($_.Id)"
        }
    }
}

Write-Host ""
Write-Success "Cleanup completato"
