CREATE TABLE [Standard].[ClassificazioneApplicabilitaOrganizzazione] (
    [ClassificazioneId]        INT                                         NOT NULL,
    [RiferimentoDocumentaleId] INT                                         NOT NULL,
    [Note]                     NVARCHAR (2000)                             NULL,
    [Attivo]                   BIT                                         CONSTRAINT [DF_ClassApplicabilitaOrganizzazione_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]            DATETIME2 (7)                               CONSTRAINT [DF_ClassApplicabilitaOrganizzazione_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                 INT                                         NULL,
    [DataModifica]             DATETIME2 (7)                               NULL,
    [ModificatoDa]             INT                                         NULL,
    [DataCancellazione]        DATETIME2 (7)                               NULL,
    [CancellatoDa]             INT                                         NULL,
    [UniqueRowId]              UNIQUEIDENTIFIER                            CONSTRAINT [DF_ClassApplicabilitaOrganizzazione_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]         DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_ClassApplicabilitaOrganizzazione] PRIMARY KEY CLUSTERED ([ClassificazioneId] ASC),
    CONSTRAINT [FK_ClassApplicabilitaOrganizzazione_Classificazione] FOREIGN KEY ([ClassificazioneId]) REFERENCES [Standard].[Classificazione] ([ClassificazioneId]),
    CONSTRAINT [FK_ClassApplicabilitaOrganizzazione_Riferimento] FOREIGN KEY ([RiferimentoDocumentaleId]) REFERENCES [Standard].[RiferimentoDocumentale] ([RiferimentoDocumentaleId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[ClassificazioneApplicabilitaOrganizzazioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Abilita in modo documentato una classificazione all assegnazione diretta alle organizzazioni.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneApplicabilitaOrganizzazione';


GO

