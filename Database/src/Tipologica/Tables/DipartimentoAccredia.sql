CREATE TABLE [Tipologica].[DipartimentoAccredia] (
    [DipartimentoAccrediaId] INT                                                IDENTITY (1, 1) NOT NULL,
    [EnteAccreditamentoId]   INT                                                NOT NULL,
    [Codice]                 NVARCHAR (10)                                      NOT NULL,
    [Descrizione]            NVARCHAR (200)                                     NOT NULL,
    [DescrizioneEstesa]      NVARCHAR (500)                                     NULL,
    [ResponsabileEmail]      NVARCHAR (200)                                     NULL,
    [Ordine]                 INT                                                DEFAULT ((0)) NOT NULL,
    [Attivo]                 BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]          DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]               INT                                                NULL,
    [DataModifica]           DATETIME2 (7)                                      NULL,
    [ModificatoDa]           INT                                                NULL,
    [DataCancellazione]      DATETIME2 (7)                                      NULL,
    [CancellatoDa]           INT                                                NULL,
    [UniqueRowId]            UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]     DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_DipartimentoAccredia] PRIMARY KEY CLUSTERED ([DipartimentoAccrediaId] ASC),
    CONSTRAINT [FK_DipartimentoAccredia_EnteAccreditamento] FOREIGN KEY ([EnteAccreditamentoId]) REFERENCES [Accreditamento].[EnteAccreditamento] ([EnteAccreditamentoId]),
    CONSTRAINT [UQ_DipartimentoAccredia_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Tipologica].[DipartimentoAccrediaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

