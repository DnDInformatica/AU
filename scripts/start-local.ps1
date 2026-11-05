param(
    [switch]$Build,
    [switch]$NoBuild = $true,
    [int]$WaitSeconds = 45
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $root

function Test-PortOpen {
    param(
        [Parameter(Mandatory = $true)][string]$Host,
        [Parameter(Mandatory = $true)][int]$Port,
        [int]$TimeoutMs = 1000
    )

    $client = New-Object System.Net.Sockets.TcpClient
    try {
        $iar = $client.BeginConnect($Host, $Port, $null, $null)
        if (-not $iar.AsyncWaitHandle.WaitOne($TimeoutMs, $false)) {
            return $false
        }

        $client.EndConnect($iar)
        return $true
    }
    catch {
        return $false
    }
    finally {
        $client.Dispose()
    }
}

function Test-HttpOk {
    param(
        [Parameter(Mandatory = $true)][string]$Url
    )

    try {
        $response = Invoke-WebRequest -UseBasicParsing -Uri $Url -TimeoutSec 3
        return ($response.StatusCode -ge 200 -and $response.StatusCode -lt 500)
    }
    catch {
        return $false
    }
}

$services = @(
    @{
        Name = 'Identity'
        Dir = '.\Accredia.SIGAD.Identity.Api'
        Url = 'http://127.0.0.1:7001'
        Probe = 'http://127.0.0.1:7001/swagger/v1/swagger.json'
    },
    @{
        Name = 'Anagrafiche'
        Dir = '.\Accredia.SIGAD.Anagrafiche.Api'
        Url = 'http://127.0.0.1:7003'
        Probe = 'http://127.0.0.1:7003/swagger/v1/swagger.json'
    },
    @{
        Name = 'Gateway'
        Dir = '.\Accredia.SIGAD.Gateway'
        Url = 'http://127.0.0.1:7100'
        Probe = 'http://127.0.0.1:7100/identity/swagger/'
    }
)

$logsDir = Join-Path $root 'logs'
New-Item -ItemType Directory -Force -Path $logsDir | Out-Null

if ($Build) {
    foreach ($service in $services) {
        $csproj = Get-ChildItem -Path $service.Dir -Filter *.csproj | Select-Object -First 1
        if (-not $csproj) {
            throw "Missing .csproj under $($service.Dir)"
        }

        Write-Host "Building $($service.Name)..."
        dotnet build $csproj.FullName -v minimal
    }
}

# Keep current values and restore them after process start.
$oldProvider = $env:DocumentStorage__Provider
$oldBasePath = $env:DocumentStorage__BasePath

foreach ($service in $services) {
    $uri = [uri]$service.Url
    $host = $uri.Host
    $port = $uri.Port

    if (Test-PortOpen -Host $host -Port $port) {
        Write-Host "$($service.Name) already listening on $($service.Url)."
        continue
    }

    $args = @('run')
    if ($NoBuild) {
        $args += '--no-build'
    }
    $args += @('--urls', $service.Url)

    $outLog = Join-Path $logsDir ("local-{0}.out.log" -f $service.Name.ToLowerInvariant())
    $errLog = Join-Path $logsDir ("local-{0}.err.log" -f $service.Name.ToLowerInvariant())

    if ($service.Name -eq 'Anagrafiche') {
        $env:DocumentStorage__Provider = 'Local'
        $env:DocumentStorage__BasePath = 'App_Data/PersonaDocumenti'
    }

    Write-Host "Starting $($service.Name) on $($service.Url)..."
    Start-Process -FilePath dotnet `
        -WorkingDirectory $service.Dir `
        -ArgumentList $args `
        -RedirectStandardOutput $outLog `
        -RedirectStandardError $errLog `
        | Out-Null
}

$env:DocumentStorage__Provider = $oldProvider
$env:DocumentStorage__BasePath = $oldBasePath

$deadline = (Get-Date).AddSeconds($WaitSeconds)
while ((Get-Date) -lt $deadline) {
    $allUp = $true
    foreach ($service in $services) {
        $uri = [uri]$service.Url
        if (-not (Test-PortOpen -Host $uri.Host -Port $uri.Port)) {
            $allUp = $false
            break
        }
    }

    if ($allUp) {
        break
    }

    Start-Sleep -Seconds 1
}

Write-Host ''
Write-Host 'Service status:'
foreach ($service in $services) {
    $uri = [uri]$service.Url
    $portUp = Test-PortOpen -Host $uri.Host -Port $uri.Port
    $httpUp = Test-HttpOk -Url $service.Probe
    Write-Host ("- {0}: Port={1} HttpProbe={2} Url={3}" -f $service.Name, $portUp, $httpUp, $service.Url)
}

Write-Host ''
Write-Host 'Useful URLs:'
Write-Host '  Identity:    http://127.0.0.1:7001/swagger'
Write-Host '  Anagrafiche: http://127.0.0.1:7003/swagger'
Write-Host '  Gateway:     http://127.0.0.1:7100'
