
CREATE   VIEW ImportSIAC.vw_OrganizzazioneBonificaAnomaliaAperta
AS
SELECT OrganizzazioneBonificaAnomaliaId,Sistema,CodiceSorgente,DenominazioneSorgente,
       CodiceFiscale,PartitaIVA,TipoAnomalia,Dettaglio,DataRilevazione
FROM ImportSIAC.OrganizzazioneBonificaAnomalia
WHERE Stato=N'APERTO';

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Coda operativa dei record GIDAS/SIA/SIAT non collegabili automaticamente. Non rappresenta nuove organizzazioni: richiede visura, verifica evento societario o riconciliazione sede/UO.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'VIEW', @level1name = N'vw_OrganizzazioneBonificaAnomaliaAperta';


GO

