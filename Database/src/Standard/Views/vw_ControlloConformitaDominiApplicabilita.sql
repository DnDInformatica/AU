
CREATE   VIEW Standard.vw_ControlloConformitaDominiApplicabilita
AS
    SELECT
        CONVERT(nvarchar(100), N'CLASSIFICAZIONE_SENZA_DOMINIO_PRIMARIO')
            AS Anomalia,
        g.ClassificazioneId AS Id,
        CONCAT
        (
            N'Classificazione ',
            c.Codice,
            N' priva di un unico dominio semantico primario attivo.'
        ) AS Dettaglio
    FROM Standard.ClassificazioneGovernance g
    JOIN Standard.Classificazione c
      ON c.ClassificazioneId = g.ClassificazioneId
    OUTER APPLY
    (
        SELECT COUNT(*) AS NumeroPrimari
        FROM Standard.ClassificazioneDominioSemantico cd
        WHERE cd.ClassificazioneId = g.ClassificazioneId
          AND cd.RuoloDominio = N'PRIMARIO'
          AND cd.Attivo = 1
          AND cd.DataCancellazione IS NULL
    ) p
    WHERE g.Attivo = 1
      AND g.DataCancellazione IS NULL
      AND p.NumeroPrimari <> 1

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'DOMINIO_CLASSIFICAZIONE_NON_ATTIVO'),
        cd.ClassificazioneDominioSemanticoId,
        CONCAT
        (
            N'Relazione dominio ',
            cd.ClassificazioneDominioSemanticoId,
            N' con classificazione o dominio assente, inattivo o cancellato.'
        )
    FROM Standard.ClassificazioneDominioSemantico cd
    LEFT JOIN Standard.Classificazione c
      ON c.ClassificazioneId = cd.ClassificazioneId
     AND c.Attivo = 1

     AND c.DataCancellazione IS NULL
    LEFT JOIN Standard.DominioSemantico d
      ON d.DominioSemanticoId = cd.DominioSemanticoId
     AND d.Attivo = 1
     AND d.DataCancellazione IS NULL
    WHERE cd.Attivo = 1
      AND cd.DataCancellazione IS NULL
      AND
      (
          c.ClassificazioneId IS NULL
          OR d.DominioSemanticoId IS NULL
      )

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'DOMINIO_RIFERIMENTO_NON_ATTIVO'),
        cd.ClassificazioneDominioSemanticoId,
        CONCAT
        (
            N'Relazione dominio ',
            cd.ClassificazioneDominioSemanticoId,
            N' con riferimento documentale inattivo o cancellato.'
        )
    FROM Standard.ClassificazioneDominioSemantico cd
    LEFT JOIN Standard.RiferimentoDocumentale rd
      ON rd.RiferimentoDocumentaleId = cd.RiferimentoDocumentaleId
     AND rd.Attivo = 1
     AND rd.DataCancellazione IS NULL
    WHERE cd.Attivo = 1
      AND cd.DataCancellazione IS NULL
      AND cd.RiferimentoDocumentaleId IS NOT NULL
      AND rd.RiferimentoDocumentaleId IS NULL

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'APPLICABILITA_ESTREMI_NON_ATTIVI'),
        a.ClassificazioneSchemaAccreditamentoId,
        CONCAT
        (
            N'Applicabilita ',
            a.ClassificazioneSchemaAccreditamentoId,
            N' con classificazione, schema o documento non attivo.'
        )
    FROM Standard.ClassificazioneSchemaAccreditamento a
    LEFT JOIN Standard.Classificazione c
      ON c.ClassificazioneId = a.ClassificazioneId
     AND c.Attivo = 1
     AND c.DataCancellazione IS NULL
    LEFT JOIN Standard.SchemaAccreditamento sa
      ON sa.SchemaAccreditamentoId = a.SchemaAccreditamentoId
     AND sa.Attivo = 1
     AND sa.DataCancellazione IS NULL
    LEFT JOIN Standard.RiferimentoDocumentale rd
      ON rd.RiferimentoDocumentaleId = a.RiferimentoDocumentaleId
     AND rd.Attivo = 1
     AND rd.DataCancellazione IS NULL
    WHERE a.Attivo = 1
      AND a.DataCancellazione IS NULL
      AND
      (
          c.ClassificazioneId IS NULL
          OR sa.SchemaAccreditamentoId IS NULL
          OR rd.RiferimentoDocumentaleId IS NULL
      );

GO

