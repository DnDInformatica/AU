CREATE TABLE [Standard].[TipoProprietario] (
    [TipoProprietarioId] INT                                         IDENTITY (1, 1) NOT NULL,
    [Codice]             NVARCHAR (80)                               NOT NULL,
    [Descrizione]        NVARCHAR (1000)                             NOT NULL,
    [Attivo]             BIT                                         CONSTRAINT [DF_TipoProprietario_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]      DATETIME2 (7)                               CONSTRAINT [DF_TipoProprietario_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]           INT                                         NULL,
    [DataModifica]       DATETIME2 (7)                               NULL,
    [ModificatoDa]       INT                                         NULL,
    [DataCancellazione]  DATETIME2 (7)                               NULL,
    [CancellatoDa]       INT                                         NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER                            CONSTRAINT [DF_TipoProprietario_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_TipoProprietario] PRIMARY KEY CLUSTERED ([TipoProprietarioId] ASC),
    CONSTRAINT [UQ_TipoProprietario_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[TipoProprietarioStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione estesa del tipo proprietario.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoProprietario', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Lookup: tipologia del proprietario dello schema certificativo (autorita'' pubblica, terza parte, CAB). Normalizza il precedente TipoProprietario varchar con CHECK inline su SchemaCertificazioneProprietario.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoProprietario';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice del tipo proprietario: AUTORITA_PUBBLICA, TERZA_PARTE, ODC.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoProprietario', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata del tipo proprietario.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoProprietario', @level2type = N'COLUMN', @level2name = N'TipoProprietarioId';


GO

