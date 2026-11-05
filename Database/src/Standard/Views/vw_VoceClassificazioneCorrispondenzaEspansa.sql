
CREATE   VIEW Standard.vw_VoceClassificazioneCorrispondenzaEspansa
AS
    WITH TerminiEspansi AS
    (
        SELECT
            h.ClassificazioneVersioneCorrispondenzaId,
            h.Codice AS CorrispondenzaCodice,
            r.VoceClassificazioneCorrispondenzaId,
            r.VoceOrigineId,
            t.VoceClassificazioneCorrispondenzaTermineId,
            t.Operatore,
            t.VoceDestinazioneId AS VoceDestinazioneEsplicitaId,
            COALESCE
            (
                c.VoceDiscendenteId,
                t.VoceDestinazioneId
            ) AS VoceDestinazioneEffettivaId,
            CONVERT
            (
                bit,
                CASE
                    WHEN c.VoceDiscendenteId IS NOT NULL
                     AND c.VoceDiscendenteId <> t.VoceDestinazioneId
                    THEN 1
                    ELSE 0
                END
            ) AS DerivataDaGerarchiaFlag
        FROM Standard.ClassificazioneVersioneCorrispondenza h
        JOIN Standard.VoceClassificazioneCorrispondenza r
          ON r.ClassificazioneVersioneCorrispondenzaId =
             h.ClassificazioneVersioneCorrispondenzaId
         AND r.Attivo = 1
         AND r.DataCancellazione IS NULL
        JOIN Standard.VoceClassificazioneCorrispondenzaTermine t
          ON t.VoceClassificazioneCorrispondenzaId =
             r.VoceClassificazioneCorrispondenzaId
         AND t.Attivo = 1
         AND t.DataCancellazione IS NULL
        LEFT JOIN Standard.VoceClassificazioneClosure c
          ON t.EstensioneDestinazione = N'VOCE_E_DISCENDENTI'
         AND c.ClassificazioneVersioneId =
             t.ClassificazioneVersioneDestinazioneId
         AND c.ClassificazioneId = t.ClassificazioneDestinazioneId
         AND c.VoceAntenatoId = t.VoceDestinazioneId
        WHERE h.Attivo = 1
          AND h.DataCancellazione IS NULL
    ),
    Inclusioni AS
    (
        SELECT DISTINCT
            ClassificazioneVersioneCorrispondenzaId,
            CorrispondenzaCodice,
            VoceClassificazioneCorrispondenzaId,
            VoceOrigineId,
            VoceDestinazioneEffettivaId,
            DerivataDaGerarchiaFlag
        FROM TerminiEspansi
        WHERE Operatore = N'INCLUDE'
    ),
    Esclusioni AS
    (
        SELECT DISTINCT
            VoceClassificazioneCorrispondenzaId,
            VoceDestinazioneEffettivaId
        FROM TerminiEspansi
        WHERE Operatore = N'EXCLUDE'
    )
    SELECT
        i.ClassificazioneVersioneCorrispondenzaId,
        i.CorrispondenzaCodice,
        i.VoceClassificazioneCorrispondenzaId,
        i.VoceOrigineId,
        vo.Codice AS CodiceOrigine,
        i.VoceDestinazioneEffettivaId AS VoceDestinazioneId,
        vd.Codice AS CodiceDestinazione,
        i.DerivataDaGerarchiaFlag
    FROM Inclusioni i
    JOIN Standard.VoceClassificazione vo
      ON vo.VoceClassificazioneId = i.VoceOrigineId
    JOIN Standard.VoceClassificazione vd
      ON vd.VoceClassificazioneId = i.VoceDestinazioneEffettivaId
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM Esclusioni e
        WHERE e.VoceClassificazioneCorrispondenzaId =
              i.VoceClassificazioneCorrispondenzaId
          AND e.VoceDestinazioneEffettivaId =
              i.VoceDestinazioneEffettivaId
    );

GO

