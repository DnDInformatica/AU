param(
    [string]$EnvFile = ".env"
)

$ErrorActionPreference = "Stop"

function Read-EnvMap {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        throw "File env non trovato: $Path"
    }

    $map = @{}
    foreach ($line in Get-Content $Path) {
        $trim = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($trim) -or $trim.StartsWith("#")) {
            continue
        }

        $parts = $trim -split "=", 2
        if ($parts.Count -eq 2) {
            $map[$parts[0].Trim()] = $parts[1].Trim()
        }
    }

    return $map
}

function Is-WeakValue {
    param([string]$Key, [string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $true
    }

    $weakPatterns = @(
        "ChangeMe",
        "DEV_ONLY",
        "Password!12345",
        "localhost"
    )

    foreach ($p in $weakPatterns) {
        if ($Value -like "*$p*") {
            return $true
        }
    }

    if ($Key -eq "JWT_KEY" -and $Value.Length -lt 32) {
        return $true
    }

    if ($Key -eq "SQL_SA_PASSWORD" -and $Value.Length -lt 12) {
        return $true
    }

    return $false
}

$required = @(
    "SQL_SA_PASSWORD",
    "JWT_KEY"
)

$optionalRecommended = @(
    "DocumentStorage__WebDav__Password",
    "DataProtection__KeysPath"
)

$envMap = Read-EnvMap -Path $EnvFile
$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

foreach ($k in $required) {
    if (-not $envMap.ContainsKey($k)) {
        $errors.Add("Variabile obbligatoria mancante: $k")
        continue
    }

    if (Is-WeakValue -Key $k -Value $envMap[$k]) {
        $errors.Add("Variabile obbligatoria debole/non valida: $k")
    }
}

foreach ($k in $optionalRecommended) {
    if (-not $envMap.ContainsKey($k)) {
        $warnings.Add("Variabile consigliata assente: $k")
        continue
    }

    if (Is-WeakValue -Key $k -Value $envMap[$k]) {
        $warnings.Add("Variabile consigliata presente ma con valore debole: $k")
    }
}

Write-Output "[INFO] Preflight env M8 - file: $EnvFile"

if ($warnings.Count -gt 0) {
    foreach ($w in $warnings) {
        Write-Output "[WARN] $w"
    }
}

if ($errors.Count -gt 0) {
    foreach ($e in $errors) {
        Write-Output "[FAIL] $e"
    }
    exit 1
}

Write-Output "[PASS] Validazione env/segreti M8 completata."
