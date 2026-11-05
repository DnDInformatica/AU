CREATE   VIEW ImportSIAC.vw_OrganizzazioneBonificaIrrisoltaDocumentata AS
SELECT a.OrganizzazioneBonificaAnomaliaId,a.Sistema,a.CodiceSorgente,a.DenominazioneSorgente,
 a.CodiceFiscale,a.PartitaIVA,a.TipoAnomalia,a.Dettaglio,a.DataRilevazione,
 c.Classe,c.Esito,c.Motivazione,c.Fonte,c.DataClassificazione
FROM ImportSIAC.OrganizzazioneBonificaAnomalia a
JOIN ImportSIAC.OrganizzazioneBonificaClassificazione c ON c.OrganizzazioneBonificaAnomaliaId=a.OrganizzazioneBonificaAnomaliaId
WHERE a.Stato=N'APERTO' AND c.Esito=N'RESTA_APERTO';

GO

