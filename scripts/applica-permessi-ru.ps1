$ErrorActionPreference = 'Stop'
$radice = 'C:\Accredia\Sviluppo\AU\Accredia.SIGAD.RisorseUmane.Api\V1'

# Mappa rotta -> famiglia di permessi, ricavata dalle regole oggi nel gateway.
function FamigliaDa($percorso) {
    if ($percorso -match 'contratti')               { return 'HR.CONTRATTI' }
    if ($percorso -match 'dotazioni')               { return 'HR.DOTAZIONI' }
    if ($percorso -match 'formazione')              { return 'HR.FORM' }
    if ($percorso -match 'dipendenti')              { return 'HR.DIP' }
    return $null
}

function PermessoDa($metodo, $famiglia) {
    switch ($metodo) {
        'Get'    { return '"' + $famiglia + '.LIST", "' + $famiglia + '.READ"' }
        'Post'   { return '"' + $famiglia + '.CREATE"' }
        'Put'    { return '"' + $famiglia + '.UPDATE"' }
        'Patch'  { return '"' + $famiglia + '.UPDATE"' }
        'Delete' { return '"' + $famiglia + '.DELETE"' }
    }
    return $null
}

$modifiche = 0
Get-ChildItem -Path $radice -Recurse -Filter 'Endpoints.cs' -File |
    Where-Object { $_.Directory.Name -ne 'Dipendenti' } |
    ForEach-Object {
    $file = $_.FullName
    $righe = Get-Content -Path $file
    $uscita = New-Object System.Collections.Generic.List[string]
    $metodoCorrente = $null
    $famigliaCorrente = $null

    for ($i = 0; $i -lt $righe.Count; $i++) {
        $riga = $righe[$i]

        if ($riga -match 'MapVersioned(Get|Post|Put|Delete|Patch)\(app, "([^"]+)"') {
            $metodoCorrente = $Matches[1]
            $percorso = $Matches[2]
            $famigliaCorrente = FamigliaDa $percorso
            # I report seguono il permesso di lettura del dominio che espongono.
            if ($percorso -match 'report/formazione')  { $famigliaCorrente = 'HR.FORM' }
            if ($percorso -match 'report/dotazioni')   { $famigliaCorrente = 'HR.DOTAZIONI' }
        }

        # La prima riga 'builder => builder' dopo una rotta e' il punto di innesto.
        if ($metodoCorrente -and $riga -match '^\s*builder => builder\s*$') {
            $uscita.Add($riga)
            $giaProtetta = ($i + 1 -lt $righe.Count) -and ($righe[$i + 1] -match 'RichiedePermesso')
            $permesso = PermessoDa $metodoCorrente $famigliaCorrente
            if ($permesso -and -not $giaProtetta) {
                $indent = ($riga -replace '\S.*$', '')
                $uscita.Add($indent + '    .RichiedePermesso(' + $permesso + ')')
                $modifiche++
            }
            $metodoCorrente = $null
            continue
        }

        $uscita.Add($riga)
    }

    Set-Content -Path $file -Value $uscita -Encoding UTF8
}
Write-Output ("Rotte protette: " + $modifiche)
