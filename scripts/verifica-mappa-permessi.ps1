$ErrorActionPreference = 'SilentlyContinue'
$radice = 'C:\Accredia\Sviluppo\AU\Accredia.SIGAD.RisorseUmane.Api\V1'
Get-ChildItem -Path $radice -Recurse -Filter 'Endpoints.cs' -File | ForEach-Object {
    $righe = Get-Content -Path $_.FullName
    $rottaCorrente = $null
    for ($i = 0; $i -lt $righe.Count; $i++) {
        if ($righe[$i] -match 'MapVersioned(Get|Post|Put|Delete|Patch)\(app, "([^"]+)"') {
            $rottaCorrente = $Matches[1].ToUpper().PadRight(6) + ' ' + $Matches[2]
        }
        if ($righe[$i] -match 'RichiedePermesso\((.+)\)' -and $rottaCorrente) {
            Write-Output ($rottaCorrente.PadRight(62) + ' -> ' + $Matches[1])
            $rottaCorrente = $null
        }
    }
}
