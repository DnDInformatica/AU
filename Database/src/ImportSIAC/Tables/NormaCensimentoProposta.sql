CREATE TABLE [ImportSIAC].[NormaCensimentoProposta] (
    [NormaCensimentoPropostaId]     INT              IDENTITY (1, 1) NOT NULL,
    [BatchId]                       UNIQUEIDENTIFIER NOT NULL,
    [Categoria]                     NVARCHAR (20)    NOT NULL,
    [SourceValue]                   NVARCHAR (400)   NOT NULL,
    [FonteLookup]                   NVARCHAR (60)    NOT NULL,
    [Azione]                        NVARCHAR (20)    CONSTRAINT [DF_NCP_Azione] DEFAULT (N'CENSISCI_NUOVA') NOT NULL,
    [TargetEsistenteId]             INT              NULL,
    [Riferimento_Proposto]          NVARCHAR (200)   NULL,
    [Codice_Proposto]               NVARCHAR (100)   NULL,
    [CodiceVersione_Proposto]       NVARCHAR (20)    NULL,
    [TitoloIta_Proposto]            NVARCHAR (1000)  NULL,
    [TitoloEng_Proposto]            NVARCHAR (1000)  NULL,
    [TipoNorma_Proposto]            NVARCHAR (30)    NULL,
    [CategoriaFonte_Proposto]       NVARCHAR (30)    NULL,
    [StatoNormaId_Proposto]         INT              NULL,
    [RiferimentiNormativiJson]      NVARCHAR (MAX)   NULL,
    [GerarchiaFiglioId_Proposto]    INT              NULL,
    [TipoRelazioneNormaId_Proposto] INT              NULL,
    [Stato]                         NVARCHAR (20)    CONSTRAINT [DF_NCP_Stato] DEFAULT (N'PROPOSTA') NOT NULL,
    [ApprovatoDa]                   NVARCHAR (100)   NULL,
    [DataApprovazione]              DATETIME2 (3)    NULL,
    [NormaCreataId]                 INT              NULL,
    [Note]                          NVARCHAR (2000)  NULL,
    [DataCreazione]                 DATETIME2 (3)    CONSTRAINT [DF_NCP_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_NormaCensimentoProposta] PRIMARY KEY CLUSTERED ([NormaCensimentoPropostaId] ASC),
    CONSTRAINT [CK_NCP_ApprovazioneEsplicita] CHECK (NOT ([Stato]=N'APPLICATA' OR [Stato]=N'APPROVATA') OR [ApprovatoDa] IS NOT NULL AND len(ltrim(rtrim([ApprovatoDa])))>(0) AND [DataApprovazione] IS NOT NULL),
    CONSTRAINT [CK_NCP_Azione] CHECK ([Azione]=N'IGNORA' OR [Azione]=N'MAPPA_A_ESISTENTE' OR [Azione]=N'CENSISCI_NUOVA'),
    CONSTRAINT [CK_NCP_Categoria] CHECK ([Categoria]=N'PP-NORMA' OR [Categoria]=N'FPC-STORICA' OR [Categoria]=N'FPC-CORRENTE'),
    CONSTRAINT [CK_NCP_IgnoraNonApprovabile] CHECK ([Azione]<>N'IGNORA' OR NOT ([Stato]=N'APPLICATA' OR [Stato]=N'APPROVATA')),
    CONSTRAINT [CK_NCP_Stato] CHECK ([Stato]=N'APPLICATA' OR [Stato]=N'RIFIUTATA' OR [Stato]=N'APPROVATA' OR [Stato]=N'PROPOSTA'),
    CONSTRAINT [FK_NCP_GerarchiaFiglio] FOREIGN KEY ([GerarchiaFiglioId_Proposto]) REFERENCES [Standard].[NormaAccreditamento] ([NormaAccreditamentoId]),
    CONSTRAINT [FK_NCP_NormaCreata] FOREIGN KEY ([NormaCreataId]) REFERENCES [Standard].[NormaAccreditamento] ([NormaAccreditamentoId]),
    CONSTRAINT [FK_NCP_StatoNorma] FOREIGN KEY ([StatoNormaId_Proposto]) REFERENCES [Standard].[StatoNorma] ([StatoNormaId]),
    CONSTRAINT [FK_NCP_TargetEsistente] FOREIGN KEY ([TargetEsistenteId]) REFERENCES [Standard].[NormaAccreditamento] ([NormaAccreditamentoId]),
    CONSTRAINT [FK_NCP_TipoRelazione] FOREIGN KEY ([TipoRelazioneNormaId_Proposto]) REFERENCES [Standard].[TipoRelazioneNorma] ([TipoRelazioneNormaId])
);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_NCP_SourceValue_Viva]
    ON [ImportSIAC].[NormaCensimentoProposta]([SourceValue] ASC) WHERE ([Stato]<>N'RIFIUTATA');


GO

