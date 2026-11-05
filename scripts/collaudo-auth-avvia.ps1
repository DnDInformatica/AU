$ErrorActionPreference = 'Continue'
Set-Location 'C:\Accredia\Sviluppo\AU'

# Ambiente: profilo di sviluppo attivo, MA senza SIGAD_DEV_OID.
# L'identita' puo' quindi arrivare solo dall'intestazione X-Dev-Oid: e' la
# condizione che rende probante il collaudo della propagazione sul BFF.
$env:ASPNETCORE_ENVIRONMENT = 'Development'
$env:DOTNET_ENVIRONMENT = 'Development'
$env:SIGAD_DEV_AUTH = '1'
Remove-Item Env:\SIGAD_DEV_OID -ErrorAction SilentlyContinue

Get-Process -Name 'Accredia.SIGAD*' -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

$servizi = @(
    @{ Nome = 'Tipologiche';  Dir = '.\Accredia.SIGAD.Tipologiche.Api';      Url = 'http://127.0.0.1:7002' },
    @{ Nome = 'RisorseUmane'; Dir = '.\Accredia.SIGAD.RisorseUmane.Api';     Url = 'http://127.0.0.1:7004' },
    @{ Nome = 'Bff';          Dir = '.\Accredia.SIGAD.RisorseUmane.Bff.Api'; Url = 'http://127.0.0.1:7005' }
)

$logDir = 'C:\Accredia\Sviluppo\AU\logs\collaudo-auth'
New-Item -ItemType Directory -Force -Path $logDir | Out-Null

foreach ($s in $servizi) {
    $log = Join-Path $logDir ("{0}.log" -f $s.Nome)
    $err = Join-Path $logDir ("{0}.err" -f $s.Nome)
    Start-Process -FilePath dotnet -WorkingDirectory $s.Dir `
        -ArgumentList @('run', '--no-build', '--urls', $s.Url) `
        -RedirectStandardOutput $log -RedirectStandardError $err | Out-Null
    Write-Output ("Avviato {0} su {1}" -f $s.Nome, $s.Url)
}

# Attesa disponibilita'
$attesa = 0
$pronti = $false
while ($attesa -lt 90 -and -not $pronti) {
    Start-Sleep -Seconds 5
    $attesa += 5
    $ok = 0
    foreach ($s in $servizi) {
        try {
            $r = Invoke-WebRequest -Uri ("{0}/health" -f $s.Url) -UseBasicParsing -TimeoutSec 5
            if ($r.StatusCode -eq 200) { $ok++ }
        } catch { }
    }
    if ($ok -eq $servizi.Count) { $pronti = $true }
    Write-Output ("Attesa {0}s - servizi pronti: {1}/{2}" -f $attesa, $ok, $servizi.Count)
}

if (-not $pronti) {
    Write-Output 'ATTENZIONE: non tutti i servizi rispondono. Ultime righe di errore:'
    Get-ChildItem -Path $logDir -Filter *.err | ForEach-Object {
        Write-Output ("--- {0} ---" -f $_.Name)
        Get-Content $_.FullName -Tail 8
    }
}
