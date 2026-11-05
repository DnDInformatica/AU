CREATE TABLE [Standard].[TipoDecorrenzaClassificazione] (
    [TipoDecorrenzaClassificazioneId] INT                                         IDENTITY (1, 1) NOT NULL,
    [Codice]                          NVARCHAR (80)                               NOT NULL,
    [Denominazione]                   NVARCHAR (300)                              NOT NULL,
    [Descrizione]                     NVARCHAR (2000)                             NULL,
    [Attivo]                          BIT                                         CONSTRAINT [DF_TipoDecorrenzaClassificazione_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                   DATETIME2 (7)                               CONSTRAINT [DF_TipoDecorrenzaClassificazione_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                        INT                                         NULL,
    [DataModifica]                    DATETIME2 (7)                               NULL,
    [ModificatoDa]                    INT                                         NULL,
    [DataCancellazione]               DATETIME2 (7)                               NULL,
    [CancellatoDa]                    INT                                         NULL,
    [UniqueRowId]                     UNIQUEIDENTIFIER                            CONSTRAINT [DF_TipoDecorrenzaClassificazione_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]              DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]                DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_TipoDecorrenzaClassificazione] PRIMARY KEY CLUSTERED ([TipoDecorrenzaClassificazioneId] ASC),
    CONSTRAINT [CK_TipoDecorrenzaClassificazione_Codice] CHECK (len(ltrim(rtrim([Codice])))>(0)),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[TipoDecorrenzaClassificazioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_TipoDecorrenzaClassificazione_Codice]
    ON [Standard].[TipoDecorrenzaClassificazione]([Codice] ASC) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Vocabolario temporal dei tipi di decorrenza di una versione classificatoria.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoDecorrenzaClassificazione';


GO