CREATE NONCLUSTERED INDEX [IX_NCP_Batch_Stato]
    ON [ImportSIAC].[NormaCensimentoProposta]([BatchId] ASC, [Stato] ASC)
    INCLUDE([Categoria], [SourceValue], [Azione]);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'RiferimentiNormativiJson';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'CategoriaFonte_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;Nullable', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'DataApprovazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'NormaCreataId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"FonteLookup","data_type":"nvarchar","nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'FonteLookup';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TitoloIta_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stato norma proposto: vigente, in transizione o ritirata.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'StatoNormaId_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Azione scelta in revisione: censire, mappare a esistente o ignorare.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Azione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;NotNull', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"Codice_Proposto","data_type":"nvarchar","nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Codice_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'CodiceVersione_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'ApprovatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;Nullable', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'BatchId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'DataApprovazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"TitoloEng_Proposto","data_type":"nvarchar","nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TitoloEng_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Riferimento_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Workflow;HumanApproval;Norme;Lineage', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'SourceValue';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'StatoNormaId_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'NormaCensimentoPropostaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TipoRelazioneNormaId_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;NotNull', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'SourceValue';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;Nullable', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TitoloIta_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;Nullable', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'CategoriaFonte_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Categoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Azione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"GerarchiaFiglioId_Proposto","data_type":"int","nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'GerarchiaFiglioId_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TargetEsistenteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Norma esistente proposta come discendente della nuova norma.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'GerarchiaFiglioId_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;Nullable', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Riferimento_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Titolo inglese proposto.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TitoloEng_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogate della proposta.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'NormaCensimentoPropostaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice proposto, sottoposto a controllo deterministico delle collisioni.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Codice_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice di versione che identifica la lookup di provenienza.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'CodiceVersione_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'RiferimentiNormativiJson';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'DataApprovazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'FonteLookup';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Norma creata o scelta come esito dell applicazione.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'NormaCreataId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"NormaCreataId","data_type":"int","nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'NormaCreataId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"Azione","data_type":"nvarchar","nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Azione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'GerarchiaFiglioId_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'CategoriaFonte_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Categoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'NormaCensimentoPropostaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Norma esistente scelta per MAPPA_A_ESISTENTE.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TargetEsistenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;Nullable', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'StatoNormaId_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione della proposta.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"BatchId","data_type":"uniqueidentifier","nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'BatchId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","temporal":false,"soft_delete":false,"audit":true,"staging":false,"human_approval":true}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell operatore che ha approvato esplicitamente la proposta.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'ApprovatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TitoloEng_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"ApprovatoDa","data_type":"nvarchar","nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"EmployeeIdentifier"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'ApprovatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"DataCreazione","data_type":"datetime2","nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo norma proposto, modificabile in revisione.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TipoNorma_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TitoloIta_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TipoRelazioneNormaId_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore della generazione che ha prodotto la proposta.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'BatchId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"NormaCensimentoPropostaId","data_type":"int","nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'NormaCensimentoPropostaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"StatoNormaId_Proposto","data_type":"int","nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'StatoNormaId_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;NotNull', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'FonteLookup';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TipoNorma_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Riferimento_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;Nullable', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Codice_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;Nullable', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TitoloEng_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TargetEsistenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'SourceValue';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;Nullable', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'GerarchiaFiglioId_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;Nullable', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'CodiceVersione_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;Nullable', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'NormaCreataId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'DataApprovazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Azione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'NormaCreataId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Riferimento_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TitoloEng_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Codice_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'CategoriaFonte_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"TargetEsistenteId","data_type":"int","nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TargetEsistenteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimenti normativi della lookup serializzati come JSON.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'RiferimentiNormativiJson';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;NotNull', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;Nullable', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TipoNorma_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Citazione norma grezza irrisolta che costituisce la chiave logica della proposta.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'SourceValue';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Titolo italiano proposto.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TitoloIta_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"RiferimentiNormativiJson","data_type":"nvarchar","nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'RiferimentiNormativiJson';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'NormaCensimentoPropostaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"Categoria","data_type":"nvarchar","nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Categoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;Nullable', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'ApprovatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'ApprovatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"TipoNorma_Proposto","data_type":"nvarchar","nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TipoNorma_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'FonteLookup';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"TipoRelazioneNormaId_Proposto","data_type":"int","nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TipoRelazioneNormaId_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;NotNull', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Azione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo della relazione gerarchica proposta.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TipoRelazioneNormaId_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Categoria della fonte: FPC corrente, FPC storica o norma PP.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Categoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Codice_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"CodiceVersione_Proposto","data_type":"nvarchar","nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'CodiceVersione_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'WORKFLOW', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'NormaCensimentoPropostaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'SourceValue';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TitoloIta_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'StatoNormaId_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;NotNull', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'BatchId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'GerarchiaFiglioId_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"CategoriaFonte_Proposto","data_type":"nvarchar","nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'CategoriaFonte_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TitoloEng_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"SourceValue","data_type":"nvarchar","nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'SourceValue';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Coda governata di proposte per il censimento delle norme SIAC: generazione automatica, revisione umana obbligatoria e applicazione transazionale.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;Nullable', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'RiferimentiNormativiJson';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"Note","data_type":"nvarchar","nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TargetEsistenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Codice_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"DataApprovazione","data_type":"datetime2","nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'DataApprovazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'NormaCreataId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell approvazione umana.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'DataApprovazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"Riferimento_Proposto","data_type":"nvarchar","nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Riferimento_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'BatchId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stato del workflow: proposta, approvata, rifiutata o applicata.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TipoNorma_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"Stato","data_type":"nvarchar","nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Categoria';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Annotazioni di revisione o dettaglio dell errore di applicazione.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'ApprovatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'RiferimentiNormativiJson';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'CodiceVersione_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Lookup RAW dalla quale sono stati derivati i valori proposti.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'FonteLookup';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'BatchId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento proposto per Standard.NormaAccreditamento.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Riferimento_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;Nullable', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TargetEsistenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TipoRelazioneNormaId_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Azione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'CodiceVersione_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;NotNull', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'Categoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'StatoNormaId_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:ImportSIAC;Table:NormaCensimentoProposta;Nullable', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TipoRelazioneNormaId_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'GerarchiaFiglioId_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"ImportSIAC","table":"NormaCensimentoProposta","column":"TitoloIta_Proposto","data_type":"nvarchar","nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TitoloIta_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'FonteLookup';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'TipoNorma_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Categoria fonte proposta, modificabile in revisione.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta', @level2type = N'COLUMN', @level2name = N'CategoriaFonte_Proposto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'NormaCensimentoProposta';


GO

