param(
    [string]$GatewayBaseUrl = "http://localhost:7100",
    [string]$Username = "admin",
    [string]$Password = $env:SIGAD_STAGING_ADMIN_PASSWORD,
    [string]$AffinityCookieName = "SIGAD_AFF",
    [int]$TimeoutSeconds = 20,
    [switch]$SkipLogin
)

$ErrorActionPreference = "Stop"
if (-not $SkipLogin -and [string]::IsNullOrWhiteSpace($Password)) {
    throw "Password assente: impostare la variabile d'ambiente SIGAD_STAGING_ADMIN_PASSWORD, passare -Password o usare -SkipLogin."
}
Add-Type -AssemblyName System.Net.Http

function Add-Result {
    param(
        [ref]$List,
        [string]$Name,
        [string]$Status,
        [string]$Detail
    )

    $List.Value.Add([pscustomobject]@{
        Check = $Name
        Status = $Status
        Detail = $Detail
    }) | Out-Null
}

function Invoke-Check {
    param(
        [string]$Name,
        [string]$Url,
        [string]$Method = "GET",
        [hashtable]$Headers,
        [string]$Body,
        [System.Net.CookieContainer]$CookieContainer
    )

    $httpMethod = switch ($Method.ToUpperInvariant()) {
        "GET" { [System.Net.Http.HttpMethod]::Get; break }
        "POST" { [System.Net.Http.HttpMethod]::Post; break }
        "PUT" { [System.Net.Http.HttpMethod]::Put; break }
        "PATCH" { [System.Net.Http.HttpMethod]::Patch; break }
        "DELETE" { [System.Net.Http.HttpMethod]::Delete; break }
        default { throw "HTTP method non supportato: $Method" }
    }

    $handler = New-Object System.Net.Http.HttpClientHandler
    $handler.CookieContainer = $CookieContainer
    $client = [System.Net.Http.HttpClient]::new($handler)
    $client.Timeout = [TimeSpan]::FromSeconds([Math]::Max(5, $TimeoutSeconds))

    try {
        $request = [System.Net.Http.HttpRequestMessage]::new($httpMethod, $Url)
        if ($Headers) {
            foreach ($k in $Headers.Keys) {
                $request.Headers.TryAddWithoutValidation($k, [string]$Headers[$k]) | Out-Null
            }
        }

        if ($Body) {
            $request.Content = [System.Net.Http.StringContent]::new($Body, [System.Text.Encoding]::UTF8, "application/json")
        }

        $response = $client.SendAsync($request).GetAwaiter().GetResult()
        $content = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
        return [pscustomobject]@{
            Ok = $response.IsSuccessStatusCode
            StatusCode = [int]$response.StatusCode
            Body = $content
            Headers = $response.Headers
        }
    }
    finally {
        $client.Dispose()
        $handler.Dispose()
    }
}

$results = [System.Collections.Generic.List[object]]::new()
$gateway = $GatewayBaseUrl.TrimEnd("/")
$cookies = New-Object System.Net.CookieContainer

try {
    $h1 = Invoke-Check -Name "Gateway health" -Url "$gateway/health" -CookieContainer $cookies
    Add-Result ([ref]$results) "Gateway /health" ($(if($h1.StatusCode -eq 200){"PASS"}else{"FAIL"})) "HTTP $($h1.StatusCode)"
}
catch {
    Add-Result ([ref]$results) "Gateway /health" "FAIL" $_.Exception.Message
}

try {
    $h2 = Invoke-Check -Name "Anagrafiche health proxy" -Url "$gateway/anagrafiche/health" -CookieContainer $cookies
    Add-Result ([ref]$results) "Gateway /anagrafiche/health" ($(if($h2.StatusCode -eq 200){"PASS"}else{"FAIL"})) "HTTP $($h2.StatusCode)"
}
catch {
    Add-Result ([ref]$results) "Gateway /anagrafiche/health" "FAIL" $_.Exception.Message
}

try {
    $h3 = Invoke-Check -Name "Storage health proxy" -Url "$gateway/anagrafiche/health/document-storage" -CookieContainer $cookies
    $status = if ($h3.StatusCode -eq 200 -or $h3.StatusCode -eq 503) { "PASS" } else { "FAIL" }
    Add-Result ([ref]$results) "Gateway /anagrafiche/health/document-storage" $status "HTTP $($h3.StatusCode) Body=$($h3.Body)"
}
catch {
    Add-Result ([ref]$results) "Gateway /anagrafiche/health/document-storage" "FAIL" $_.Exception.Message
}

if (-not $SkipLogin) {
    $token = $null
    try {
        $loginBody = "{`"username`":`"$Username`",`"password`":`"$Password`"}"
        $login = Invoke-Check -Name "Login" -Url "$gateway/identity/v1/auth/login" -Method "POST" -Body $loginBody -CookieContainer $cookies
        if ($login.StatusCode -eq 200) {
            $loginJson = $login.Body | ConvertFrom-Json
            $token = $loginJson.accessToken
            Add-Result ([ref]$results) "Gateway login" "PASS" "HTTP 200"
        }
        else {
            Add-Result ([ref]$results) "Gateway login" "FAIL" "HTTP $($login.StatusCode) Body=$($login.Body)"
        }
    }
    catch {
        Add-Result ([ref]$results) "Gateway login" "FAIL" $_.Exception.Message
    }

    if ($token) {
        try {
            $h4 = Invoke-Check -Name "Storage health auth" -Url "$gateway/anagrafiche/health/document-storage" -Headers @{ Authorization = "Bearer $token" } -CookieContainer $cookies
            $status = if ($h4.StatusCode -eq 200 -or $h4.StatusCode -eq 503) { "PASS" } else { "FAIL" }
            Add-Result ([ref]$results) "Gateway /anagrafiche/health/document-storage (auth)" $status "HTTP $($h4.StatusCode)"
        }
        catch {
            Add-Result ([ref]$results) "Gateway /anagrafiche/health/document-storage (auth)" "FAIL" $_.Exception.Message
        }
    }
}

try {
    # Check sticky-affinity behavior on repeated requests.
    $null = Invoke-Check -Name "Affinity probe 1" -Url "$gateway/health" -CookieContainer $cookies
    $null = Invoke-Check -Name "Affinity probe 2" -Url "$gateway/health" -CookieContainer $cookies
    $uri = [Uri]$gateway
    $affinityCookie = $cookies.GetCookies($uri) | Where-Object { $_.Name -eq $AffinityCookieName } | Select-Object -First 1
    if ($affinityCookie) {
        Add-Result ([ref]$results) "Session affinity cookie ($AffinityCookieName)" "PASS" "Cookie presente"
    }
    else {
        Add-Result ([ref]$results) "Session affinity cookie ($AffinityCookieName)" "WARN" "Cookie non rilevato (verificare ambiente multi-destination)."
    }
}
catch {
    Add-Result ([ref]$results) "Session affinity cookie ($AffinityCookieName)" "FAIL" $_.Exception.Message
}

$results | Format-Table -AutoSize

$failCount = ($results | Where-Object { $_.Status -eq "FAIL" }).Count
if ($failCount -gt 0) {
    exit 1
}

exit 0
