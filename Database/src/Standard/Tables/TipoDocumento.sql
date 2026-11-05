CREATE TABLE [Standard].[TipoDocumento] (
    [TipoDocumentoId]    INT                                         IDENTITY (1, 1) NOT NULL,
    [Codice]             NVARCHAR (80)                               NOT NULL,
    [Descrizione]        NVARCHAR (1000)                             NOT NULL,
    [Attivo]             BIT                                         CONSTRAINT [DF_TipoDocumento_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]      DATETIME2 (7)                               CONSTRAINT [DF_TipoDocumento_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]           INT                                         NULL,
    [DataModifica]       DATETIME2 (7)                               NULL,
    [ModificatoDa]       INT                                         NULL,
    [DataCancellazione]  DATETIME2 (7)                               NULL,
    [CancellatoDa]       INT                                         NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER                            CONSTRAINT [DF_TipoDocumento_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_TipoDocumento] PRIMARY KEY CLUSTERED ([TipoDocumentoId] ASC),
    CONSTRAINT [UQ_TipoDocumento_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[TipoDocumentoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione estesa del tipo documento.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoDocumento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Lookup: tipologia del documento associato a una versione di schema certificativo (regolamento, requisiti, guida, lista parti, altro). Normalizza il precedente TipoDocumento varchar con CHECK inline su SchemaCertificazioneDocumento.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoDocumento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice del tipo documento: REGOLAMENTO_SCHEMA, REQUISITI, GUIDA, LISTA_PARTI, ALTRO.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoDocumento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata del tipo documento.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoDocumento', @level2type = N'COLUMN', @level2name = N'TipoDocumentoId';


GO

