$ErrorActionPreference = 'Continue'

# Utenza censita in IAM.Utente (UtenteId=4, admin@accredia.local).
$oidCensito   = '885f0c42-97b7-4ab0-b171-d6372d6bdf10'
# Identita' inesistente: e' il caso che DEVE fallire.
$oidSconosciuto = '00000000-dead-beef-0000-000000000000'

function Invoca {
    param([string]$Etichetta, [string]$Url, [string]$Oid)
    $intestazioni = @{}
    if ($Oid) { $intestazioni['X-Dev-Oid'] = $Oid }
    try {
        $r = Invoke-WebRequest -Uri $Url -Headers $intestazioni -UseBasicParsing -TimeoutSec 30
        $corpo = ''
        if ($r.Content.Length -gt 0) { $corpo = $r.Content.Substring(0, [Math]::Min(90, $r.Content.Length)) }
        Write-Output ("{0,-46} -> {1}  {2}" -f $Etichetta, [int]$r.StatusCode, $corpo)
    } catch {
        $risposta = $_.Exception.Response
        if ($risposta) {
            $codice = [int]$risposta.StatusCode
            $lettore = New-Object System.IO.StreamReader($risposta.GetResponseStream())
            $corpo = $lettore.ReadToEnd()
            $lettore.Close()
            if ($corpo.Length -gt 90) { $corpo = $corpo.Substring(0, 90) }
            Write-Output ("{0,-46} -> {1}  {2}" -f $Etichetta, $codice, $corpo)
        } else {
            Write-Output ("{0,-46} -> ERRORE  {1}" -f $Etichetta, $_.Exception.Message)
        }
    }
}

Write-Output ''
Write-Output '--- Tipologiche.Api (7002) : risoluzione su IAM ---'
Invoca 'lookups / identita censita'          'http://127.0.0.1:7002/v1/lookups' $oidCensito
Invoca 'lookups / identita SCONOSCIUTA'      'http://127.0.0.1:7002/v1/lookups' $oidSconosciuto
Invoca 'lookups / nessuna identita'          'http://127.0.0.1:7002/v1/lookups' $null

Write-Output ''
Write-Output '--- RisorseUmane.Api (7004) : risoluzione su IAM ---'
Invoca 'dipendenti / identita censita'       'http://127.0.0.1:7004/v1/dipendenti?page=1&pageSize=1' $oidCensito
Invoca 'dipendenti / identita SCONOSCIUTA'   'http://127.0.0.1:7004/v1/dipendenti?page=1&pageSize=1' $oidSconosciuto
Invoca 'dipendenti / nessuna identita'       'http://127.0.0.1:7004/v1/dipendenti?page=1&pageSize=1' $null

Write-Output ''
Write-Output '--- Bff (7005) : propagazione verso RisorseUmane ---'
Write-Output '    con identita sconosciuta il BFF non blocca, ma la chiamata a valle'
Write-Output '    deve essere respinta: se qui tornasse 200 la propagazione non funziona.'
Invoca 'report / identita censita'           'http://127.0.0.1:7005/v1/report/formazione-in-scadenza?days=30' $oidCensito
Invoca 'report / identita SCONOSCIUTA'       'http://127.0.0.1:7005/v1/report/formazione-in-scadenza?days=30' $oidSconosciuto
Invoca 'report / nessuna identita'           'http://127.0.0.1:7005/v1/report/formazione-in-scadenza?days=30' $null
