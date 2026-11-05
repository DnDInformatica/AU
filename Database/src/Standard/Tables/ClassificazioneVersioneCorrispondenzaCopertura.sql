CREATE TABLE [Standard].[ClassificazioneVersioneCorrispondenzaCopertura] (
    [ClassificazioneVersioneCorrispondenzaId] INT                                         NOT NULL,
    [RichiedeCoperturaOrigine]                BIT                                         NOT NULL,
    [RichiedeCoperturaDestinazione]           BIT                                         NOT NULL,
    [Note]                                    NVARCHAR (2000)                             NULL,
    [Attivo]                                  BIT                                         CONSTRAINT [DF_ClassVersCorrCopertura_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                           DATETIME2 (7)                               CONSTRAINT [DF_ClassVersCorrCopertura_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                                INT                                         NULL,
    [DataModifica]                            DATETIME2 (7)                               NULL,
    [ModificatoDa]                            INT                                         NULL,
    [DataCancellazione]                       DATETIME2 (7)                               NULL,
    [CancellatoDa]                            INT                                         NULL,
    [UniqueRowId]                             UNIQUEIDENTIFIER                            CONSTRAINT [DF_ClassVersCorrCopertura_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                      DATETIME2 (7) GENERATED ALWAYS AS ROW START CONSTRAINT [DF_ClassVersCorrCopertura_DataInizio] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]                        DATETIME2 (7) GENERATED ALWAYS AS ROW END   CONSTRAINT [DF_ClassVersCorrCopertura_DataFine] DEFAULT (CONVERT([datetime2],'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_ClassVersCorrCopertura] PRIMARY KEY CLUSTERED ([ClassificazioneVersioneCorrispondenzaId] ASC),
    CONSTRAINT [CK_ClassVersCorrCopertura_Richiesta] CHECK ([RichiedeCoperturaOrigine]=(1) OR [RichiedeCoperturaDestinazione]=(1)),
    CONSTRAINT [FK_ClassVersCorrCopertura_Header] FOREIGN KEY ([ClassificazioneVersioneCorrispondenzaId]) REFERENCES [Standard].[ClassificazioneVersioneCorrispondenza] ([ClassificazioneVersioneCorrispondenzaId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[ClassificazioneVersioneCorrispondenzaCoperturaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Estensione temporal 1:1 che dichiara se una corrispondenza curata richiede copertura completa del lato origine e/o destinazione. Distinta dai flag coercitivi verso ClassificazioneGovernance.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneCorrispondenzaCopertura';


GO

