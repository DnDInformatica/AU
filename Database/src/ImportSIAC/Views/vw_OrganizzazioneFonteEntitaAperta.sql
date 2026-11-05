CREATE   VIEW ImportSIAC.vw_OrganizzazioneFonteEntitaAperta
AS
SELECT e.*
FROM ImportSIAC.OrganizzazioneFonteEntita e
LEFT JOIN Organizzazioni.Organizzazione o ON o.OrganizzazioneId=e.OrganizzazioneId
WHERE e.OrganizzazioneId IS NULL OR o.OrganizzazioneId IS NULL OR o.DataCancellazione IS NOT NULL;

GO

