
CREATE   VIEW Standard.vw_ControlloCoerenzaDocumentale
AS
WITH RelazioniTerminali AS
(
    SELECT
        r.RiferimentoDocumentaleRelazioneId,
        r.RiferimentoOrigineId,
        r.RiferimentoDestinazioneId,
        r.TipoRelazione
    FROM Standard.RiferimentoDocumentaleRelazione r
    WHERE r.DataCancellazione IS NULL
      AND r.Attivo = 1
      AND r.TipoRelazione IN
          (N'Sostituisce', N'Rinomina', N'Consolida', N'Separa', N'Archivia')
),
RelazioniIncompatibili AS
(
    SELECT
        r.RiferimentoDestinazioneId,
        MIN(r.RiferimentoDocumentaleRelazioneId) AS RelazioneId,
        COUNT_BIG(*) AS NumeroRelazioni
    FROM RelazioniTerminali r
    GROUP BY r.RiferimentoDestinazioneId
    HAVING COUNT_BIG(*) > 1
       AND MAX(CASE WHEN r.TipoRelazione <> N'Separa' THEN 1 ELSE 0 END) = 1
)
SELECT
    N'Relazione terminale con stato destinazione incoerente' AS Anomalia,
    r.RiferimentoDocumentaleRelazioneId AS Id,
    CONVERT
    (
        nvarchar(400),
        CONCAT
        (
            r.TipoRelazione, N': ',
            o.CodiceDocumento, N' -> ', d.CodiceDocumento,
            N' (stato ', d.Stato, N')'
        )
    ) AS Riferimento
FROM RelazioniTerminali r
JOIN Standard.RiferimentoDocumentale o
  ON o.RiferimentoDocumentaleId = r.RiferimentoOrigineId
JOIN Standard.RiferimentoDocumentale d
  ON d.RiferimentoDocumentaleId = r.RiferimentoDestinazioneId
WHERE d.DataCancellazione IS NULL
  AND
  (
      (r.TipoRelazione = N'Archivia' AND d.Stato <> N'Archiviato')
   OR (r.TipoRelazione <> N'Archivia' AND d.Stato <> N'Sostituito')
  )

UNION ALL

SELECT
    N'Documento Sostituito senza relazione terminale entrante',
    d.RiferimentoDocumentaleId,
    CONVERT(nvarchar(400), d.CodiceDocumento)
FROM Standard.RiferimentoDocumentale d
WHERE d.DataCancellazione IS NULL
  AND d.Stato = N'Sostituito'
  AND NOT EXISTS
  (
      SELECT 1
      FROM RelazioniTerminali r
      WHERE r.RiferimentoDestinazioneId = d.RiferimentoDocumentaleId
        AND r.TipoRelazione IN
            (N'Sostituisce', N'Rinomina', N'Consolida', N'Separa')
  )

UNION ALL

SELECT
    N'Documento Archiviato senza relazione Archivia entrante',
    d.RiferimentoDocumentaleId,
    CONVERT(nvarchar(400), d.CodiceDocumento)
FROM Standard.RiferimentoDocumentale d
WHERE d.DataCancellazione IS NULL
  AND d.Stato = N'Archiviato'
  AND NOT EXISTS
  (
      SELECT 1
      FROM RelazioniTerminali r
      WHERE r.RiferimentoDestinazioneId = d.RiferimentoDocumentaleId
        AND r.TipoRelazione = N'Archivia'
  )

UNION ALL

SELECT
    N'Documento Corrente con relazione terminale entrante',
    d.RiferimentoDocumentaleId,
    CONVERT(nvarchar(400), d.CodiceDocumento)
FROM Standard.RiferimentoDocumentale d
WHERE d.DataCancellazione IS NULL
  AND d.Stato = N'Corrente'
  AND EXISTS
  (
      SELECT 1
      FROM RelazioniTerminali r
      WHERE r.RiferimentoDestinazioneId = d.RiferimentoDocumentaleId
  )

UNION ALL

SELECT
    N'Relazione attiva verso documento cancellato logicamente',
    r.RiferimentoDocumentaleRelazioneId,
    CONVERT
    (
        nvarchar(400),
        CONCAT(N'Origine=', r.RiferimentoOrigineId, N'; Destinazione=', r.RiferimentoDestinazioneId)
    )
FROM Standard.RiferimentoDocumentaleRelazione r
JOIN Standard.RiferimentoDocumentale o
  ON o.RiferimentoDocumentaleId = r.RiferimentoOrigineId
JOIN Standard.RiferimentoDocumentale d
  ON d.RiferimentoDocumentaleId = r.RiferimentoDestinazioneId
WHERE r.DataCancellazione IS NULL
  AND r.Attivo = 1
  AND (o.DataCancellazione IS NOT NULL OR d.DataCancellazione IS NOT NULL)

UNION ALL

SELECT
    N'Relazioni terminali incompatibili sulla stessa destinazione',
    x.RelazioneId,
    CONVERT
    (
        nvarchar(400),
        CONCAT(N'Destinazione=', x.RiferimentoDestinazioneId, N'; Relazioni=', x.NumeroRelazioni)
    )
FROM RelazioniIncompatibili x;

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Gate documentale: la vista deve restituire zero righe al termine di ogni migrazione o workflow.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'VIEW', @level1name = N'vw_ControlloCoerenzaDocumentale';


GO

