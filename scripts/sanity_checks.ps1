# sanity_checks.ps1 - Verifiche automatiche SIGAD
# Esegui da: C:\Accredia\Sviluppo\AU

param(
    [switch]$SkipBuild,
    [switch]$SkipHealth
)

$ErrorActionPreference = "Continue"
$workspace = "C:\Accredia\Sviluppo\AU"

function Write-Info { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "[PASS] $msg" -ForegroundColor Green }
function Write-Fail { param($msg) Write-Host "[FAIL] $msg" -ForegroundColor Red }
function Write-Skip { param($msg) Write-Host "[SKIP] $msg" -ForegroundColor Yellow }

$global:passed = 0
$global:failed = 0
$global:skipped = 0

function Test-Check {
    param($name, $condition, $skip = $false)
    
    if ($skip) {
        Write-Skip $name
        $global:skipped++
        return
    }
    
    if ($condition) {
        Write-Success $name
        $global:passed++
    } else {
        Write-Fail $name
        $global:failed++
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SIGAD Sanity Checks" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Workspace
Write-Info "1. Verifica Workspace"
Test-Check "Workspace esiste" (Test-Path $workspace)
Set-Location $workspace -ErrorAction SilentlyContinue

# 2. Solution
Write-Info "2. Verifica Solution"
Test-Check "Solution file esiste" (Test-Path "Accredia.SIGAD.sln")

# 3. Progetti
Write-Info "3. Verifica Progetti"
$projects = @(
    "Accredia.SIGAD.Web",
    "Accredia.SIGAD.Gateway",
    "Accredia.SIGAD.Identity.Api",
    "Accredia.SIGAD.Tipologiche.Api",
    "Accredia.SIGAD.Anagrafiche.Api",
    "Accredia.SIGAD.Shared"
)

foreach ($proj in $projects) {
    $exists = Test-Path (Join-Path $workspace $proj)
    Test-Check "Progetto $proj esiste" $exists
}

# 4. Build
Write-Info "4. Verifica Build"
if (-not $SkipBuild) {
    $buildResult = dotnet build --no-restore 2>&1
    $buildSuccess = $LASTEXITCODE -eq 0
    Test-Check "Solution compila correttamente" $buildSuccess
} else {
    Test-Check "Build" $false $true
}

# 5. TargetFramework
Write-Info "5. Verifica TargetFramework"
foreach ($proj in $projects) {
    $csprojPath = Join-Path $workspace $proj "$proj.csproj"
    if (Test-Path $csprojPath) {
        $content = Get-Content $csprojPath -Raw
        $hasNet9 = $content -match "net9\.0"
        Test-Check "$proj target net9.0" $hasNet9
    }
}

# 6. LaunchSettings
Write-Info "6. Verifica Porte"
$portMap = @{
    "Accredia.SIGAD.Web" = 7000
    "Accredia.SIGAD.Gateway" = 7100
    "Accredia.SIGAD.Identity.Api" = 7001
    "Accredia.SIGAD.Tipologiche.Api" = 7002
    "Accredia.SIGAD.Anagrafiche.Api" = 7003
}

foreach ($proj in $portMap.Keys) {
    $launchPath = Join-Path $workspace $proj "Properties" "launchSettings.json"
    if (Test-Path $launchPath) {
        $content = Get-Content $launchPath -Raw
        $expectedPort = $portMap[$proj]
        $hasPort = $content -match "localhost:$expectedPort"
        Test-Check "$proj porta $expectedPort configurata" $hasPort
    }
}

# 7. Health Endpoints
Write-Info "7. Verifica Health Endpoints"
if (-not $SkipHealth) {
    $healthPorts = @(7001, 7002, 7003, 7100)
    foreach ($port in $healthPorts) {
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:$port/health" `
                -UseBasicParsing -TimeoutSec 3
            $isOk = $response.StatusCode -eq 200
            Test-Check "Health check porta $port" $isOk
        } catch {
            Test-Check "Health check porta $port (servizio non in esecuzione)" $false
        }
    }
} else {
    Test-Check "Health checks" $false $true
}

# 8. Dapper
Write-Info "8. Verifica Dapper"
$apiProjects = @("Accredia.SIGAD.Identity.Api", "Accredia.SIGAD.Tipologiche.Api", "Accredia.SIGAD.Anagrafiche.Api")
foreach ($proj in $apiProjects) {
    $csprojPath = Join-Path $workspace $proj "$proj.csproj"
    if (Test-Path $csprojPath) {
        $content = Get-Content $csprojPath -Raw
        $hasDapper = $content -match "Dapper"
        Test-Check "$proj ha Dapper" $hasDapper
    }
}

# 9. MudBlazor
Write-Info "9. Verifica MudBlazor"
$webCsproj = Join-Path $workspace "Accredia.SIGAD.Web" "Accredia.SIGAD.Web.csproj"
if (Test-Path $webCsproj) {
    $content = Get-Content $webCsproj -Raw
    $hasMudBlazor = $content -match "MudBlazor"
    Test-Check "Web ha MudBlazor" $hasMudBlazor
}

# 10. YARP
Write-Info "10. Verifica YARP"
$gatewayCsproj = Join-Path $workspace "Accredia.SIGAD.Gateway" "Accredia.SIGAD.Gateway.csproj"
if (Test-Path $gatewayCsproj) {
    $content = Get-Content $gatewayCsproj -Raw
    $hasYarp = $content -match "Yarp"
    Test-Check "Gateway ha YARP" $hasYarp
}

# Riepilogo
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Riepilogo" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Passed:  $global:passed" -ForegroundColor Green
Write-Host "  Failed:  $global:failed" -ForegroundColor $(if ($global:failed -gt 0) { "Red" } else { "Green" })
Write-Host "  Skipped: $global:skipped" -ForegroundColor Yellow
Write-Host ""

if ($global:failed -gt 0) {
    Write-Host "ATTENZIONE: Alcuni check sono falliti!" -ForegroundColor Red
    exit 1
} else {
    Write-Host "Tutti i check passati!" -ForegroundColor Green
    exit 0
}
