CREATE TABLE [Documentale].[DocumentoCollegamento] (
    [DocumentoCollegamentoId]      INT                                                IDENTITY (1, 1) NOT NULL,
    [DocumentoId]                  INT                                                NOT NULL,
    [OggettoId]                    INT                                                NOT NULL,
    [Ordinamento]                  INT                                                NULL,
    [DataCreazione]                DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                     INT                                                NULL,
    [DataModifica]                 DATETIME2 (7)                                      NULL,
    [ModificatoDa]                 INT                                                NULL,
    [DataCancellazione]            DATETIME2 (7)                                      NULL,
    [CancellatoDa]                 INT                                                NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]           DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]             DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [RuoloCollegamentoDocumentoId] INT                                                NOT NULL,
    [TipoOggettoDominioId]         INT                                                NOT NULL,
    CONSTRAINT [PK_DocumentoCollegamento] PRIMARY KEY CLUSTERED ([DocumentoCollegamentoId] ASC),
    CONSTRAINT [FK_DocumentoCollegamento_Documento] FOREIGN KEY ([DocumentoId]) REFERENCES [Documentale].[Documento] ([DocumentoId]),
    CONSTRAINT [FK_DocumentoCollegamento_RuoloCollegamentoDocumento] FOREIGN KEY ([RuoloCollegamentoDocumentoId]) REFERENCES [Tipologica].[RuoloCollegamentoDocumento] ([RuoloCollegamentoDocumentoId]),
    CONSTRAINT [FK_DocumentoCollegamento_TipoOggettoDominio] FOREIGN KEY ([TipoOggettoDominioId]) REFERENCES [Tipologica].[TipoOggettoDominio] ([TipoOggettoDominioId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Documentale].[DocumentoCollegamentoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_DocumentoCollegamento_RuoloCollegamentoDocumentoId]
    ON [Documentale].[DocumentoCollegamento]([RuoloCollegamentoDocumentoId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_DocumentoCollegamento_TipoOggettoDominioId]
    ON [Documentale].[DocumentoCollegamento]([TipoOggettoDominioId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio validita business del collegamento fra documento e oggetto applicativo.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente o processo che ha creato il collegamento documento-oggetto.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoCollegamento","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DocumentoCollegamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ordine di presentazione dei documenti collegati allo stesso oggetto/ruolo. Non ha significato normativo salvo regole applicative esplicite.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'Ordinamento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente o processo che ha modificato il collegamento documento-oggetto.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'documentale;link;kernel;compliance', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoCollegamento","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'Ordinamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ASSOCIAZIONE', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoCollegamento;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoCollegamento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoCollegamento","column":"DocumentoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Documentale.Documento.DocumentoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DocumentoCollegamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine validita business del collegamento fra documento e oggetto applicativo. Non equivale al ritiro del documento o della pubblicazione.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Associazione fra documento e oggetto applicativo tramite riferimento polimorfico OggettoTipo/OggettoId. Utile come ponte generale, ma richiede controlli applicativi o viste/vincoli specializzati per evitare riferimenti orfani e ambiguita semantiche.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoCollegamento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoCollegamento;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoCollegamento","column":"Ordinamento","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'Ordinamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoCollegamento","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente o processo che ha cancellato logicamente il collegamento.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Documentale.Documento. Collega la testata documentale all''oggetto applicativo. La FK risulta da verificare come trusted nel database.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoCollegamento","temporal":true,"temporal_type":2,"history_table":"Documentale.DocumentoCollegamentoStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoCollegamento;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoCollegamento;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DocumentoCollegamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DocumentoCollegamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoCollegamento","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoCollegamento","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione tecnica del collegamento documento-oggetto.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica tecnica del collegamento documento-oggetto.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoCollegamento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'Ordinamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoCollegamento;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata del collegamento fra documento e oggetto applicativo.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DocumentoCollegamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'GUID tecnico globale del collegamento, utile per sincronizzazione e audit applicativo.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoCollegamento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoCollegamento","column":"DocumentoCollegamentoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DocumentoCollegamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoCollegamento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoCollegamento;Nullable', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'Ordinamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''oggetto applicativo collegato, interpretato secondo OggettoTipo. Non ha FK fisica generalizzabile e puo generare riferimenti orfani se non controllato.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoCollegamento","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'Ordinamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoCollegamento","column":"OggettoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica del collegamento. Non elimina il documento ne la sua versione fisica.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoCollegamento","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoCollegamento', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

