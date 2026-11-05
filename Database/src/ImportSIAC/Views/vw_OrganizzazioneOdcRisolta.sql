CREATE   VIEW ImportSIAC.vw_OrganizzazioneOdcRisolta AS
SELECT o.CodOrganizzazione,o.OrganizzazioneId
FROM Organizzazioni.Organizzazione o
WHERE o.DataCancellazione IS NULL AND o.CodOrganizzazione IS NOT NULL
UNION ALL
SELECT m.CodEnte,m.OrganizzazioneId
FROM ImportSIAC.OrganizzazioneFonteOdcCopertura m
JOIN Organizzazioni.Organizzazione o ON o.OrganizzazioneId=m.OrganizzazioneId AND o.DataCancellazione IS NULL
WHERE m.Esito='COPERTO' AND m.OrganizzazioneId IS NOT NULL
  AND NOT EXISTS(SELECT 1 FROM Organizzazioni.Organizzazione d
                 WHERE d.CodOrganizzazione=m.CodEnte AND d.DataCancellazione IS NULL);

GO

