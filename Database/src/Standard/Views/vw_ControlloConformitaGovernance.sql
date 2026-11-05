
CREATE   VIEW Standard.vw_ControlloConformitaGovernance
AS
SELECT
    N'Classificazione attiva senza governance' AS Anomalia,
    c.ClassificazioneId AS Id,
    CONVERT(nvarchar(400), c.Codice) AS Riferimento
FROM Standard.Classificazione c
WHERE c.DataCancellazione IS NULL
  AND c.Attivo = 1
  AND NOT EXISTS
  (
      SELECT 1
      FROM Standard.ClassificazioneGovernance g
      WHERE g.ClassificazioneId = c.ClassificazioneId
        AND g.DataCancellazione IS NULL
  )

UNION ALL

SELECT
    N'Governance senza fonte canonica',
    g.ClassificazioneId,
    CONVERT(nvarchar(400), c.Codice)
FROM Standard.ClassificazioneGovernance g
JOIN Standard.Classificazione c
  ON c.ClassificazioneId = g.ClassificazioneId
WHERE g.DataCancellazione IS NULL
  AND g.FonteCanonicaSoggettoFonteId IS NULL

UNION ALL

SELECT
    N'Governance con fonte canonica non attiva',
    g.ClassificazioneId,
    CONVERT(nvarchar(400), c.Codice)
FROM Standard.ClassificazioneGovernance g
JOIN Standard.Classificazione c
  ON c.ClassificazioneId = g.ClassificazioneId
JOIN Standard.SoggettoFonte sf
  ON sf.SoggettoFonteId = g.FonteCanonicaSoggettoFonteId
WHERE g.DataCancellazione IS NULL
  AND (sf.DataCancellazione IS NOT NULL OR sf.Attivo = 0)

UNION ALL

SELECT
    N'Stato Classificazione/Governance disallineato',
    g.ClassificazioneId,
    CONVERT(nvarchar(400), c.Codice)
FROM Standard.ClassificazioneGovernance g
JOIN Standard.Classificazione c
  ON c.ClassificazioneId = g.ClassificazioneId
WHERE g.DataCancellazione IS NULL
  AND c.DataCancellazione IS NULL
  AND g.Attivo <> c.Attivo

UNION ALL

SELECT
    N'Documento Sostituito senza relazione entrante',
    r.RiferimentoDocumentaleId,
    CONVERT(nvarchar(400), r.CodiceDocumento)
FROM Standard.RiferimentoDocumentale r
WHERE r.Stato = N'Sostituito'
  AND r.DataCancellazione IS NULL
  AND NOT EXISTS
  (
      SELECT 1
      FROM Standard.RiferimentoDocumentaleRelazione x
      WHERE x.RiferimentoDestinazioneId = r.RiferimentoDocumentaleId
        AND x.TipoRelazione IN (N'Sostituisce', N'Rinomina', N'Consolida')
        AND x.DataCancellazione IS NULL
  )

UNION ALL

SELECT
    N'Documento Corrente con relazione sostitutiva entrante',
    r.RiferimentoDocumentaleId,
    CONVERT(nvarchar(400), r.CodiceDocumento)
FROM Standard.RiferimentoDocumentale r
WHERE r.Stato = N'Corrente'
  AND r.DataCancellazione IS NULL
  AND EXISTS
  (
      SELECT 1
      FROM Standard.RiferimentoDocumentaleRelazione x
      WHERE x.RiferimentoDestinazioneId = r.RiferimentoDocumentaleId
        AND x.TipoRelazione IN (N'Sostituisce', N'Rinomina', N'Consolida')
        AND x.DataCancellazione IS NULL
  )

UNION ALL

SELECT
    N'Relazione sostitutiva con destinazione non Sostituito',
    x.RiferimentoDocumentaleRelazioneId,
    CONVERT(nvarchar(400), r.CodiceDocumento)
FROM Standard.RiferimentoDocumentaleRelazione x
JOIN Standard.RiferimentoDocumentale r
  ON r.RiferimentoDocumentaleId = x.RiferimentoDestinazioneId
WHERE x.TipoRelazione IN (N'Sostituisce', N'Rinomina', N'Consolida')
  AND x.DataCancellazione IS NULL
  AND r.DataCancellazione IS NULL
  AND r.Stato <> N'Sostituito'

UNION ALL

SELECT
    N'Riferimento primario versione non sincronizzato',
    cv.ClassificazioneVersioneId,
    CONVERT(nvarchar(400), cv.Codice)
FROM Standard.ClassificazioneVersione cv
OUTER APPLY
(
    SELECT
        COUNT(*) AS NumeroPrimari,
        MIN(vr.RiferimentoDocumentaleId) AS RiferimentoPrimarioId
    FROM Standard.ClassificazioneVersioneRiferimento vr
    WHERE vr.ClassificazioneVersioneId = cv.ClassificazioneVersioneId
      AND vr.PrimarioFlag = 1
      AND vr.DataCancellazione IS NULL
) p
WHERE cv.DataCancellazione IS NULL
  AND
  (
       cv.RiferimentoDocumentaleId IS NOT NULL
    OR p.NumeroPrimari > 0
  )
  AND
  (
       p.NumeroPrimari <> 1
    OR ISNULL(p.RiferimentoPrimarioId, -1)
       <> ISNULL(cv.RiferimentoDocumentaleId, -1)
  )

UNION ALL

SELECT
    N'OrganizzazioneFonte collegata a organizzazione cancellata',
    sf.SoggettoFonteId,
    CONVERT(nvarchar(400), sf.Codice)
FROM Standard.SoggettoFonte sf
JOIN Organizzazioni.Organizzazione o
  ON o.OrganizzazioneId = sf.OrganizzazioneId
WHERE sf.TipoSoggetto = N'OrganizzazioneFonte'
  AND sf.DataCancellazione IS NULL
  AND o.DataCancellazione IS NOT NULL

UNION ALL

SELECT
    v.Ruolo + N': tipo organizzazione incoerente',
    v.RuoloId,
    CONVERT(nvarchar(400), v.OrganizzazioneId)
FROM Standard.vw_ControlloTipoOrganizzazioneFonte v;

GO

