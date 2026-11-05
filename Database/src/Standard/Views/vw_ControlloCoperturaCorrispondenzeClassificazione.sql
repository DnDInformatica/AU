
CREATE   VIEW
    Standard.vw_ControlloCoperturaCorrispondenzeClassificazione
AS
    SELECT
        CONVERT(nvarchar(100), N'ECCEZIONE_COPERTURA_LATO_NON_COHERENTE')
            AS Anomalia,
        e.ClassificazioneVersioneCorrispondenzaEccezioneCoperturaId AS Id,
        CONCAT
        (
            N'Eccezione ', e.Lato, N' sulla voce ',
            e.VoceClassificazioneId,
            N' non coerente con il lato della corrispondenza ', h.Codice,
            N'.'
        ) AS Dettaglio
    FROM Standard.ClassificazioneVersioneCorrispondenzaEccezioneCopertura e
    JOIN Standard.ClassificazioneVersioneCorrispondenzaCopertura p
      ON p.ClassificazioneVersioneCorrispondenzaId =
         e.ClassificazioneVersioneCorrispondenzaId
     AND p.Attivo = 1
     AND p.DataCancellazione IS NULL
    JOIN Standard.ClassificazioneVersioneCorrispondenza h
      ON h.ClassificazioneVersioneCorrispondenzaId =
         e.ClassificazioneVersioneCorrispondenzaId
     AND h.Attivo = 1
     AND h.DataCancellazione IS NULL
    LEFT JOIN Standard.VoceClassificazione v
      ON v.VoceClassificazioneId = e.VoceClassificazioneId
     AND v.ClassificazioneVersioneId = e.ClassificazioneVersioneId
     AND v.ClassificazioneId = e.ClassificazioneId
     AND v.Attivo = 1
     AND v.DataCancellazione IS NULL
    WHERE e.Attivo = 1
      AND e.DataCancellazione IS NULL
      AND
      (
          v.VoceClassificazioneId IS NULL
          OR
          (
              e.Lato = N'ORIGINE'
              AND
              (
                  e.ClassificazioneVersioneId <>
                      h.ClassificazioneVersioneOrigineId
                  OR e.ClassificazioneId <> h.ClassificazioneOrigineId
              )
          )
          OR
          (
              e.Lato = N'DESTINAZIONE'
              AND
              (
                  e.ClassificazioneVersioneId <>
                      h.ClassificazioneVersioneDestinazioneId
                  OR e.ClassificazioneId <> h.ClassificazioneDestinazioneId
              )
          )
      )

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'CORRISPONDENZA_ORIGINE_NON_COPERTA'),
        v.VoceClassificazioneId,
        CONCAT
        (
            N'Voce origine ', v.Codice,
            N' non coperta dalla corrispondenza ', h.Codice, N'.'
        )
    FROM Standard.ClassificazioneVersioneCorrispondenza h
    JOIN Standard.ClassificazioneVersioneCorrispondenzaCopertura p
      ON p.ClassificazioneVersioneCorrispondenzaId =
         h.ClassificazioneVersioneCorrispondenzaId
     AND p.Attivo = 1
     AND p.DataCancellazione IS NULL
    JOIN Standard.VoceClassificazione v
      ON v.ClassificazioneVersioneId =
         h.ClassificazioneVersioneOrigineId
     AND v.ClassificazioneId = h.ClassificazioneOrigineId
     AND v.Attivo = 1
     AND v.DataCancellazione IS NULL
    WHERE h.Attivo = 1
      AND h.DataCancellazione IS NULL
      AND p.RichiedeCoperturaOrigine = 1
      AND NOT EXISTS
      (
          SELECT 1
          FROM Standard.VoceClassificazioneCorrispondenza r
          WHERE r.ClassificazioneVersioneCorrispondenzaId =
                h.ClassificazioneVersioneCorrispondenzaId
            AND r.VoceOrigineId = v.VoceClassificazioneId
            AND r.Attivo = 1
            AND r.DataCancellazione IS NULL
      )
      AND NOT EXISTS
      (
          SELECT 1
          FROM Standard.ClassificazioneVersioneCorrispondenzaEccezioneCopertura e
          WHERE e.ClassificazioneVersioneCorrispondenzaId =
                h.ClassificazioneVersioneCorrispondenzaId
            AND e.Lato = N'ORIGINE'
            AND e.VoceClassificazioneId = v.VoceClassificazioneId
            AND e.Attivo = 1
            AND e.DataCancellazione IS NULL
      )

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'CORRISPONDENZA_DESTINAZIONE_NON_COPERTA'),
        v.VoceClassificazioneId,
        CONCAT
        (
            N'Voce destinazione ', v.Codice,
            N' non coperta dalla corrispondenza ', h.Codice, N'.'
        )
    FROM Standard.ClassificazioneVersioneCorrispondenza h
    JOIN Standard.ClassificazioneVersioneCorrispondenzaCopertura p
      ON p.ClassificazioneVersioneCorrispondenzaId =
         h.ClassificazioneVersioneCorrispondenzaId
     AND p.Attivo = 1
     AND p.DataCancellazione IS NULL
    JOIN Standard.VoceClassificazione v
      ON v.ClassificazioneVersioneId =
         h.ClassificazioneVersioneDestinazioneId
     AND v.ClassificazioneId = h.ClassificazioneDestinazioneId
     AND v.Attivo = 1
     AND v.DataCancellazione IS NULL
    WHERE h.Attivo = 1
      AND h.DataCancellazione IS NULL
      AND p.RichiedeCoperturaDestinazione = 1
      AND NOT EXISTS
      (
          SELECT 1
          FROM Standard.vw_VoceClassificazioneCorrispondenzaEspansa x
          WHERE x.ClassificazioneVersioneCorrispondenzaId =
                h.ClassificazioneVersioneCorrispondenzaId
            AND x.VoceDestinazioneId = v.VoceClassificazioneId
      )
      AND NOT EXISTS
      (
          SELECT 1
          FROM Standard.ClassificazioneVersioneCorrispondenzaEccezioneCopertura e
          WHERE e.ClassificazioneVersioneCorrispondenzaId =
                h.ClassificazioneVersioneCorrispondenzaId
            AND e.Lato = N'DESTINAZIONE'
            AND e.VoceClassificazioneId = v.VoceClassificazioneId
            AND e.Attivo = 1
            AND e.DataCancellazione IS NULL
      )

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'ECCEZIONE_COPERTURA_SOVRAPPOSTA'),
        e.ClassificazioneVersioneCorrispondenzaEccezioneCoperturaId,
        CONCAT
        (
            N'Eccezione ', e.Lato, N' sulla voce ',
            e.VoceClassificazioneId,
            N' sovrapposta a una corrispondenza effettiva.'
        )
    FROM Standard.ClassificazioneVersioneCorrispondenzaEccezioneCopertura e
    JOIN Standard.ClassificazioneVersioneCorrispondenzaCopertura p
      ON p.ClassificazioneVersioneCorrispondenzaId =
         e.ClassificazioneVersioneCorrispondenzaId
     AND p.Attivo = 1
     AND p.DataCancellazione IS NULL
    JOIN Standard.ClassificazioneVersioneCorrispondenza h
      ON h.ClassificazioneVersioneCorrispondenzaId =
         e.ClassificazioneVersioneCorrispondenzaId
     AND h.Attivo = 1
     AND h.DataCancellazione IS NULL
    WHERE e.Attivo = 1
      AND e.DataCancellazione IS NULL
      AND
      (
          (
              e.Lato = N'ORIGINE'
              AND EXISTS
              (
                  SELECT 1
                  FROM Standard.VoceClassificazioneCorrispondenza r
                  WHERE r.ClassificazioneVersioneCorrispondenzaId =
                        e.ClassificazioneVersioneCorrispondenzaId
                    AND r.VoceOrigineId = e.VoceClassificazioneId
                    AND r.Attivo = 1
                    AND r.DataCancellazione IS NULL
              )
          )
          OR
          (
              e.Lato = N'DESTINAZIONE'
              AND EXISTS
              (
                  SELECT 1
                  FROM Standard.vw_VoceClassificazioneCorrispondenzaEspansa x
                  WHERE x.ClassificazioneVersioneCorrispondenzaId =
                        e.ClassificazioneVersioneCorrispondenzaId
                    AND x.VoceDestinazioneId = e.VoceClassificazioneId
              )
          )
      )

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'ECCEZIONE_COPERTURA_FONTE_NON_ATTIVA'),
        e.ClassificazioneVersioneCorrispondenzaEccezioneCoperturaId,
        CONCAT
        (
            N'Eccezione di copertura ', e.UniqueRowId,
            N' con riferimento documentale non attivo.'
        )
    FROM Standard.ClassificazioneVersioneCorrispondenzaEccezioneCopertura e
    JOIN Standard.ClassificazioneVersioneCorrispondenzaCopertura p
      ON p.ClassificazioneVersioneCorrispondenzaId =
         e.ClassificazioneVersioneCorrispondenzaId
     AND p.Attivo = 1
     AND p.DataCancellazione IS NULL
    JOIN Standard.ClassificazioneVersioneCorrispondenza h
      ON h.ClassificazioneVersioneCorrispondenzaId =
         e.ClassificazioneVersioneCorrispondenzaId
     AND h.Attivo = 1
     AND h.DataCancellazione IS NULL
    LEFT JOIN Standard.RiferimentoDocumentale d
      ON d.RiferimentoDocumentaleId = e.RiferimentoDocumentaleId
     AND d.Attivo = 1
     AND d.DataCancellazione IS NULL
    WHERE e.Attivo = 1
      AND e.DataCancellazione IS NULL
      AND d.RiferimentoDocumentaleId IS NULL;

GO

