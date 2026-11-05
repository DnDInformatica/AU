param(
    [string]$ComposeFile = "docker-compose.staging.yml",
    [string]$HaComposeFile = "docker-compose.staging.ha.yml",
    [string]$EnvFile = ".env",
    [string]$WebUrl = "http://localhost:7010",
    [int]$TimeoutSeconds = 20,
    [switch]$Build
)

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Output "[STEP] $Message"
}

function Write-Pass {
    param([string]$Message)
    Write-Output "[PASS] $Message"
}

function Write-Fail {
    param([string]$Message)
    Write-Output "[FAIL] $Message"
}

function Wait-HttpOk {
    param(
        [string]$Url,
        [int]$TimeoutSeconds,
        [int]$IntervalSeconds = 2
    )

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    while ((Get-Date) -lt $deadline) {
        try {
            $r = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 8
            if ($r.StatusCode -eq 200) {
                return $r
            }
        }
        catch {
            Start-Sleep -Seconds $IntervalSeconds
            continue
        }
    }

    throw "Endpoint $Url non disponibile entro $TimeoutSeconds secondi."
}

Write-Step "Avvio stack HA Web (web + web2 + web-lb)..."
$upArgs = @("compose","-f",$ComposeFile,"-f",$HaComposeFile,"--env-file",$EnvFile,"up","-d")
if ($Build) {
    $upArgs += "--build"
}
$upArgs += @("web","web2","web-lb")
& docker @upArgs | Out-Null

Write-Step "Verifica endpoint Web bilanciato..."
$healthUrl = $WebUrl.TrimEnd("/") + "/health"
$resp = Wait-HttpOk -Url $healthUrl -TimeoutSeconds $TimeoutSeconds
if ($resp.StatusCode -ne 200) {
    Write-Fail "Web non raggiungibile: status $($resp.StatusCode)"
    exit 1
}
Write-Pass "Web health risponde 200 via LB."

Write-Step "Verifica sticky cookie e routing stabile..."
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$first = Invoke-WebRequest -Uri $WebUrl -UseBasicParsing -TimeoutSec $TimeoutSeconds -WebSession $session
$node1 = $first.Headers["X-Web-Node"]
$cookie = ($session.Cookies.GetCookies($WebUrl) | Where-Object { $_.Name -eq "WEBNODE" } | Select-Object -First 1)

if (-not $cookie) {
    Write-Fail "Cookie WEBNODE non presente: sticky session non attiva."
    exit 1
}

$second = Invoke-WebRequest -Uri $WebUrl -UseBasicParsing -TimeoutSec $TimeoutSeconds -WebSession $session
$node2 = $second.Headers["X-Web-Node"]

if ([string]::IsNullOrWhiteSpace($node1) -or [string]::IsNullOrWhiteSpace($node2)) {
    Write-Fail "Header X-Web-Node assente: impossibile validare sticky routing."
    exit 1
}

if ($node1 -ne $node2) {
    Write-Fail "Sticky session non valida: primo nodo '$node1', secondo nodo '$node2'."
    exit 1
}
Write-Pass "Sticky session valida su nodo '$node1' (cookie WEBNODE)."

Write-Step "Verifica key ring condiviso tra web e web2..."
$listWeb1 = & docker exec sigad-web sh -lc "ls -1 /keys 2>/dev/null | wc -l"
$listWeb2 = & docker exec sigad-web2 sh -lc "ls -1 /keys 2>/dev/null | wc -l"
$count1 = [int]("$listWeb1".Trim())
$count2 = [int]("$listWeb2".Trim())

if ($count1 -lt 1 -or $count2 -lt 1) {
    Write-Fail "Key ring non trovato su una o entrambe le istanze (web=$count1, web2=$count2)."
    exit 1
}
Write-Pass "Key ring condiviso presente (web=$count1, web2=$count2)."

Write-Output "[DONE] Validazione HA Web completata."
