
CREATE   VIEW Standard.vw_ControlloConformitaCorrispondenzeClassificazione
AS
    SELECT
        CONVERT(nvarchar(100), N'CORRISPONDENZA_GOVERNANCE_NON_ATTIVA')
            AS Anomalia,
        h.ClassificazioneVersioneCorrispondenzaId AS Id,
        CONCAT
        (
            N'Corrispondenza ', h.Codice,
            N' con governance origine o destinazione non attiva.'
        ) AS Dettaglio
    FROM Standard.ClassificazioneVersioneCorrispondenza h
    LEFT JOIN Standard.ClassificazioneGovernance go
      ON go.ClassificazioneId = h.ClassificazioneOrigineId
     AND go.ConsenteCorrispondenze = 1
     AND go.Attivo = 1
     AND go.DataCancellazione IS NULL
    LEFT JOIN Standard.ClassificazioneGovernance gd
      ON gd.ClassificazioneId = h.ClassificazioneDestinazioneId
     AND gd.ConsenteCorrispondenze = 1
     AND gd.Attivo = 1
     AND gd.DataCancellazione IS NULL
    WHERE h.Attivo = 1
      AND h.DataCancellazione IS NULL
      AND (go.ClassificazioneId IS NULL OR gd.ClassificazioneId IS NULL)

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'CORRISPONDENZA_ORIGINE_NON_ATTIVA'),
        r.VoceClassificazioneCorrispondenzaId,
        CONCAT
        (
            N'La regola usa la voce origine ', r.VoceOrigineId,
            N' non attiva.'
        )
    FROM Standard.VoceClassificazioneCorrispondenza r
    JOIN Standard.ClassificazioneVersioneCorrispondenza h
      ON h.ClassificazioneVersioneCorrispondenzaId =
         r.ClassificazioneVersioneCorrispondenzaId
     AND h.Attivo = 1
     AND h.DataCancellazione IS NULL
    LEFT JOIN Standard.VoceClassificazione v
      ON v.VoceClassificazioneId = r.VoceOrigineId
     AND v.ClassificazioneVersioneId =
         r.ClassificazioneVersioneOrigineId
     AND v.ClassificazioneId = r.ClassificazioneOrigineId
     AND v.Attivo = 1
     AND v.DataCancellazione IS NULL
    WHERE r.Attivo = 1
      AND r.DataCancellazione IS NULL
      AND v.VoceClassificazioneId IS NULL

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'CORRISPONDENZA_DESTINAZIONE_NON_ATTIVA'),
        t.VoceClassificazioneCorrispondenzaTermineId,
        CONCAT
        (
            N'Il termine usa la voce destinazione ', t.VoceDestinazioneId,
            N' non attiva.'
        )
    FROM Standard.VoceClassificazioneCorrispondenzaTermine t
    JOIN Standard.VoceClassificazioneCorrispondenza r
      ON r.VoceClassificazioneCorrispondenzaId =
         t.VoceClassificazioneCorrispondenzaId
     AND r.Attivo = 1
     AND r.DataCancellazione IS NULL
    JOIN Standard.ClassificazioneVersioneCorrispondenza h
      ON h.ClassificazioneVersioneCorrispondenzaId =
         r.ClassificazioneVersioneCorrispondenzaId
     AND h.Attivo = 1
     AND h.DataCancellazione IS NULL
    LEFT JOIN Standard.VoceClassificazione v
      ON v.VoceClassificazioneId = t.VoceDestinazioneId
     AND v.ClassificazioneVersioneId =
         t.ClassificazioneVersioneDestinazioneId
     AND v.ClassificazioneId = t.ClassificazioneDestinazioneId
     AND v.Attivo = 1
     AND v.DataCancellazione IS NULL
    WHERE t.Attivo = 1
      AND t.DataCancellazione IS NULL
      AND v.VoceClassificazioneId IS NULL

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'CORRISPONDENZA_REGOLA_SENZA_INCLUDE'),
        r.VoceClassificazioneCorrispondenzaId,
        CONCAT
        (
            N'Regola per voce ', r.VoceOrigineId,
            N' priva di un termine INCLUDE.'
        )
    FROM Standard.VoceClassificazioneCorrispondenza r
    JOIN Standard.ClassificazioneVersioneCorrispondenza h
      ON h.ClassificazioneVersioneCorrispondenzaId =
         r.ClassificazioneVersioneCorrispondenzaId
     AND h.Attivo = 1
     AND h.DataCancellazione IS NULL
    WHERE r.Attivo = 1
      AND r.DataCancellazione IS NULL
      AND NOT EXISTS
      (
          SELECT 1
          FROM Standard.VoceClassificazioneCorrispondenzaTermine t
          WHERE t.VoceClassificazioneCorrispondenzaId =
                r.VoceClassificazioneCorrispondenzaId
            AND t.Operatore = N'INCLUDE'
            AND t.Attivo = 1
            AND t.DataCancellazione IS NULL
      )

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'CORRISPONDENZA_ESCLUSIONE_NON_ANNIDATA'),
        te.VoceClassificazioneCorrispondenzaTermineId,
        CONCAT
        (
            N'Esclusione ', te.VoceDestinazioneId,
            N' non contenuta in alcuna inclusione della stessa regola.'
        )
    FROM Standard.VoceClassificazioneCorrispondenzaTermine te
    JOIN Standard.VoceClassificazioneCorrispondenza r
      ON r.VoceClassificazioneCorrispondenzaId =
         te.VoceClassificazioneCorrispondenzaId
     AND r.Attivo = 1
     AND r.DataCancellazione IS NULL
    JOIN Standard.ClassificazioneVersioneCorrispondenza h
      ON h.ClassificazioneVersioneCorrispondenzaId =
         r.ClassificazioneVersioneCorrispondenzaId
     AND h.Attivo = 1
     AND h.DataCancellazione IS NULL
    WHERE te.Operatore = N'EXCLUDE'
      AND te.Attivo = 1
      AND te.DataCancellazione IS NULL
      AND NOT EXISTS
      (
          SELECT 1
          FROM Standard.VoceClassificazioneCorrispondenzaTermine ti
          JOIN Standard.VoceClassificazioneClosure c
            ON c.ClassificazioneVersioneId =
               ti.ClassificazioneVersioneDestinazioneId
           AND c.ClassificazioneId = ti.ClassificazioneDestinazioneId
           AND c.VoceAntenatoId = ti.VoceDestinazioneId
           AND c.VoceDiscendenteId = te.VoceDestinazioneId
          WHERE ti.VoceClassificazioneCorrispondenzaId =
                te.VoceClassificazioneCorrispondenzaId
            AND ti.Operatore = N'INCLUDE'
            AND ti.EstensioneDestinazione = N'VOCE_E_DISCENDENTI'
            AND ti.Attivo = 1
            AND ti.DataCancellazione IS NULL
      )

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'CORRISPONDENZA_CONTEGGIO_REGOLE'),
        h.ClassificazioneVersioneCorrispondenzaId,
        CONCAT
        (
            N'Corrispondenza ', h.Codice, N': regole attese ',
            h.NumeroRegoleAtteso, N', trovate ',
            COUNT(r.VoceClassificazioneCorrispondenzaId), N'.'
        )
    FROM Standard.ClassificazioneVersioneCorrispondenza h
    LEFT JOIN Standard.VoceClassificazioneCorrispondenza r
      ON r.ClassificazioneVersioneCorrispondenzaId =
         h.ClassificazioneVersioneCorrispondenzaId
     AND r.Attivo = 1
     AND r.DataCancellazione IS NULL
    WHERE h.Attivo = 1
      AND h.DataCancellazione IS NULL
      AND h.NumeroRegoleAtteso IS NOT NULL
    GROUP BY
        h.ClassificazioneVersioneCorrispondenzaId,
        h.Codice,
        h.NumeroRegoleAtteso
    HAVING COUNT(r.VoceClassificazioneCorrispondenzaId) <>
           h.NumeroRegoleAtteso

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'CORRISPONDENZA_CONTEGGIO_TERMINI'),
        h.ClassificazioneVersioneCorrispondenzaId,
        CONCAT
        (
            N'Corrispondenza ', h.Codice, N': termini attesi ',
            h.NumeroTerminiAtteso, N', trovati ',
            COUNT(t.VoceClassificazioneCorrispondenzaTermineId), N'.'
        )
    FROM Standard.ClassificazioneVersioneCorrispondenza h
    LEFT JOIN Standard.VoceClassificazioneCorrispondenza r
      ON r.ClassificazioneVersioneCorrispondenzaId =
         h.ClassificazioneVersioneCorrispondenzaId
     AND r.Attivo = 1
     AND r.DataCancellazione IS NULL
    LEFT JOIN Standard.VoceClassificazioneCorrispondenzaTermine t
      ON t.VoceClassificazioneCorrispondenzaId =
         r.VoceClassificazioneCorrispondenzaId
     AND t.Attivo = 1
     AND t.DataCancellazione IS NULL
    WHERE h.Attivo = 1
      AND h.DataCancellazione IS NULL
      AND h.NumeroTerminiAtteso IS NOT NULL
    GROUP BY
        h.ClassificazioneVersioneCorrispondenzaId,
        h.Codice,
        h.NumeroTerminiAtteso
    HAVING COUNT(t.VoceClassificazioneCorrispondenzaTermineId) <>
           h.NumeroTerminiAtteso

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'CORRISPONDENZA_CONTEGGIO_EFFETTIVO'),
        h.ClassificazioneVersioneCorrispondenzaId,
        CONCAT
        (
            N'Corrispondenza ', h.Codice,
            N': associazioni effettive attese ',
            h.NumeroAssociazioniEffettiveAtteso, N', trovate ',
            COUNT(e.VoceDestinazioneId), N'.'
        )
    FROM Standard.ClassificazioneVersioneCorrispondenza h
    LEFT JOIN Standard.vw_VoceClassificazioneCorrispondenzaEspansa e
      ON e.ClassificazioneVersioneCorrispondenzaId =
         h.ClassificazioneVersioneCorrispondenzaId
    WHERE h.Attivo = 1
      AND h.DataCancellazione IS NULL
      AND h.NumeroAssociazioniEffettiveAtteso IS NOT NULL
    GROUP BY
        h.ClassificazioneVersioneCorrispondenzaId,
        h.Codice,
        h.NumeroAssociazioniEffettiveAtteso
    HAVING COUNT(e.VoceDestinazioneId) <>
           h.NumeroAssociazioniEffettiveAtteso

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'CORRISPONDENZA_SOVRAPPOSIZIONE'),
        x.ClassificazioneVersioneCorrispondenzaId,
        CONCAT
        (
            N'Voce destinazione ', x.VoceDestinazioneId,
            N' associata a ', x.NumeroOrigini,
            N' voci origine in una corrispondenza senza sovrapposizioni.'
        )
    FROM
    (
        SELECT
            e.ClassificazioneVersioneCorrispondenzaId,
            e.VoceDestinazioneId,
            COUNT(DISTINCT e.VoceOrigineId) AS NumeroOrigini
        FROM Standard.vw_VoceClassificazioneCorrispondenzaEspansa e
        JOIN Standard.ClassificazioneVersioneCorrispondenza h
          ON h.ClassificazioneVersioneCorrispondenzaId =
             e.ClassificazioneVersioneCorrispondenzaId
         AND h.ConsenteSovrapposizioni = 0
         AND h.Attivo = 1
         AND h.DataCancellazione IS NULL
        GROUP BY
            e.ClassificazioneVersioneCorrispondenzaId,
            e.VoceDestinazioneId
        HAVING COUNT(DISTINCT e.VoceOrigineId) > 1
    ) x;

GO

