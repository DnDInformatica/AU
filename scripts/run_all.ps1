# run_all.ps1 - Avvia tutti i servizi SIGAD
# Esegui da: C:\Accredia\Sviluppo\AU

param(
    [switch]$Build,
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"
$workspace = "C:\Accredia\Sviluppo\AU"

# Colori output
function Write-Info { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Err { param($msg) Write-Host "[ERROR] $msg" -ForegroundColor Red }

# Verifica workspace
if (-not (Test-Path $workspace)) {
    Write-Err "Workspace non trovato: $workspace"
    exit 1
}

Set-Location $workspace

# Build se richiesto
if ($Build) {
    Write-Info "Building solution..."
    dotnet build --configuration Debug
    if ($LASTEXITCODE -ne 0) {
        Write-Err "Build fallita"
        exit 1
    }
    Write-Success "Build completata"
}

# Definizione servizi
$services = @(
    @{ Name = "Identity.Api"; Project = "Accredia.SIGAD.Identity.Api"; Port = 7001 },
    @{ Name = "Tipologiche.Api"; Project = "Accredia.SIGAD.Tipologiche.Api"; Port = 7002 },
    @{ Name = "Anagrafiche.Api"; Project = "Accredia.SIGAD.Anagrafiche.Api"; Port = 7003 },
    @{ Name = "Gateway"; Project = "Accredia.SIGAD.Gateway"; Port = 7100 },
    @{ Name = "Web"; Project = "Accredia.SIGAD.Web"; Port = 7000 }
)

# Avvia servizi
$processes = @()
foreach ($svc in $services) {
    $projectPath = Join-Path $workspace $svc.Project
    if (-not (Test-Path $projectPath)) {
        Write-Warn "Progetto non trovato: $($svc.Project)"
        continue
    }
    
    Write-Info "Avvio $($svc.Name) su porta $($svc.Port)..."
    
    $proc = Start-Process -FilePath "dotnet" `
        -ArgumentList "run", "--project", $projectPath, "--no-build" `
        -WindowStyle $(if ($Verbose) { "Normal" } else { "Minimized" }) `
        -PassThru
    
    $processes += @{
        Name = $svc.Name
        Port = $svc.Port
        Process = $proc
    }
    
    # Pausa tra avvii
    Start-Sleep -Seconds 2
}

Write-Success "Tutti i servizi avviati"
Write-Info "Attendi qualche secondo per il warm-up..."
Start-Sleep -Seconds 5

# Verifica health
Write-Info "Verifica health endpoints..."
foreach ($svc in $services) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:$($svc.Port)/health" `
            -UseBasicParsing -TimeoutSec 5
        if ($response.StatusCode -eq 200) {
            Write-Success "$($svc.Name) - Health OK"
        }
    } catch {
        Write-Warn "$($svc.Name) - Health check fallito (potrebbe essere ancora in avvio)"
    }
}

Write-Host ""
Write-Info "Servizi in esecuzione:"
Write-Host "  Web:         http://localhost:7000"
Write-Host "  Gateway:     http://localhost:7100"
Write-Host "  Identity:    http://localhost:7001"
Write-Host "  Tipologiche: http://localhost:7002"
Write-Host "  Anagrafiche: http://localhost:7003"
Write-Host ""
Write-Info "Usa stop_all.ps1 per fermare tutti i servizi"
