
CREATE   VIEW Standard.vw_ControlloConformitaAttivitaEconomiche
AS
    SELECT
        CONVERT(nvarchar(100), N'DECORRENZA_ESTREMI_NON_ATTIVI')
            AS Anomalia,
        d.ClassificazioneVersioneDecorrenzaId AS Id,
        CONCAT
        (
            N'Decorrenza ',
            d.ClassificazioneVersioneDecorrenzaId,
            N' con versione, tipo o documento assente/inattivo.'
        ) AS Dettaglio
    FROM Standard.ClassificazioneVersioneDecorrenza d
    LEFT JOIN Standard.ClassificazioneVersione v
      ON v.ClassificazioneVersioneId = d.ClassificazioneVersioneId
     AND v.ClassificazioneId = d.ClassificazioneId
     AND v.DataCancellazione IS NULL
    LEFT JOIN Standard.TipoDecorrenzaClassificazione t
      ON t.TipoDecorrenzaClassificazioneId =
         d.TipoDecorrenzaClassificazioneId
     AND t.Attivo = 1
     AND t.DataCancellazione IS NULL
    LEFT JOIN Standard.RiferimentoDocumentale r
      ON r.RiferimentoDocumentaleId = d.RiferimentoDocumentaleId
     AND r.Attivo = 1
     AND r.DataCancellazione IS NULL
    WHERE d.Attivo = 1
      AND d.DataCancellazione IS NULL
      AND
      (
          v.ClassificazioneVersioneId IS NULL
          OR t.TipoDecorrenzaClassificazioneId IS NULL
          OR r.RiferimentoDocumentaleId IS NULL
      )

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'APPLICABILITA_ORGANIZZAZIONE_NON_ATTIVA'),
        a.ClassificazioneId,
        CONCAT
        (
            N'Applicabilita organizzazione della classificazione ',
            a.ClassificazioneId,
            N' con classificazione o documento assente/inattivo.'
        )
    FROM Standard.ClassificazioneApplicabilitaOrganizzazione a
    LEFT JOIN Standard.Classificazione c
      ON c.ClassificazioneId = a.ClassificazioneId
     AND c.Attivo = 1
     AND c.DataCancellazione IS NULL
    LEFT JOIN Standard.RiferimentoDocumentale r
      ON r.RiferimentoDocumentaleId = a.RiferimentoDocumentaleId
     AND r.Attivo = 1
     AND r.DataCancellazione IS NULL
    WHERE a.Attivo = 1
      AND a.DataCancellazione IS NULL
      AND
      (
          c.ClassificazioneId IS NULL
          OR r.RiferimentoDocumentaleId IS NULL
      )

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'ATTIVITA_ORGANIZZAZIONE_ESTREMI_NON_ATTIVI'),
        a.OrganizzazioneAttivitaEconomicaId,
        CONCAT
        (
            N'Attivita economica ',
            a.OrganizzazioneAttivitaEconomicaId,
            N' con organizzazione, voce, versione o applicabilita non attiva.'
        )
    FROM Organizzazioni.OrganizzazioneAttivitaEconomica a
    LEFT JOIN Organizzazioni.Organizzazione o
      ON o.OrganizzazioneId = a.OrganizzazioneId
     AND o.DataCancellazione IS NULL
    LEFT JOIN Standard.VoceClassificazione v
      ON v.VoceClassificazioneId = a.VoceClassificazioneId
     AND v.ClassificazioneVersioneId = a.ClassificazioneVersioneId
     AND v.ClassificazioneId = a.ClassificazioneId
     AND v.Attivo = 1
     AND v.DataCancellazione IS NULL
    LEFT JOIN Standard.ClassificazioneVersione cv
      ON cv.ClassificazioneVersioneId = a.ClassificazioneVersioneId
     AND cv.ClassificazioneId = a.ClassificazioneId
     AND cv.DataCancellazione IS NULL
    LEFT JOIN Standard.ClassificazioneApplicabilitaOrganizzazione ap
      ON ap.ClassificazioneId = a.ClassificazioneId
     AND ap.Attivo = 1
     AND ap.DataCancellazione IS NULL
    WHERE a.Attivo = 1
      AND a.DataCancellazione IS NULL
      AND
      (
          o.OrganizzazioneId IS NULL
          OR v.VoceClassificazioneId IS NULL
          OR cv.ClassificazioneVersioneId IS NULL
          OR ap.ClassificazioneId IS NULL
      )

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'ATTIVITA_ORGANIZZAZIONE_FUORI_VERSIONE'),
        a.OrganizzazioneAttivitaEconomicaId,
        CONCAT
        (
            N'Attivita economica ',
            a.OrganizzazioneAttivitaEconomicaId,
            N' con periodo esterno all applicazione della versione ',
            cv.Codice,
            N'.'
        )
    FROM Organizzazioni.OrganizzazioneAttivitaEconomica a
    JOIN Standard.ClassificazioneVersione cv
      ON cv.ClassificazioneVersioneId = a.ClassificazioneVersioneId
     AND cv.ClassificazioneId = a.ClassificazioneId
     AND cv.DataCancellazione IS NULL
    WHERE a.Attivo = 1
      AND a.DataCancellazione IS NULL
      AND
      (
          (
              a.DataInizioAttribuzione IS NOT NULL
              AND cv.DataFineApplicazione IS NOT NULL
              AND a.DataInizioAttribuzione > cv.DataFineApplicazione
          )
          OR
          (
              a.DataFineAttribuzione IS NOT NULL
              AND a.DataFineAttribuzione < cv.DataInizioApplicazione
          )
      )

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'VERIFICA_ATTIVITA_ESTREMI_NON_CORRENTI'),
        x.OrganizzazioneAttivitaEconomicaVerificaId,
        CONCAT
        (
            N'Verifica attivita ',
            x.OrganizzazioneAttivitaEconomicaVerificaId,
            N' con attribuzione o visura assente/cancellata.'
        )
    FROM Organizzazioni.OrganizzazioneAttivitaEconomicaVerifica x
    LEFT JOIN Organizzazioni.OrganizzazioneAttivitaEconomica a
      ON a.OrganizzazioneAttivitaEconomicaId =
         x.OrganizzazioneAttivitaEconomicaId
     AND a.OrganizzazioneId = x.OrganizzazioneId
     AND a.DataCancellazione IS NULL
    LEFT JOIN Organizzazioni.VisuraSnapshot s
      ON s.VisuraSnapshotId = x.VisuraSnapshotId
     AND s.OrganizzazioneId = x.OrganizzazioneId
     AND s.DataCancellazione IS NULL
    WHERE x.Attivo = 1
      AND x.DataCancellazione IS NULL
      AND
      (
          a.OrganizzazioneAttivitaEconomicaId IS NULL
          OR s.VisuraSnapshotId IS NULL
      )

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'VERIFICA_ANTERIORE_ALLA_VISURA'),
        x.OrganizzazioneAttivitaEconomicaVerificaId,
        CONCAT
        (
            N'Verifica attivita ',
            x.OrganizzazioneAttivitaEconomicaVerificaId,
            N' anteriore alla data di estrazione della visura.'
        )
    FROM Organizzazioni.OrganizzazioneAttivitaEconomicaVerifica x
    JOIN Organizzazioni.VisuraSnapshot s
      ON s.VisuraSnapshotId = x.VisuraSnapshotId
     AND s.OrganizzazioneId = x.OrganizzazioneId
    WHERE x.Attivo = 1
      AND x.DataCancellazione IS NULL
      AND x.DataVerifica < s.DataEstrazioneVisura

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'VERIFICA_DIFFORME_MA_VOCE_UGUALE'),
        x.OrganizzazioneAttivitaEconomicaVerificaId,
        CONCAT
        (
            N'Verifica attivita ',
            x.OrganizzazioneAttivitaEconomicaVerificaId,
            N' dichiarata difforme ma riferita alla stessa voce ATECO.'
        )
    FROM Organizzazioni.OrganizzazioneAttivitaEconomicaVerifica x
    JOIN Organizzazioni.OrganizzazioneAttivitaEconomica a
      ON a.OrganizzazioneAttivitaEconomicaId =
         x.OrganizzazioneAttivitaEconomicaId
     AND a.OrganizzazioneId = x.OrganizzazioneId
    -- 14/08/2026: Esito sostituito da EsitoVerificaAttivitaEconomicaId (lotto 3).
    JOIN Tipologica.EsitoVerificaAttivitaEconomica e
      ON e.EsitoVerificaAttivitaEconomicaId =
         x.EsitoVerificaAttivitaEconomicaId
    WHERE x.Attivo = 1
      AND x.DataCancellazione IS NULL
      AND e.Codice = N'DIFFORME'
      AND x.VoceClassificazioneRilevataId =
          a.VoceClassificazioneId
      AND x.ClassificazioneVersioneRilevataId =
          a.ClassificazioneVersioneId
      AND x.ClassificazioneRilevataId = a.ClassificazioneId;

GO

