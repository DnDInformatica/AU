$ErrorActionPreference = 'Continue'

# Utenza 4: admin, con ruolo SIGAD_SUPERADMIN -> dispone dei permessi HR.
$oidConPermesso = '885f0c42-97b7-4ab0-b171-d6372d6bdf10'
# Utenza 7: hr.readonly, censita in IAM ma senza alcun ruolo -> nessun permesso.
$oidSenzaPermesso = '7F33C1D6-DCF1-4298-BF5B-626BC48E621F'
# Identita' inesistente in IAM.
$oidSconosciuto = '00000000-dead-beef-0000-000000000000'

function Invoca {
    param([string]$Etichetta, [string]$Url, [string]$Oid)
    $intestazioni = @{}
    if ($Oid) { $intestazioni['X-Dev-Oid'] = $Oid }
    try {
        $r = Invoke-WebRequest -Uri $Url -Headers $intestazioni -UseBasicParsing -TimeoutSec 30
        $corpo = ''
        if ($r.Content.Length -gt 0) { $corpo = $r.Content.Substring(0, [Math]::Min(70, $r.Content.Length)) }
        Write-Output ("{0,-44} -> {1}  {2}" -f $Etichetta, [int]$r.StatusCode, $corpo)
    } catch {
        $risposta = $_.Exception.Response
        if ($risposta) {
            $codice = [int]$risposta.StatusCode
            $lettore = New-Object System.IO.StreamReader($risposta.GetResponseStream())
            $corpo = $lettore.ReadToEnd(); $lettore.Close()
            if ($corpo.Length -gt 70) { $corpo = $corpo.Substring(0, 70) }
            Write-Output ("{0,-44} -> {1}  {2}" -f $Etichetta, $codice, $corpo)
        } else {
            Write-Output ("{0,-44} -> ERRORE  {1}" -f $Etichetta, $_.Exception.Message)
        }
    }
}

$base = 'http://127.0.0.1:7004/v1'
Write-Output ''
Write-Output '--- Il caso che deve riuscire ---'
Invoca 'dipendenti / utenza CON permesso'        "$base/dipendenti?page=1&pageSize=1" $oidConPermesso

Write-Output ''
Write-Output '--- I casi che devono fallire, ciascuno in modo diverso ---'
Invoca 'dipendenti / censita SENZA permesso'     "$base/dipendenti?page=1&pageSize=1" $oidSenzaPermesso
Invoca 'dipendenti / identita SCONOSCIUTA'       "$base/dipendenti?page=1&pageSize=1" $oidSconosciuto
Invoca 'dipendenti / NESSUNA credenziale'        "$base/dipendenti?page=1&pageSize=1" $null

Write-Output ''
Write-Output '--- Verifica su altre famiglie di permesso ---'
Invoca 'report formazione / CON permesso'        "$base/report/formazione-in-scadenza?days=30" $oidConPermesso
Invoca 'report formazione / SENZA permesso'      "$base/report/formazione-in-scadenza?days=30" $oidSenzaPermesso
Invoca 'contratti / SENZA permesso'              "$base/contratti/1" $oidSenzaPermesso

Write-Output ''
Write-Output '--- Rotta non protetta: deve restare raggiungibile ---'
Invoca 'health / nessuna credenziale'            'http://127.0.0.1:7004/health' $null
