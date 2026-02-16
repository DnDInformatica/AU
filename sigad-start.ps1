param(
    [switch]$Build,
    [switch]$NoBuild = $true
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

# Prefer an already configured package cache; otherwise fall back to a writable location.
if (-not $env:NUGET_PACKAGES) {
    $defaultNuget = Join-Path $env:USERPROFILE '.nuget\packages'
    $fallbackNuget = 'C:\Users\g.denicolo\.nuget\packages'
    $repoNuget = Join-Path $root '.nuget\packages'

    if (Test-Path $defaultNuget) {
        $env:NUGET_PACKAGES = $defaultNuget
    } elseif (Test-Path $fallbackNuget) {
        $env:NUGET_PACKAGES = $fallbackNuget
    } else {
        $env:NUGET_PACKAGES = $repoNuget
        New-Item -ItemType Directory -Force -Path $env:NUGET_PACKAGES | Out-Null
    }
}

$env:ASPNETCORE_ENVIRONMENT = 'Development'
$env:DOTNET_ENVIRONMENT = 'Development'

$projects = @(
    @{ Name = 'Identity';    Dir = '.\Accredia.SIGAD.Identity.Api';    Url = 'http://127.0.0.1:7001' },
    @{ Name = 'Tipologiche'; Dir = '.\Accredia.SIGAD.Tipologiche.Api'; Url = 'http://127.0.0.1:7002' },
    @{ Name = 'Anagrafiche'; Dir = '.\Accredia.SIGAD.Anagrafiche.Api'; Url = 'http://127.0.0.1:7003' },
    @{ Name = 'RisorseUmane'; Dir = '.\Accredia.SIGAD.RisorseUmane.Api'; Url = 'http://127.0.0.1:7004' },
    @{ Name = 'RisorseUmaneBff'; Dir = '.\Accredia.SIGAD.RisorseUmane.Bff.Api'; Url = 'http://127.0.0.1:7005' },
    @{ Name = 'Gateway';     Dir = '.\Accredia.SIGAD.Gateway';         Url = 'http://127.0.0.1:7100' }
)

if ($Build) {
    foreach ($p in $projects) {
        Write-Host "Building $($p.Name)..."
        $csproj = Get-ChildItem -Path $p.Dir -Filter *.csproj | Select-Object -First 1
        if (-not $csproj) {
            throw "Missing .csproj under $($p.Dir)"
        }
        dotnet build $csproj.FullName -v minimal
    }
}

$logsDir = Join-Path $root 'logs'
New-Item -ItemType Directory -Force -Path $logsDir | Out-Null

foreach ($p in $projects) {
    $log = Join-Path $logsDir ("sigad-{0}.log" -f $p.Name.ToLowerInvariant())
    $err = Join-Path $logsDir ("sigad-{0}.err" -f $p.Name.ToLowerInvariant())

    Write-Host "Starting $($p.Name) on $($p.Url)..."

    $runArgs = @('run')
    if ($NoBuild) {
        $runArgs += '--no-build'
    }
    $runArgs += @('--urls', $p.Url)

    Start-Process -FilePath dotnet `
        -WorkingDirectory $p.Dir `
        -ArgumentList $runArgs `
        -RedirectStandardOutput $log `
        -RedirectStandardError $err `
        | Out-Null
}

Write-Host "Started. Swagger via gateway:"
Write-Host "  http://127.0.0.1:7100/anagrafiche/swagger/"
Write-Host "  http://127.0.0.1:7100/risorseumane/swagger/"
Write-Host "  http://127.0.0.1:7100/bff/risorseumane/swagger/"
Write-Host "  http://127.0.0.1:7100/identity/swagger/"
Write-Host "  http://127.0.0.1:7100/tipologiche/swagger/"
