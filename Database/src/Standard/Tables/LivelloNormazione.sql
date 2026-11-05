CREATE TABLE [Standard].[LivelloNormazione] (
    [LivelloNormazioneId]   INT                                                IDENTITY (1, 1) NOT NULL,
    [Codice]                VARCHAR (20)                                       NOT NULL,
    [Denominazione]         NVARCHAR (100)                                     NOT NULL,
    [Descrizione]           NVARCHAR (500)                                     NULL,
    [OrdineVisualizzazione] SMALLINT                                           NOT NULL,
    [Attivo]                BIT                                                CONSTRAINT [DF_LivelloNormazione_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]         DATETIME2 (7)                                      CONSTRAINT [DF_LivelloNormazione_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]              INT                                                NULL,
    [DataModifica]          DATETIME2 (7)                                      NULL,
    [ModificatoDa]          INT                                                NULL,
    [DataCancellazione]     DATETIME2 (7)                                      NULL,
    [CancellatoDa]          INT                                                NULL,
    [UniqueRowId]           UNIQUEIDENTIFIER                                   CONSTRAINT [DF_LivelloNormazione_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita]    DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_LivelloNormazione_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]      DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_LivelloNormazione_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_LivelloNormazione] PRIMARY KEY CLUSTERED ([LivelloNormazioneId] ASC),
    CONSTRAINT [CK_LivelloNormazione_Cancellazione] CHECK ([DataCancellazione] IS NULL AND [CancellatoDa] IS NULL OR [DataCancellazione] IS NOT NULL),
    CONSTRAINT [CK_LivelloNormazione_Codice] CHECK (len(ltrim(rtrim([Codice])))>(0)),
    CONSTRAINT [CK_LivelloNormazione_Denominazione] CHECK (len(ltrim(rtrim([Denominazione])))>(0)),
    CONSTRAINT [CK_LivelloNormazione_OrdineVisualizzazione] CHECK ([OrdineVisualizzazione]>(0)),
    CONSTRAINT [UQ_LivelloNormazione_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    CONSTRAINT [UQ_LivelloNormazione_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[LivelloNormazioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

