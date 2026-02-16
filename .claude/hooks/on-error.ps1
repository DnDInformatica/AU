# on-error.ps1 - Hook per recovery automatico da errori comuni
# Analizza l'errore e tenta fix automatici

param(
    [string]$ErrorMessage = "",
    [string]$ErrorFile = ""
)

$workspace = "C:\Accredia\Sviluppo\AU"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$checkpointDir = Join-Path $workspace ".claude\checkpoints"
$logFile = Join-Path $checkpointDir "error-recovery.log"

"[$timestamp] ERROR RECOVERY avviato" | Add-Content $logFile
"  Errore: $ErrorMessage" | Add-Content $logFile

$recovered = $false
$recoveryAction = ""

# Pattern di errori comuni e recovery
$errorPatterns = @(
    @{
        Pattern = "error CS0246.*Dapper"
        Recovery = {
            Write-Host "[RECOVERY] Installazione package Dapper..." -ForegroundColor Yellow
            $projects = @("Identity.Api", "Tipologiche.Api", "Anagrafiche.Api")
            foreach ($proj in $projects) {
                $projPath = Join-Path $workspace "Accredia.SIGAD.$proj"
                if (Test-Path $projPath) {
                    dotnet add $projPath package Dapper --no-restore
                }
            }
            dotnet restore "$workspace\Accredia.SIGAD.sln"
            return "Installato Dapper in tutti i progetti API"
        }
        Message = "Package Dapper mancante"
    },
    @{
        Pattern = "error CS0246.*Microsoft\.Data\.SqlClient"
        Recovery = {
            Write-Host "[RECOVERY] Installazione package Microsoft.Data.SqlClient..." -ForegroundColor Yellow
            $projects = @("Identity.Api", "Tipologiche.Api", "Anagrafiche.Api")
            foreach ($proj in $projects) {
                $projPath = Join-Path $workspace "Accredia.SIGAD.$proj"
                if (Test-Path $projPath) {
                    dotnet add $projPath package Microsoft.Data.SqlClient --no-restore
                }
            }
            dotnet restore "$workspace\Accredia.SIGAD.sln"
            return "Installato Microsoft.Data.SqlClient"
        }
        Message = "Package SqlClient mancante"
    },
    @{
        Pattern = "error CS0234.*MudBlazor"
        Recovery = {
            Write-Host "[RECOVERY] Installazione package MudBlazor..." -ForegroundColor Yellow
            $webPath = Join-Path $workspace "Accredia.SIGAD.Web"
            if (Test-Path $webPath) {
                dotnet add $webPath package MudBlazor
            }
            return "Installato MudBlazor in Web"
        }
        Message = "Package MudBlazor mancante"
    },
    @{
        Pattern = "error NU1101|error NU1102"
        Recovery = {
            Write-Host "[RECOVERY] Ripristino packages..." -ForegroundColor Yellow
            dotnet restore "$workspace\Accredia.SIGAD.sln" --force
            return "Eseguito restore forzato"
        }
        Message = "Errore NuGet restore"
    },
    @{
        Pattern = "error CS0103.*IDbConnectionFactory"
        Recovery = {
            Write-Host "[RECOVERY] IDbConnectionFactory non trovato - verifica Shared project" -ForegroundColor Yellow
            # Non possiamo creare codice qui, ma possiamo suggerire
            return "MANUALE: Implementare IDbConnectionFactory in Accredia.SIGAD.Shared"
        }
        Message = "IDbConnectionFactory non definito"
    }
)

# Cerca match
foreach ($ep in $errorPatterns) {
    if ($ErrorMessage -match $ep.Pattern) {
        Write-Host "[MATCH] $($ep.Message)" -ForegroundColor Cyan
        "  [MATCH] $($ep.Message)" | Add-Content $logFile
        
        try {
            $recoveryAction = & $ep.Recovery
            $recovered = $true
            Write-Host "[RECOVERY] $recoveryAction" -ForegroundColor Green
            "  [RECOVERY] $recoveryAction" | Add-Content $logFile
        } catch {
            Write-Host "[FAIL] Recovery fallito: $_" -ForegroundColor Red
            "  [FAIL] Recovery fallito: $_" | Add-Content $logFile
        }
        break
    }
}

if (-not $recovered) {
    Write-Host "[INFO] Nessun recovery automatico disponibile per questo errore" -ForegroundColor Yellow
    Write-Host "[INFO] Consulta MEMORY.md per errori simili risolti in precedenza" -ForegroundColor Yellow
    "  [INFO] Nessun recovery automatico" | Add-Content $logFile
}

# Suggerimenti generali
Write-Host ""
Write-Host "========== SUGGERIMENTI ==========" -ForegroundColor Cyan
Write-Host "1. Verifica MEMORY.md per errori simili" -ForegroundColor White
Write-Host "2. Esegui: dotnet build --verbosity detailed" -ForegroundColor White
Write-Host "3. Controlla i file modificati di recente" -ForegroundColor White

# Salva stato recovery
@{
    Timestamp = $timestamp
    OriginalError = $ErrorMessage
    Recovered = $recovered
    RecoveryAction = $recoveryAction
} | ConvertTo-Json | Set-Content (Join-Path $checkpointDir "last_recovery.json")

if ($recovered) {
    Write-Host ""
    Write-Host "[OK] Recovery completato - riprova il comando" -ForegroundColor Green
    exit 0
} else {
    exit 1
}
