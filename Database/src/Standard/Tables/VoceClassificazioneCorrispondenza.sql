CREATE TABLE [Standard].[VoceClassificazioneCorrispondenza] (
    [VoceClassificazioneCorrispondenzaId]     INT                                         IDENTITY (1, 1) NOT NULL,
    [ClassificazioneVersioneCorrispondenzaId] INT                                         NOT NULL,
    [ClassificazioneVersioneOrigineId]        INT                                         NOT NULL,
    [ClassificazioneOrigineId]                INT                                         NOT NULL,
    [ClassificazioneVersioneDestinazioneId]   INT                                         NOT NULL,
    [ClassificazioneDestinazioneId]           INT                                         NOT NULL,
    [VoceOrigineId]                           INT                                         NOT NULL,
    [EspressioneFonte]                        NVARCHAR (1000)                             NULL,
    [Ordine]                                  INT                                         NOT NULL,
    [Note]                                    NVARCHAR (2000)                             NULL,
    [Attivo]                                  BIT                                         CONSTRAINT [DF_VoceClassificazioneCorrispondenza_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                           DATETIME2 (7)                               CONSTRAINT [DF_VoceClassificazioneCorrispondenza_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                                INT                                         NULL,
    [DataModifica]                            DATETIME2 (7)                               NULL,
    [ModificatoDa]                            INT                                         NULL,
    [DataCancellazione]                       DATETIME2 (7)                               NULL,
    [CancellatoDa]                            INT                                         NULL,
    [UniqueRowId]                             UNIQUEIDENTIFIER                            CONSTRAINT [DF_VoceClassificazioneCorrispondenza_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                      DATETIME2 (7) GENERATED ALWAYS AS ROW START CONSTRAINT [DF_VoceClassCorr_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]                        DATETIME2 (7) GENERATED ALWAYS AS ROW END   CONSTRAINT [DF_VoceClassCorr_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_VoceClassificazioneCorrispondenza] PRIMARY KEY CLUSTERED ([VoceClassificazioneCorrispondenzaId] ASC),
    CONSTRAINT [CK_VoceClassCorr_Espressione] CHECK ([EspressioneFonte] IS NULL OR len(ltrim(rtrim([EspressioneFonte])))>(0)),
    CONSTRAINT [CK_VoceClassCorr_Ordine] CHECK ([Ordine]>=(0)),
    CONSTRAINT [FK_VoceClassCorr_Header] FOREIGN KEY ([ClassificazioneVersioneCorrispondenzaId], [ClassificazioneVersioneOrigineId], [ClassificazioneOrigineId], [ClassificazioneVersioneDestinazioneId], [ClassificazioneDestinazioneId]) REFERENCES [Standard].[ClassificazioneVersioneCorrispondenza] ([ClassificazioneVersioneCorrispondenzaId], [ClassificazioneVersioneOrigineId], [ClassificazioneOrigineId], [ClassificazioneVersioneDestinazioneId], [ClassificazioneDestinazioneId]),
    CONSTRAINT [FK_VoceClassCorr_VoceOrigine] FOREIGN KEY ([VoceOrigineId], [ClassificazioneVersioneOrigineId], [ClassificazioneOrigineId]) REFERENCES [Standard].[VoceClassificazione] ([VoceClassificazioneId], [ClassificazioneVersioneId], [ClassificazioneId]),
    CONSTRAINT [UQ_VoceClassCorr_IdDestinazione] UNIQUE NONCLUSTERED ([VoceClassificazioneCorrispondenzaId] ASC, [ClassificazioneVersioneDestinazioneId] ASC, [ClassificazioneDestinazioneId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[VoceClassificazioneCorrispondenzaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_VoceClassCorr_HeaderOrigine]
    ON [Standard].[VoceClassificazioneCorrispondenza]([ClassificazioneVersioneCorrispondenzaId] ASC, [VoceOrigineId] ASC) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine UTC del periodo di validita di sistema gestito da Azure SQL temporal.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazioneCorrispondenza', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Espressione testuale puntuale riportata nella fonte ufficiale.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazioneCorrispondenza', @level2type = N'COLUMN', @level2name = N'EspressioneFonte';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio UTC del periodo di validita di sistema gestito da Azure SQL temporal.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazioneCorrispondenza', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Regola di corrispondenza associata a una singola voce origine.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazioneCorrispondenza';


GO

