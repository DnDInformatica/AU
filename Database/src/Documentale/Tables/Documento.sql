CREATE TABLE [Documentale].[Documento] (
    [DocumentoId]        INT                                                IDENTITY (1, 1) NOT NULL,
    [Codice]             NVARCHAR (200)                                     NULL,
    [Titolo]             NVARCHAR (600)                                     NOT NULL,
    [Descrizione]        NVARCHAR (MAX)                                     NULL,
    [Riservato]          BIT                                                DEFAULT ((0)) NOT NULL,
    [OwnerPersonaId]     INT                                                NULL,
    [DataDocumento]      DATE                                               NULL,
    [DataPubblicazione]  DATE                                               NULL,
    [DataScadenza]       DATE                                               NULL,
    [DataCreazione]      DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]           INT                                                NULL,
    [DataModifica]       DATETIME2 (7)                                      NULL,
    [ModificatoDa]       INT                                                NULL,
    [DataCancellazione]  DATETIME2 (7)                                      NULL,
    [CancellatoDa]       INT                                                NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [StatoDocumentoId]   INT                                                NOT NULL,
    [TipoDocumentoId]    INT                                                NOT NULL,
    CONSTRAINT [PK_Documento] PRIMARY KEY CLUSTERED ([DocumentoId] ASC),
    CONSTRAINT [CK_Documento_Date] CHECK ([DataScadenza] IS NULL OR [DataDocumento] IS NULL OR [DataScadenza]>=[DataDocumento]),
    CONSTRAINT [FK_Documento_OwnerPersona] FOREIGN KEY ([OwnerPersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [FK_Documento_StatoDocumento] FOREIGN KEY ([StatoDocumentoId]) REFERENCES [Tipologica].[StatoDocumento] ([StatoDocumentoId]),
    CONSTRAINT [FK_Documento_TipoDocumento] FOREIGN KEY ([TipoDocumentoId]) REFERENCES [Tipologica].[TipoDocumento] ([TipoDocumentoId]),
    CONSTRAINT [UQ_Documento_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Documentale].[DocumentoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_Documento_TipoDocumentoId]
    ON [Documentale].[Documento]([TipoDocumentoId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Documento_StatoDocumentoId]
    ON [Documentale].[Documento]([StatoDocumentoId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:Documento;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:Documento;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:Documento;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Testata logica del documento nel repository documentale SIDAC. Identifica il documento e i suoi metadati generali; le versioni fisiche e i file sono in Documentale.DocumentoVersione. Il documento rappresenta o supporta dati strutturati, ma non deve sostituire il dato approvato di scopo, certificazione, delibera o pratica.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataPubblicazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"Documento","column":"DataScadenza","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"Documento","temporal":true,"temporal_type":2,"history_table":"Documentale.DocumentoStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente o processo che ha effettuato la cancellazione logica della testata documentale.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"Documento","column":"Descrizione","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di scadenza o validita prevista del documento. Non equivale automaticamente alla scadenza dell''accreditamento, della certificazione o dello scopo collegato.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Riservato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:Documento;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'OwnerPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"Documento","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:Documento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di riservatezza del documento. Governa la gestione interna/accesso, ma non basta per determinare se un contenuto sia pubblicabile o pubblicato.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Riservato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataDocumento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"Documento","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'GUID tecnico globale del record, utile per integrazioni e riconciliazioni. Non sostituisce la business key documentale o il codice del documento.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:Documento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:Documento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"Documento","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Riservato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"Documento","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataDocumento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"Documento","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice documentale leggibile o business, quando disponibile. Deve essere un riferimento umano/stabile; la chiave tecnica resta DocumentoId.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:Documento;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"Documento","column":"OwnerPersonaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'OwnerPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'OwnerPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"Documento","column":"Riservato","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Riservato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:Documento;Nullable', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso la persona proprietaria/responsabile del documento, quando il documento e assegnato a un soggetto persona. La FK risulta da verificare come trusted nel database.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'OwnerPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente o processo che ha effettuato l''ultima modifica dei metadati della testata documentale.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata della testata documentale. Identifica il documento logico indipendentemente dalle sue versioni fisiche.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:Documento;Nullable', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataDocumento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataPubblicazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione tecnica della testata documentale. Distinto dalla data propria del documento e dalla data di generazione della versione file.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica della testata documentale. Non deve cancellare lo storico delle versioni gia approvate o pubblicate.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente o processo che ha creato la testata documentale. Da ricondurre al modello IAM/audit applicativo.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'OwnerPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Riservato';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Titolo del documento. Deve descrivere il contenuto documentale senza sostituire classificazioni strutturate come tipo documento, stato, oggetto collegato o versione.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:Documento;Nullable', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"Documento","column":"DataDocumento","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataDocumento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"Documento","column":"Codice","data_type":"nvarchar","max_length":400,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"Documento","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:Documento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataPubblicazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"Documento","column":"DocumentoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data propria del documento, distinta da creazione record, generazione file, approvazione e pubblicazione.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataDocumento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:Documento;Nullable', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataPubblicazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio validita business della testata documentale. Distinto dallo storico tecnico della temporal table e dalla data di pubblicazione.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'OwnerPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"Documento","column":"Titolo","data_type":"nvarchar","max_length":1200,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataDocumento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica tecnica dei metadati della testata documentale. Non rappresenta una nuova versione formale del file.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"Documento","column":"DataPubblicazione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataPubblicazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'documentale;workflow;kernel;compliance', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:Documento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"Documento","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'MASTER', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data informativa di pubblicazione associata alla testata documentale. Non e sufficiente da sola per ricostruire una pubblicazione storica senza versione, canale, stato e ritiro.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataPubblicazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione estesa del contenuto o finalita del documento. Campo narrativo: non usarlo come unico luogo per requisiti, stati, oggetti di scopo o decisioni formali.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:Documento;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Riservato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:Documento;Nullable', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine validita business della testata documentale. Non equivale automaticamente al ritiro della pubblicazione se non collegata a un evento/versione di pubblicazione.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

