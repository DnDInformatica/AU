CREATE TABLE [Tipologica].[SettoreAccrediaStorico] (
    [SettoreAccrediaId]      INT              NOT NULL,
    [DipartimentoAccrediaId] INT              NOT NULL,
    [Codice]                 NVARCHAR (50)    NOT NULL,
    [Descrizione]            NVARCHAR (200)   NOT NULL,
    [DescrizioneEstesa]      NVARCHAR (500)   NULL,
    [Ordine]                 INT              NOT NULL,
    [Attivo]                 BIT              NOT NULL,
    [DataCreazione]          DATETIME2 (7)    NOT NULL,
    [CreatoDa]               INT              NULL,
    [DataModifica]           DATETIME2 (7)    NULL,
    [ModificatoDa]           INT              NULL,
    [DataCancellazione]      DATETIME2 (7)    NULL,
    [CancellatoDa]           INT              NULL,
    [UniqueRowId]            UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]     DATETIME2 (7)    NOT NULL,
    [DataFineValidita]       DATETIME2 (7)    NOT NULL,
    [ClassificazioneId]      INT              NULL
);


GO

CREATE CLUSTERED INDEX [ix_SettoreAccrediaStorico]
    ON [Tipologica].[SettoreAccrediaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

