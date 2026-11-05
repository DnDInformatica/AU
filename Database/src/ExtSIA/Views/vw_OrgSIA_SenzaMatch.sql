CREATE VIEW ExtSIA.vw_OrgSIA_SenzaMatch AS
    SELECT
        o.CodiceEnte, o.Denominazione, o.CodiceFiscale,
        o.PartitaIva, o.CodiceGamma, o.CodiceSIA,
        o.NormalizationStatus,
        CASE WHEN c.CrossRefOrganizzazioneMapId IS NULL
             THEN N'MANCANTE' ELSE c.Status END AS SituazioneCrossRef
    FROM ExtSIA.SIA_StgOrganizzazione o
    LEFT JOIN ExtSIA.CrossRef_OrganizzazioneMap c
           ON (c.CodiceFiscale = o.CodiceFiscale
            OR c.CodiceSIA     = o.CodiceSIA)
          AND c.DataCancellazione IS NULL
    WHERE o.DataCancellazione IS NULL
      AND (c.CrossRefOrganizzazioneMapId IS NULL
        OR c.Status IN (N'PENDING', N'AMBIGUOUS'));

GO

