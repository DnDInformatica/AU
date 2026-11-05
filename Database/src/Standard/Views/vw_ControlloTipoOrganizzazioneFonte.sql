CREATE   VIEW Standard.vw_ControlloTipoOrganizzazioneFonte AS
SELECT N'CooperazioneAccreditamento' AS Ruolo, c.CooperazioneAccreditamentoId AS RuoloId, c.OrganizzazioneId, o.TipoOrganizzazioneId, 21 AS TipoAtteso
FROM Standard.CooperazioneAccreditamento c
JOIN Organizzazioni.Organizzazione o ON o.OrganizzazioneId = c.OrganizzazioneId
WHERE c.DataCancellazione IS NULL AND ISNULL(o.TipoOrganizzazioneId,-1) <> 21
UNION ALL
SELECT N'Regolatore', r.RegolatoreId, r.OrganizzazioneId, o.TipoOrganizzazioneId, 20
FROM Standard.Regolatore r
JOIN Organizzazioni.Organizzazione o ON o.OrganizzazioneId = r.OrganizzazioneId
WHERE r.DataCancellazione IS NULL AND r.OrganizzazioneId IS NOT NULL AND ISNULL(o.TipoOrganizzazioneId,-1) <> 20;

GO

