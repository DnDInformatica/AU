$ErrorActionPreference = 'Stop'
$radice = 'C:\Accredia\Sviluppo\AU\Accredia.SIGAD.RisorseUmane.Api\V1'
$aggiunti = 0
Get-ChildItem -Path $radice -Recurse -Filter 'Endpoints.cs' -File |
    Where-Object { $_.Directory.Name -ne 'Dipendenti' } |
    ForEach-Object {
        $righe = Get-Content -Path $_.FullName
        if ($righe -match 'using Accredia\.SIGAD\.Shared\.Auth;') { return }
        $uscita = New-Object System.Collections.Generic.List[string]
        $inserito = $false
        foreach ($riga in $righe) {
            if (-not $inserito -and $riga -match '^using ') {
                $uscita.Add('using Accredia.SIGAD.Shared.Auth;')
                $inserito = $true
            }
            $uscita.Add($riga)
        }
        if (-not $inserito) { $uscita.Insert(0, 'using Accredia.SIGAD.Shared.Auth;') }
        Set-Content -Path $_.FullName -Value $uscita -Encoding UTF8
        $aggiunti++
    }
Write-Output ("File con using aggiunto: " + $aggiunti)
