CREATE TABLE [Documentale].[DocumentoVersione] (
    [DocumentoVersioneId]      INT                                                IDENTITY (1, 1) NOT NULL,
    [DocumentoId]              INT                                                NOT NULL,
    [NumeroVersione]           INT                                                NOT NULL,
    [NomeFile]                 NVARCHAR (500)                                     NOT NULL,
    [StorageKey]               NVARCHAR (1000)                                    NOT NULL,
    [ContentType]              NVARCHAR (200)                                     NOT NULL,
    [HashSha256]               NVARCHAR (128)                                     NULL,
    [DimensioneBytes]          BIGINT                                             NOT NULL,
    [NoteVersione]             NVARCHAR (1000)                                    NULL,
    [IsVersioneCorrente]       BIT                                                DEFAULT ((0)) NOT NULL,
    [DataCreazione]            DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                 INT                                                NULL,
    [DataModifica]             DATETIME2 (7)                                      NULL,
    [ModificatoDa]             INT                                                NULL,
    [DataCancellazione]        DATETIME2 (7)                                      NULL,
    [CancellatoDa]             INT                                                NULL,
    [UniqueRowId]              UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]         DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [StatoVersioneDocumentoId] INT                                                NOT NULL,
    CONSTRAINT [PK_DocumentoVersione] PRIMARY KEY CLUSTERED ([DocumentoVersioneId] ASC),
    CONSTRAINT [CK_DocumentoVersione_Dimensione] CHECK ([DimensioneBytes]>=(0)),
    CONSTRAINT [FK_DocumentoVersione_Documento] FOREIGN KEY ([DocumentoId]) REFERENCES [Documentale].[Documento] ([DocumentoId]),
    CONSTRAINT [FK_DocumentoVersione_StatoVersioneDocumento] FOREIGN KEY ([StatoVersioneDocumentoId]) REFERENCES [Tipologica].[StatoVersioneDocumento] ([StatoVersioneDocumentoId]),
    CONSTRAINT [UQ_DocumentoVersione_Documento_Numero] UNIQUE NONCLUSTERED ([DocumentoId] ASC, [NumeroVersione] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Documentale].[DocumentoVersioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_DocumentoVersione_StatoVersioneDocumentoId]
    ON [Documentale].[DocumentoVersione]([StatoVersioneDocumentoId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente o processo che ha creato la versione documentale.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note sulla versione, ad esempio motivo di sostituzione, rettifica, rigenerazione o dettaglio operativo. Campo narrativo, non sostituisce evento/decisione strutturata.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'NoteVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'IsVersioneCorrente';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione tecnica della versione documentale. Distinto da data documento, data approvazione e data pubblicazione.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoVersione;NotNull;PII', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'NomeFile';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag che indica la versione corrente del documento logico. Deve essere protetto da regole di unicita per evitare piu versioni correnti e non prova da solo cosa fosse pubblicato in passato.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'IsVersioneCorrente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica tecnica dei metadati della versione. Le versioni approvate/pubblicate dovrebbero essere trattate come immutabili.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoVersione","column":"NomeFile","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"PII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'NomeFile';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dimensione del file in byte. Dato tecnico per storage, controllo integrita e diagnostica.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DimensioneBytes';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine validita business della versione documentale. Non equivale automaticamente al ritiro pubblico senza un evento/canale di pubblicazione.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'NoteVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DimensioneBytes';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DocumentoVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoVersione;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'NumeroVersione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente o processo che ha effettuato l''ultima modifica della versione documentale.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Hash SHA-256 del contenuto della versione, utile per integrita, non ripudio tecnico e riconciliazione. Da valorizzare per versioni approvate o pubblicate.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'HashSha256';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoVersione;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoVersione","column":"ContentType","data_type":"nvarchar","max_length":400,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'ContentType';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoVersione;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'StorageKey';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoVersione","column":"StorageKey","data_type":"nvarchar","max_length":2000,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'StorageKey';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoVersione","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoVersione;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'StorageKey';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente o processo che ha effettuato la cancellazione logica della versione.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoVersione","column":"DocumentoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Documentale.Documento.DocumentoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'GUID tecnico globale della versione documentale, utile per integrazioni e riconciliazioni.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nome del file associato alla versione. Informazione di presentazione/riconciliazione, non chiave primaria del documento.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'NomeFile';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoVersione","temporal":true,"temporal_type":2,"history_table":"Documentale.DocumentoVersioneStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'NoteVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'IsVersioneCorrente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'IsVersioneCorrente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DocumentoVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'HashSha256';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoVersione","column":"NumeroVersione","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'NumeroVersione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica della versione. Non deve compromettere la ricostruzione delle versioni approvate o pubblicate.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'MIME type o tipo contenuto del file, ad esempio application/pdf. Non definisce da solo la natura funzionale del documento.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'ContentType';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'ContentType';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoVersione;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave di storage del file nel repository fisico o object storage. Deve identificare in modo stabile il contenuto archiviato della versione.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'StorageKey';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'ContentType';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'ContentType';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Documentale.Documento. Collega la versione fisica alla testata logica del documento. La FK risulta da verificare come trusted nel database.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'documentale;versioning;kernel;compliance', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'StorageKey';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DimensioneBytes';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'NoteVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoVersione;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DocumentoVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'NomeFile';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero progressivo della versione all''interno del documento. La coppia DocumentoId/NumeroVersione e vincolata come univoca.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'NumeroVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DimensioneBytes';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoVersione","column":"DocumentoVersioneId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DocumentoVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'HashSha256';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'NumeroVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'HashSha256';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoVersione;Nullable', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'HashSha256';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoVersione;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DocumentoVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'NumeroVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoVersione","column":"HashSha256","data_type":"nvarchar","max_length":256,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'HashSha256';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoVersione","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoVersione;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'ContentType';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoVersione;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'NumeroVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoVersione","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Versione fisica/logica di un documento con file, storage key, hash, dimensione e stato. Deve essere usata per distinguere bozze, versioni approvate, versioni sostituite e file pubblicati; il flag di versione corrente non prova da solo cosa fosse pubblicato in una data storica.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'StorageKey';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoVersione","column":"IsVersioneCorrente","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'IsVersioneCorrente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoVersione","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoVersione;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoVersione;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'IsVersioneCorrente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoVersione","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoVersione","column":"NoteVersione","data_type":"nvarchar","max_length":2000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'NoteVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoVersione","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoVersione;Nullable', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'NoteVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'NomeFile';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio validita business della versione documentale. Distinto dalla creazione tecnica e dalla pubblicazione esterna.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoVersione;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata della versione documentale. Identifica il file/versione specifica del documento logico.', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DocumentoVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'NomeFile';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoVersione","column":"DimensioneBytes","data_type":"bigint","max_length":8,"precision":19,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DimensioneBytes';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Documentale","table":"DocumentoVersione","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoVersione;NotNull', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DimensioneBytes';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Documentale;Table:DocumentoVersione;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Documentale', @level1type = N'TABLE', @level1name = N'DocumentoVersione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

