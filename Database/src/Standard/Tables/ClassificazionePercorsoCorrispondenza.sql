CREATE TABLE [Standard].[ClassificazionePercorsoCorrispondenza] (
    [ClassificazionePercorsoCorrispondenzaId] INT                                         IDENTITY (1, 1) NOT NULL,
    [Codice]                                  NVARCHAR (150)                              NOT NULL,
    [ClassificazioneVersioneOrigineId]        INT                                         NOT NULL,
    [ClassificazioneOrigineId]                INT                                         NOT NULL,
    [ClassificazioneVersioneDestinazioneId]   INT                                         NOT NULL,
    [ClassificazioneDestinazioneId]           INT                                         NOT NULL,
    [Finalita]                                NVARCHAR (500)                              NOT NULL,
    [EsitoInformativoFlag]                    BIT                                         CONSTRAINT [DF_ClassPercorsoCorr_EsitoInformativo] DEFAULT ((1)) NOT NULL,
    [Note]                                    NVARCHAR (3000)                             NULL,
    [Attivo]                                  BIT                                         CONSTRAINT [DF_ClassPercorsoCorr_Attivo] DEFAULT ((0)) NOT NULL,
    [DataCreazione]                           DATETIME2 (7)                               CONSTRAINT [DF_ClassPercorsoCorr_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                                INT                                         NULL,
    [DataModifica]                            DATETIME2 (7)                               NULL,
    [ModificatoDa]                            INT                                         NULL,
    [DataCancellazione]                       DATETIME2 (7)                               NULL,
    [CancellatoDa]                            INT                                         NULL,
    [UniqueRowId]                             UNIQUEIDENTIFIER                            CONSTRAINT [DF_ClassPercorsoCorr_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                      DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]                        DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_ClassificazionePercorsoCorrispondenza] PRIMARY KEY CLUSTERED ([ClassificazionePercorsoCorrispondenzaId] ASC),
    CONSTRAINT [CK_ClassPercorsoCorr_Codice] CHECK (len(ltrim(rtrim([Codice])))>(0)),
    CONSTRAINT [CK_ClassPercorsoCorr_VersioniDistinte] CHECK ([ClassificazioneVersioneOrigineId]<>[ClassificazioneVersioneDestinazioneId]),
    CONSTRAINT [FK_ClassPercorsoCorr_VersioneDestinazione] FOREIGN KEY ([ClassificazioneVersioneDestinazioneId], [ClassificazioneDestinazioneId]) REFERENCES [Standard].[ClassificazioneVersione] ([ClassificazioneVersioneId], [ClassificazioneId]),
    CONSTRAINT [FK_ClassPercorsoCorr_VersioneOrigine] FOREIGN KEY ([ClassificazioneVersioneOrigineId], [ClassificazioneOrigineId]) REFERENCES [Standard].[ClassificazioneVersione] ([ClassificazioneVersioneId], [ClassificazioneId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[ClassificazionePercorsoCorrispondenzaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ClassPercorsoCorr_Codice]
    ON [Standard].[ClassificazionePercorsoCorrispondenza]([Codice] ASC) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Percorso curato e versionato che compone piu corrispondenze senza duplicarne le associazioni.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazionePercorsoCorrispondenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Vale 1 quando l esito e analitico e non costituisce attribuzione o attestazione ufficiale.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazionePercorsoCorrispondenza', @level2type = N'COLUMN', @level2name = N'EsitoInformativoFlag';


GO

