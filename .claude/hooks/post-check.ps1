# post-check.ps1 - Hook eseguito dopo ogni comando Claude Code
# Verifica build e aggiorna stato

param(
    [string]$Command = "unknown",
    [switch]$SkipBuild
)

$workspace = "C:\Accredia\Sviluppo\AU"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$checkpointDir = Join-Path $workspace ".claude\checkpoints"
$logFile = Join-Path $checkpointDir "post-check.log"

# Assicura directory
if (-not (Test-Path $checkpointDir)) {
    New-Item -ItemType Directory -Path $checkpointDir -Force | Out-Null
}

"[$timestamp] POST-CHECK per comando: $Command" | Add-Content $logFile

$errors = @()
$warnings = @()

# Verifica 1: Build solution
if (-not $SkipBuild) {
    Write-Host "[INFO] Esecuzione build..." -ForegroundColor Cyan
    
    $buildOutput = dotnet build "$workspace\Accredia.SIGAD.sln" --nologo --verbosity quiet 2>&1
    $buildExitCode = $LASTEXITCODE
    
    if ($buildExitCode -ne 0) {
        Write-Host "[ERROR] Build fallita!" -ForegroundColor Red
        $errors += "Build fallita"
        "  [ERROR] Build fallita" | Add-Content $logFile
        
        # Salva errori per recovery
        $buildOutput | Set-Content (Join-Path $checkpointDir "last_build_error.txt")
    } else {
        Write-Host "[OK] Build completata" -ForegroundColor Green
        "  [OK] Build OK" | Add-Content $logFile
    }
}

# Verifica 2: Cerca pattern vietati nei file modificati di recente
$recentCsFiles = Get-ChildItem $workspace -Recurse -Filter "*.cs" -ErrorAction SilentlyContinue | 
    Where-Object { $_.LastWriteTime -gt (Get-Date).AddMinutes(-30) }

$forbiddenPatterns = @(
    @{ Pattern = "AddDbContext"; Message = "EF Core DbContext registrato a runtime" },
    @{ Pattern = ": ControllerBase"; Message = "Controller MVC trovato" },
    @{ Pattern = "\[ApiController\]"; Message = "Attributo ApiController trovato" }
)

foreach ($file in $recentCsFiles) {
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if ($content) {
        foreach ($fp in $forbiddenPatterns) {
            if ($content -match $fp.Pattern) {
                $warnings += "$($fp.Message) in $($file.Name)"
                Write-Host "[WARN] $($fp.Message) in $($file.Name)" -ForegroundColor Yellow
                "  [WARN] $($fp.Message) in $($file.Name)" | Add-Content $logFile
            }
        }
    }
}

# Verifica 3: Porte in launchSettings.json
$projects = @(
    @{ Name = "Web"; Port = 7000 },
    @{ Name = "Gateway"; Port = 7100 },
    @{ Name = "Identity.Api"; Port = 7001 },
    @{ Name = "Tipologiche.Api"; Port = 7002 },
    @{ Name = "Anagrafiche.Api"; Port = 7003 }
)

foreach ($proj in $projects) {
    $launchPath = Join-Path $workspace "Accredia.SIGAD.$($proj.Name)\Properties\launchSettings.json"
    if (Test-Path $launchPath) {
        $content = Get-Content $launchPath -Raw
        if ($content -notmatch "localhost:$($proj.Port)") {
            $warnings += "$($proj.Name): porta $($proj.Port) non configurata correttamente"
            Write-Host "[WARN] $($proj.Name): porta $($proj.Port) non trovata in launchSettings" -ForegroundColor Yellow
        }
    }
}

# Riepilogo
Write-Host ""
Write-Host "========== POST-CHECK RIEPILOGO ==========" -ForegroundColor Cyan
Write-Host "Errori:   $($errors.Count)" -ForegroundColor $(if ($errors.Count -gt 0) { "Red" } else { "Green" })
Write-Host "Warning:  $($warnings.Count)" -ForegroundColor $(if ($warnings.Count -gt 0) { "Yellow" } else { "Green" })

# Salva stato
@{
    Timestamp = $timestamp
    Command = $Command
    Errors = $errors
    Warnings = $warnings
    BuildSuccess = ($buildExitCode -eq 0)
} | ConvertTo-Json | Set-Content (Join-Path $checkpointDir "last_post_check.json")

if ($errors.Count -gt 0) {
    Write-Host "[ACTION] Correggi gli errori prima di procedere" -ForegroundColor Red
    exit 1
}

exit 0
