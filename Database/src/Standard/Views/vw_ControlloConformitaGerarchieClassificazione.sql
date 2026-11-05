
CREATE   VIEW Standard.vw_ControlloConformitaGerarchieClassificazione
AS
    SELECT
        CONVERT(nvarchar(100), N'GERARCHIA_ESTREMO_NON_ATTIVO') AS Anomalia,
        e.VoceClassificazioneGerarchiaId AS Id,
        CONCAT
        (
            N'Arco ', e.VocePadreId, N' -> ', e.VoceFiglioId,
            N' con padre o figlio non attivo.'
        ) AS Dettaglio
    FROM Standard.VoceClassificazioneGerarchia e
    LEFT JOIN Standard.VoceClassificazione p
      ON p.VoceClassificazioneId = e.VocePadreId
     AND p.ClassificazioneVersioneId = e.ClassificazioneVersioneId
     AND p.ClassificazioneId = e.ClassificazioneId
     AND p.Attivo = 1
     AND p.DataCancellazione IS NULL
    LEFT JOIN Standard.VoceClassificazione f
      ON f.VoceClassificazioneId = e.VoceFiglioId
     AND f.ClassificazioneVersioneId = e.ClassificazioneVersioneId
     AND f.ClassificazioneId = e.ClassificazioneId
     AND f.Attivo = 1
     AND f.DataCancellazione IS NULL
    WHERE e.Attivo = 1
      AND e.DataCancellazione IS NULL
      AND (p.VoceClassificazioneId IS NULL OR f.VoceClassificazioneId IS NULL)

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'CLOSURE_SELF_MANCANTE'),
        v.VoceClassificazioneId,
        CONCAT(N'Self-pair mancante per la voce ', v.Codice, N'.')
    FROM Standard.VoceClassificazione v
    JOIN Standard.ClassificazioneGovernance g
      ON g.ClassificazioneId = v.ClassificazioneId
     AND g.ConsenteGerarchia = 1
     AND g.Attivo = 1
     AND g.DataCancellazione IS NULL
    LEFT JOIN Standard.VoceClassificazioneClosure c
      ON c.ClassificazioneVersioneId = v.ClassificazioneVersioneId
     AND c.ClassificazioneId = v.ClassificazioneId
     AND c.VoceAntenatoId = v.VoceClassificazioneId
     AND c.VoceDiscendenteId = v.VoceClassificazioneId
     AND c.Profondita = 0
    WHERE v.Attivo = 1
      AND v.DataCancellazione IS NULL
      AND c.VoceAntenatoId IS NULL

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'CLOSURE_ARCO_DIRETTO_MANCANTE'),
        e.VoceClassificazioneGerarchiaId,
        CONCAT
        (
            N'Closure a profondita 1 mancante per ',
            e.VocePadreId, N' -> ', e.VoceFiglioId, N'.'
        )
    FROM Standard.VoceClassificazioneGerarchia e
    LEFT JOIN Standard.VoceClassificazioneClosure c
      ON c.ClassificazioneVersioneId = e.ClassificazioneVersioneId
     AND c.ClassificazioneId = e.ClassificazioneId
     AND c.VoceAntenatoId = e.VocePadreId
     AND c.VoceDiscendenteId = e.VoceFiglioId
     AND c.Profondita = 1
    WHERE e.Attivo = 1
      AND e.DataCancellazione IS NULL
      AND c.VoceAntenatoId IS NULL

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'CLOSURE_ESTREMO_NON_ATTIVO'),
        c.VoceDiscendenteId,
        CONCAT
        (
            N'Closure ', c.VoceAntenatoId, N' -> ',
            c.VoceDiscendenteId, N' riferita a una voce non attiva.'
        )
    FROM Standard.VoceClassificazioneClosure c
    LEFT JOIN Standard.VoceClassificazione a
      ON a.VoceClassificazioneId = c.VoceAntenatoId
     AND a.ClassificazioneVersioneId = c.ClassificazioneVersioneId
     AND a.ClassificazioneId = c.ClassificazioneId
     AND a.Attivo = 1
     AND a.DataCancellazione IS NULL
    LEFT JOIN Standard.VoceClassificazione d
      ON d.VoceClassificazioneId = c.VoceDiscendenteId
     AND d.ClassificazioneVersioneId = c.ClassificazioneVersioneId
     AND d.ClassificazioneId = c.ClassificazioneId
     AND d.Attivo = 1
     AND d.DataCancellazione IS NULL
    WHERE a.VoceClassificazioneId IS NULL
       OR d.VoceClassificazioneId IS NULL;

GO

