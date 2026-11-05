CREATE VIEW ExtGIDAS.vw_MapNormaDiagnosi AS
    /* Norme SIDAC non ancora presenti nel mapping GIDAS */
    SELECT
        n.NormaAccreditamentoId,
        n.Codice                AS CodiceNorma,
        n.Riferimento,
        m.TargetNormaAccreditamentoId,
        m.IsApproved,
        CASE
            WHEN m.SourceValue IS NULL THEN 'MANCANTE'
            WHEN m.IsApproved  = 0     THEN 'NON_APPROVATO'
            ELSE                            'OK'
        END AS StatoMapping
    FROM Standard.NormaAccreditamento n
    LEFT JOIN ExtGIDAS.MapNormaAccreditamento m
           ON m.SourceValue = n.Codice
    WHERE n.DataCancellazione IS NULL
      AND n.Attivo = 1;

GO

