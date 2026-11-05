CREATE TABLE [Standard].[NormaEdizioneDipartimento] (
    [NormaEdizioneDipartimentoId] INT                                                IDENTITY (1, 1) NOT NULL,
    [NormaEdizioneId]             INT                                                NOT NULL,
    [DipartimentoAccrediaId]      INT                                                NOT NULL,
    [Note]                        NVARCHAR (500)                                     NULL,
    [Attivo]                      BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]               DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                    INT                                                NULL,
    [DataModifica]                DATETIME2 (7)                                      NULL,
    [ModificatoDa]                INT                                                NULL,
    [DataCancellazione]           DATETIME2 (7)                                      NULL,
    [CancellatoDa]                INT                                                NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [SettoreAccrediaId]           INT                                                NOT NULL,
    [DataInizioValidita]          DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]            DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_NormaEdizioneDipartimento] PRIMARY KEY CLUSTERED ([NormaEdizioneDipartimentoId] ASC),
    CONSTRAINT [FK_NormaEdizioneDipartimento_Dipartimento] FOREIGN KEY ([DipartimentoAccrediaId]) REFERENCES [Tipologica].[DipartimentoAccredia] ([DipartimentoAccrediaId]),
    CONSTRAINT [FK_NormaEdizioneDipartimento_NormaEdizione] FOREIGN KEY ([NormaEdizioneId]) REFERENCES [Standard].[NormaEdizione] ([NormaEdizioneId]),
    CONSTRAINT [FK_NormaEdizioneDipartimento_SettoreAccredia] FOREIGN KEY ([SettoreAccrediaId]) REFERENCES [Tipologica].[SettoreAccredia] ([SettoreAccrediaId]),
    CONSTRAINT [UQ_NormaEdizioneDipartimento] UNIQUE NONCLUSTERED ([NormaEdizioneId] ASC, [DipartimentoAccrediaId] ASC, [SettoreAccrediaId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[NormaEdizioneDipartimentoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

