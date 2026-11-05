CREATE TABLE [Documentale].[DocumentoPermesso] (
    [DocumentoPermessoId]        INT                                                IDENTITY (1, 1) NOT NULL,
    [DocumentoId]                INT                                                NOT NULL,
    [DestinatarioId]             INT                                                NOT NULL,
    [CanRead]                    BIT                                                DEFAULT ((1)) NOT NULL,
    [CanWrite]                   BIT                                                DEFAULT ((0)) NOT NULL,
    [CanApprove]                 BIT                                                DEFAULT ((0)) NOT NULL,
    [CanDelete]                  BIT                                                DEFAULT ((0)) NOT NULL,
    [DataCreazione]              DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                   INT                                                NULL,
    [DataModifica]               DATETIME2 (7)                                      NULL,
    [ModificatoDa]               INT                                                NULL,
    [DataCancellazione]          DATETIME2 (7)                                      NULL,
    [CancellatoDa]               INT                                                NULL,
    [UniqueRowId]                UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]         DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]           DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [TipoDestinatarioPermessoId] INT                                                NOT NULL,
    CONSTRAINT [PK_DocumentoPermesso] PRIMARY KEY CLUSTERED ([DocumentoPermessoId] ASC),
    CONSTRAINT [FK_DocumentoPermesso_Documento] FOREIGN KEY ([DocumentoId]) REFERENCES [Documentale].[Documento] ([DocumentoId]),
    CONSTRAINT [FK_DocumentoPermesso_TipoDestinatarioPermesso] FOREIGN KEY ([TipoDestinatarioPermessoId]) REFERENCES [Tipologica].[TipoDestinatarioPermesso] ([TipoDestinatarioPermessoId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Documentale].[DocumentoPermessoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_DocumentoPermesso_TipoDestinatarioPermessoId]
    ON [Documentale].[DocumentoPermesso]([TipoDestinatarioPermessoId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Permesso di approvazione documentale. Non sostituisce la decisione formale di accreditamento, delibera o validazione di certificazione.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanApprove';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoPermesso","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del destinatario interpretato secondo TipoDestinatario. Non ha FK fisica generalizzata e puo generare riferimenti orfani senza controlli.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DestinatarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'GUID tecnico globale del permesso documentale, utile per integrazioni e audit.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoPermesso;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanWrite';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoPermesso","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoPermesso","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoPermesso","column":"CanApprove","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanApprove';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoPermesso;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'documentale;acl;kernel;compliance', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanDelete';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica tecnica del permesso documentale.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoPermesso","column":"DestinatarioId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DestinatarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoPermesso;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanWrite';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DocumentoPermessoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoPermesso","column":"CanWrite","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanWrite';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoPermesso","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente o processo che ha cancellato logicamente il permesso documentale.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanDelete';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoPermesso","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanRead';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoPermesso","column":"DocumentoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Documentale.Documento.DocumentoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Permesso di modifica/caricamento sul documento. Deve essere coerente con stato documento/versione e workflow di approvazione.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanWrite';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanRead';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoPermesso;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Regole ACL a livello di documento per destinatari applicativi. Governa accesso e lavorazione interna; non equivale alla pubblicazione esterna in banca dati pubblica ne alla validita formale del documento.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanApprove';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente o processo che ha creato il permesso documentale.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoPermesso;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanDelete';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoPermesso;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DocumentoPermessoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DestinatarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoPermesso;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DocumentoPermessoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoPermesso","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanWrite';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoPermesso","column":"CanDelete","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanDelete';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoPermesso","column":"CanRead","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanRead';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio validita business del permesso documentale. Distinto dalla creazione tecnica.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoPermesso;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoPermesso;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanRead';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Documentale.Documento cui si applica il permesso. La FK risulta da verificare come trusted nel database.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DocumentoPermessoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DestinatarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica del permesso documentale.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanApprove';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione tecnica del permesso documentale.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoPermesso;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanDelete';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoPermesso;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanApprove';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoPermesso;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DestinatarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Permesso di cancellazione logica del documento o del collegamento. Da usare con cautela per documenti approvati/pubblicati.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanDelete';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoPermesso;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoPermesso","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata del permesso documentale.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DocumentoPermessoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanWrite';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanRead';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoPermesso","temporal":true,"temporal_type":2,"history_table":"Documentale.DocumentoPermessoStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanApprove';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ASSOCIAZIONE', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DestinatarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoPermesso;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoPermesso","column":"DocumentoPermessoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DocumentoPermessoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine validita business del permesso documentale. Distinto dalla cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Permesso di lettura del documento. Governa accesso interno, non pubblicazione esterna.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CanRead';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente o processo che ha modificato il permesso documentale.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoPermesso', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

