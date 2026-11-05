CREATE   VIEW ImportSIAC.vw_NormaCensimentoDaRevisionare
AS
SELECT
    p.NormaCensimentoPropostaId,
    p.BatchId,
    p.Categoria,
    p.SourceValue,
    p.FonteLookup,
    p.Riferimento_Proposto,
    p.Codice_Proposto,
    p.CodiceVersione_Proposto,
    p.TitoloIta_Proposto,
    p.TitoloEng_Proposto,
    p.TipoNorma_Proposto,
    sn.Codice AS StatoNorma_Proposto,
    p.CategoriaFonte_Proposto,
    p.RiferimentiNormativiJson,
    naFiglio.Codice AS CollegataARevisioneDi,
    p.TipoRelazioneNormaId_Proposto,
    p.Azione,
    p.TargetEsistenteId,
    naTarget.Codice AS TargetEsistenteCodice,
    p.Stato,
    p.Note,
    p.DataCreazione
FROM ImportSIAC.NormaCensimentoProposta p
LEFT JOIN Standard.StatoNorma sn
    ON sn.StatoNormaId = p.StatoNormaId_Proposto
LEFT JOIN Standard.NormaAccreditamento naFiglio
    ON naFiglio.NormaAccreditamentoId = p.GerarchiaFiglioId_Proposto
LEFT JOIN Standard.NormaAccreditamento naTarget
    ON naTarget.NormaAccreditamentoId = p.TargetEsistenteId
WHERE p.Stato = N'PROPOSTA';

GO

