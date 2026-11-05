CREATE TABLE [Standard].[ClassificazioneVersioneDecorrenza] (
    [ClassificazioneVersioneDecorrenzaId] INT                                         IDENTITY (1, 1) NOT NULL,
    [ClassificazioneVersioneId]           INT                                         NOT NULL,
    [ClassificazioneId]                   INT                                         NOT NULL,
    [TipoDecorrenzaClassificazioneId]     INT                                         NOT NULL,
    [DataInizio]                          DATE                                        NOT NULL,
    [DataFine]                            DATE                                        NULL,
    [RiferimentoDocumentaleId]            INT                                         NOT NULL,
    [Note]                                NVARCHAR (2000)                             NULL,
    [Attivo]                              BIT                                         CONSTRAINT [DF_ClassVersDecorrenza_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                       DATETIME2 (7)                               CONSTRAINT [DF_ClassVersDecorrenza_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                            INT                                         NULL,
    [DataModifica]                        DATETIME2 (7)                               NULL,
    [ModificatoDa]                        INT                                         NULL,
    [DataCancellazione]                   DATETIME2 (7)                               NULL,
    [CancellatoDa]                        INT                                         NULL,
    [UniqueRowId]                         UNIQUEIDENTIFIER                            CONSTRAINT [DF_ClassVersDecorrenza_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                  DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]                    DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_ClassificazioneVersioneDecorrenza] PRIMARY KEY CLUSTERED ([ClassificazioneVersioneDecorrenzaId] ASC),
    CONSTRAINT [CK_ClassVersDecorrenza_Intervallo] CHECK ([DataFine] IS NULL OR [DataFine]>=[DataInizio]),
    CONSTRAINT [FK_ClassVersDecorrenza_Riferimento] FOREIGN KEY ([RiferimentoDocumentaleId]) REFERENCES [Standard].[RiferimentoDocumentale] ([RiferimentoDocumentaleId]),
    CONSTRAINT [FK_ClassVersDecorrenza_Tipo] FOREIGN KEY ([TipoDecorrenzaClassificazioneId]) REFERENCES [Standard].[TipoDecorrenzaClassificazione] ([TipoDecorrenzaClassificazioneId]),
    CONSTRAINT [FK_ClassVersDecorrenza_Versione] FOREIGN KEY ([ClassificazioneVersioneId], [ClassificazioneId]) REFERENCES [Standard].[ClassificazioneVersione] ([ClassificazioneVersioneId], [ClassificazioneId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[ClassificazioneVersioneDecorrenzaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_ClassVersDecorrenza_Riferimento]
    ON [Standard].[ClassificazioneVersioneDecorrenza]([RiferimentoDocumentaleId] ASC)
    INCLUDE([ClassificazioneVersioneId], [TipoDecorrenzaClassificazioneId], [DataInizio], [DataFine], [Attivo]) WHERE ([DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ClassVersDecorrenza_Versione_Tipo]
    ON [Standard].[ClassificazioneVersioneDecorrenza]([ClassificazioneVersioneId] ASC, [TipoDecorrenzaClassificazioneId] ASC) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Decorrenze di business tipizzate e documentate di una versione classificatoria; distingue, ad esempio, entrata in vigore e adozione operativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneDecorrenza';


GO

