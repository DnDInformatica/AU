CREATE   VIEW ImportSIAC.vw_OrganizzazioneBonificaCodaConclusiva
AS
SELECT
    a.OrganizzazioneBonificaAnomaliaId,
    a.Sistema,
    a.CodiceSorgente,
    a.DenominazioneSorgente,
    a.CodiceFiscale,
    a.PartitaIVA,
    a.TipoAnomalia,
    a.Dettaglio,
    CASE
      WHEN a.Sistema IN (N'SIA',N'SIAT') AND NULLIF(LTRIM(RTRIM(a.DenominazioneSorgente)),N'') IS NULL
        THEN N'VERIFICA_SORGENTE_LIVE_NECESSARIA'
      WHEN a.TipoAnomalia = N'SEDE_UO_NON_RICONCILIATA'
        THEN N'RICONCILIAZIONE_SEDE_UO'
      WHEN a.TipoAnomalia = N'FISCALITA_ASSENTE'
        THEN N'ARRICCHIMENTO_FISCALE_DOCUMENTALE'
      WHEN a.TipoAnomalia = N'ORGANIZZAZIONE_NON_TROVATA'
        THEN N'IDENTITA_O_STRUTTURA_DA_VERIFICARE'
      ELSE N'VERIFICA_MANUALE'
    END AS ClasseOperativa,
    CASE
      WHEN a.Sistema IN (N'SIA',N'SIAT') AND NULLIF(LTRIM(RTRIM(a.DenominazioneSorgente)),N'') IS NULL THEN 1
      WHEN a.TipoAnomalia = N'ORGANIZZAZIONE_NON_TROVATA' THEN 2
      WHEN a.TipoAnomalia = N'SEDE_UO_NON_RICONCILIATA' THEN 3
      WHEN a.TipoAnomalia = N'FISCALITA_ASSENTE' THEN 4
      ELSE 5
    END AS PrioritaOperativa,
    a.DataRilevazione
FROM ImportSIAC.vw_OrganizzazioneBonificaAnomaliaAperta a;

GO

