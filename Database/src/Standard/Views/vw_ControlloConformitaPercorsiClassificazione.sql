
CREATE   VIEW Standard.vw_ControlloConformitaPercorsiClassificazione
AS
    WITH Passi AS
    (
        SELECT
            p.ClassificazionePercorsoCorrispondenzaId,
            p.Codice AS PercorsoCodice,
            p.ClassificazioneVersioneOrigineId AS PercorsoVersioneOrigineId,
            p.ClassificazioneVersioneDestinazioneId
                AS PercorsoVersioneDestinazioneId,
            s.ClassificazionePercorsoCorrispondenzaPassoId,
            s.OrdinePasso,
            s.Direzione,
            c.ClassificazioneVersioneCorrispondenzaId,
            c.Attivo AS CorrispondenzaAttiva,
            c.DataCancellazione AS CorrispondenzaCancellata,
            CASE
                WHEN s.Direzione = N'DIRETTA'
                    THEN c.ClassificazioneVersioneOrigineId
                ELSE c.ClassificazioneVersioneDestinazioneId
            END AS VersioneIngressoId,
            CASE
                WHEN s.Direzione = N'DIRETTA'
                    THEN c.ClassificazioneVersioneDestinazioneId
                ELSE c.ClassificazioneVersioneOrigineId
            END AS VersioneUscitaId,
            ROW_NUMBER() OVER
            (
                PARTITION BY p.ClassificazionePercorsoCorrispondenzaId
                ORDER BY s.OrdinePasso
            ) AS NumeroRiga,
            COUNT(*) OVER
            (
                PARTITION BY p.ClassificazionePercorsoCorrispondenzaId
            ) AS NumeroPassi
        FROM Standard.ClassificazionePercorsoCorrispondenza p
        JOIN Standard.ClassificazionePercorsoCorrispondenzaPasso s
          ON s.ClassificazionePercorsoCorrispondenzaId =
             p.ClassificazionePercorsoCorrispondenzaId
         AND s.Attivo = 1
         AND s.DataCancellazione IS NULL
        JOIN Standard.ClassificazioneVersioneCorrispondenza c
          ON c.ClassificazioneVersioneCorrispondenzaId =
             s.ClassificazioneVersioneCorrispondenzaId
        WHERE p.Attivo = 1
          AND p.DataCancellazione IS NULL
    ),
    Sequenza AS
    (
        SELECT
            x.*,
            LAG(x.VersioneUscitaId) OVER
            (
                PARTITION BY x.ClassificazionePercorsoCorrispondenzaId
                ORDER BY x.OrdinePasso
            ) AS VersioneUscitaPrecedenteId
        FROM Passi x
    )
    SELECT
        CONVERT(nvarchar(100), N'PERCORSO_SENZA_PASSI') AS Anomalia,
        p.ClassificazionePercorsoCorrispondenzaId AS Id,
        p.ClassificazionePercorsoCorrispondenzaId AS PercorsoId,
        CONCAT(N'Percorso ', p.Codice, N' privo di passi attivi.')
            AS Dettaglio
    FROM Standard.ClassificazionePercorsoCorrispondenza p
    WHERE p.Attivo = 1
      AND p.DataCancellazione IS NULL
      AND NOT EXISTS
      (
          SELECT 1
          FROM Standard.ClassificazionePercorsoCorrispondenzaPasso s
          WHERE s.ClassificazionePercorsoCorrispondenzaId =
                p.ClassificazionePercorsoCorrispondenzaId
            AND s.Attivo = 1
            AND s.DataCancellazione IS NULL
      )

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'PERCORSO_PASSO_NON_CONTIGUO'),
        s.ClassificazionePercorsoCorrispondenzaPassoId,
        s.ClassificazionePercorsoCorrispondenzaId,
        CONCAT
        (
            N'Percorso ',
            s.PercorsoCodice,
            N': ordine ',
            s.OrdinePasso,
            N' diverso dalla posizione ',
            s.NumeroRiga,
            N'.'
        )
    FROM Sequenza s
    WHERE s.OrdinePasso <> s.NumeroRiga

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'PERCORSO_CORRISPONDENZA_NON_ATTIVA'),
        s.ClassificazionePercorsoCorrispondenzaPassoId,
        s.ClassificazionePercorsoCorrispondenzaId,
        CONCAT
        (
            N'Percorso ',
            s.PercorsoCodice,
            N' usa una corrispondenza inattiva o cancellata al passo ',
            s.OrdinePasso,
            N'.'
        )
    FROM Sequenza s
    WHERE s.CorrispondenzaAttiva <> 1
       OR s.CorrispondenzaCancellata IS NOT NULL

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'PERCORSO_ORIGINE_NON_COINCIDENTE'),
        s.ClassificazionePercorsoCorrispondenzaPassoId,
        s.ClassificazionePercorsoCorrispondenzaId,
        CONCAT
        (
            N'Il primo passo del percorso ',
            s.PercorsoCodice,
            N' non parte dalla versione dichiarata.'
        )
    FROM Sequenza s
    WHERE s.NumeroRiga = 1
      AND s.VersioneIngressoId <> s.PercorsoVersioneOrigineId

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'PERCORSO_DESTINAZIONE_NON_COINCIDENTE'),
        s.ClassificazionePercorsoCorrispondenzaPassoId,
        s.ClassificazionePercorsoCorrispondenzaId,
        CONCAT
        (
            N'L ultimo passo del percorso ',
            s.PercorsoCodice,
            N' non termina sulla versione dichiarata.'
        )
    FROM Sequenza s
    WHERE s.NumeroRiga = s.NumeroPassi
      AND s.VersioneUscitaId <> s.PercorsoVersioneDestinazioneId

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'PERCORSO_DISCONTINUO'),
        s.ClassificazionePercorsoCorrispondenzaPassoId,
        s.ClassificazionePercorsoCorrispondenzaId,
        CONCAT
        (
            N'Percorso ',
            s.PercorsoCodice,
            N' discontinuo prima del passo ',
            s.OrdinePasso,
            N'.'
        )
    FROM Sequenza s
    WHERE s.NumeroRiga > 1
      AND s.VersioneIngressoId <> s.VersioneUscitaPrecedenteId;

GO

