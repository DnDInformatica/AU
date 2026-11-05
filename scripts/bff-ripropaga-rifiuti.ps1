$ErrorActionPreference = 'Stop'
$file = 'C:\Accredia\Sviluppo\AU\Accredia.SIGAD.RisorseUmane.Bff.Api\V1\Features\DipendentiDettaglio\Endpoints.cs'
$testo = Get-Content -Path $file -Raw

# 1) Rifiuti provenienti da RisorseUmane: ripropagati invece che tradotti in 503.
$vecchio1 = 'return Results.Problem("Downstream RisorseUmane error.", statusCode: StatusCodes.Status503ServiceUnavailable);'
$nuovo1 = 'return RispostaDownstream.Problema(hrStatus, "RisorseUmane");'
$n1 = ([regex]::Matches($testo, [regex]::Escape($vecchio1))).Count
$testo = $testo.Replace($vecchio1, $nuovo1)

# 2) Esito singolo da Anagrafiche, gia' mappato a codice intero.
$vecchio2 = @'
                    return result.StatusCode == StatusCodes.Status502BadGateway
                        ? Results.Problem("Persona not found in Anagrafiche.", statusCode: StatusCodes.Status502BadGateway)
                        : Results.Problem("Downstream Anagrafiche error.", statusCode: StatusCodes.Status503ServiceUnavailable);
'@
$nuovo2 = @'
                    return RispostaDownstream.ProblemaDaCodice(result.StatusCode, "Anagrafiche");
'@
$n2 = ([regex]::Matches($testo, [regex]::Escape($vecchio2))).Count
$testo = $testo.Replace($vecchio2, $nuovo2)

# 3) Primo errore in una raccolta di chiamate parallele (due varianti di nome campo).
$vecchio3 = @'
                    return firstError.Item2 == StatusCodes.Status502BadGateway
                        ? Results.Problem("Persona not found in Anagrafiche.", statusCode: StatusCodes.Status502BadGateway)
                        : Results.Problem("Downstream Anagrafiche error.", statusCode: StatusCodes.Status503ServiceUnavailable);
'@
$nuovo3 = @'
                    return RispostaDownstream.ProblemaDaCodice(firstError.Item2, "Anagrafiche");
'@
$n3 = ([regex]::Matches($testo, [regex]::Escape($vecchio3))).Count
$testo = $testo.Replace($vecchio3, $nuovo3)

$vecchio4 = @'
                    return firstError.StatusCode == StatusCodes.Status502BadGateway
                        ? Results.Problem("Persona not found in Anagrafiche.", statusCode: StatusCodes.Status502BadGateway)
                        : Results.Problem("Downstream Anagrafiche error.", statusCode: StatusCodes.Status503ServiceUnavailable);
'@
$nuovo4 = @'
                    return RispostaDownstream.ProblemaDaCodice(firstError.StatusCode, "Anagrafiche");
'@
$n4 = ([regex]::Matches($testo, [regex]::Escape($vecchio4))).Count
$testo = $testo.Replace($vecchio4, $nuovo4)

# 5) Esiti diretti da Anagrafiche nell'endpoint di dettaglio e nella ricerca.
$vecchio5 = 'return Results.Problem("Downstream Anagrafiche error.", statusCode: StatusCodes.Status503ServiceUnavailable);'
$nuovo5 = 'return RispostaDownstream.Problema(anStatus, "Anagrafiche");'
$n5 = ([regex]::Matches($testo, [regex]::Escape($vecchio5))).Count
$testo = $testo.Replace($vecchio5, $nuovo5)

# 6) Dichiarazione dei codici prodotti, per la documentazione dell'interfaccia.
$vecchio6 = '                .ProducesProblem(StatusCodes.Status503ServiceUnavailable));'
$nuovo6 = @'
                .ProducesProblem(StatusCodes.Status401Unauthorized)
                .ProducesProblem(StatusCodes.Status403Forbidden)
                .ProducesProblem(StatusCodes.Status503ServiceUnavailable));
'@
$n6 = ([regex]::Matches($testo, [regex]::Escape($vecchio6))).Count
$testo = $testo.Replace($vecchio6, $nuovo6.TrimEnd())

Set-Content -Path $file -Value $testo -Encoding UTF8 -NoNewline
Write-Output "RisorseUmane: $n1 | risultato singolo: $n2 | Item2: $n3 | StatusCode: $n4 | Anagrafiche diretto: $n5 | dichiarazioni: $n6"
Write-Output "Residui non convertiti:"
Select-String -Path $file -Pattern 'Downstream .* error|Persona not found' | ForEach-Object { '  riga ' + $_.LineNumber + ': ' + $_.Line.Trim() }
