CREATE   VIEW ImportSIAC.vw_OrganizzazioneFonteCopertura
AS
SELECT c.OrganizzazioneFonteCanonicaId,c.FiscalCodeRaw,c.VatNumberRaw,c.RagioneSociale,
 c.PrimoSnapshot,c.UltimoSnapshot,c.NumeroOccorrenze,c.NumeroVarianti,
 x.EntitaFonteId,e.EsitoRaccordo,e.MetodoRaccordo,e.OrganizzazioneId,
 o.RagioneSociale RagioneSocialeSIDAC,o.DataCancellazione
FROM ImportSIAC.OrganizzazioneFonteCanonica c
JOIN ImportSIAC.OrganizzazioneFonteComponente x
 ON x.OrganizzazioneFonteCanonicaId=c.OrganizzazioneFonteCanonicaId
JOIN ImportSIAC.OrganizzazioneFonteEntita e ON e.EntitaFonteId=x.EntitaFonteId
LEFT JOIN Organizzazioni.Organizzazione o ON o.OrganizzazioneId=e.OrganizzazioneId;

GO

