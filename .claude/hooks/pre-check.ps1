# pre-check.ps1 - Hook eseguito prima di ogni comando Claude Code
# Verifica stato progetto e prepara checkpoint

param(
    [string]$Command = "unknown"
)

$workspace = "C:\Accredia\Sviluppo\AU"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$checkpointDir = Join-Path $workspace ".claude\checkpoints"

# Assicura directory checkpoint
if (-not (Test-Path $checkpointDir)) {
    New-Item -ItemType Directory -Path $checkpointDir -Force | Out-Null
}

# Log
$logFile = Join-Path $checkpointDir "pre-check.log"
"[$timestamp] PRE-CHECK per comando: $Command" | Add-Content $logFile

# Verifica 1: Solution esiste
$slnPath = Join-Path $workspace "Accredia.SIGAD.sln"
if (-not (Test-Path $slnPath)) {
    Write-Host "[WARN] Solution non trovata: $slnPath" -ForegroundColor Yellow
    "  [WARN] Solution non trovata" | Add-Content $logFile
}

# Verifica 2: MEMORY.md esiste
$memoryPath = Join-Path $workspace "MEMORY.md"
if (-not (Test-Path $memoryPath)) {
    Write-Host "[WARN] MEMORY.md non trovato - creazione consigliata" -ForegroundColor Yellow
    "  [WARN] MEMORY.md non trovato" | Add-Content $logFile
}

# Verifica 3: Nessun processo .NET sulle porte SIGAD che potrebbe interferire
$ports = @(7000, 7001, 7002, 7003, 7100)
foreach ($port in $ports) {
    $conn = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
    if ($conn) {
        Write-Host "[INFO] Porta $port in uso (PID: $($conn.OwningProcess))" -ForegroundColor Cyan
        "  [INFO] Porta $port in uso" | Add-Content $logFile
    }
}

# Crea checkpoint leggero (lista file modificati di recente)
$recentFiles = Get-ChildItem $workspace -Recurse -File -ErrorAction SilentlyContinue | 
    Where-Object { $_.LastWriteTime -gt (Get-Date).AddHours(-1) -and $_.Extension -match '\.(cs|json|csproj|razor)$' } |
    Select-Object FullName, LastWriteTime |
    ConvertTo-Json

$checkpointFile = Join-Path $checkpointDir "checkpoint_$timestamp.json"
@{
    Timestamp = $timestamp
    Command = $Command
    RecentFiles = $recentFiles
} | ConvertTo-Json | Set-Content $checkpointFile

Write-Host "[OK] PRE-CHECK completato" -ForegroundColor Green
"  [OK] Checkpoint salvato: $checkpointFile" | Add-Content $logFile

exit 0
