CREATE   VIEW Standard.vw_NormaEdizioneCompat AS
SELECT na.NormaAccreditamentoId,
       na.Codice,
       d.NormaDesignazioneId,
       d.Preferita,
       e.NormaEdizioneId,
       e.Riferimento       AS RiferimentoEdizione,
       e.AnnoEdizione,
       e.NormaFamigliaId,
       f.CodiceFamiglia,
       e.StatoNormaId
FROM Standard.NormaAccreditamento na
JOIN Standard.NormaDesignazione d ON d.RiferimentoDesignazione = na.Codice
JOIN Standard.NormaEdizione     e ON e.NormaEdizioneId = d.NormaEdizioneId
JOIN Standard.NormaFamiglia     f ON f.NormaFamigliaId = e.NormaFamigliaId;

GO

