CREATE VIEW ExtSIA.vw_OrgSIAT_SenzaMatch AS
    SELECT
        o.CodiceEnte, o.Denominazione, o.CodiceFiscale,
        o.PartitaIva, o.CodiceGamma, o.CodiceSIAT,
        o.NormalizationStatus,
        CASE WHEN c.CrossRefOrganizzazioneMapId IS NULL
             THEN N'MANCANTE' ELSE c.Status END AS SituazioneCrossRef
    FROM ExtSIA.SIAT_StgOrganizzazione o
    LEFT JOIN ExtSIA.CrossRef_OrganizzazioneMap c
           ON (c.CodiceFiscale = o.CodiceFiscale
            OR c.CodiceSIAT   = o.CodiceSIAT)
          AND c.DataCancellazione IS NULL
    WHERE o.DataCancellazione IS NULL
      AND (c.CrossRefOrganizzazioneMapId IS NULL
        OR c.Status IN (N'PENDING', N'AMBIGUOUS'));

GO

