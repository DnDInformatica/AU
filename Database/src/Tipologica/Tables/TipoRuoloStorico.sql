CREATE TABLE [Tipologica].[TipoRuoloStorico] (
    [TipoRuoloId]                INT              NOT NULL,
    [Codice]                     NVARCHAR (30)    NOT NULL,
    [Descrizione]                NVARCHAR (200)   NOT NULL,
    [Categoria]                  NVARCHAR (30)    NOT NULL,
    [CategoriaAccredia]          NVARCHAR (30)    NULL,
    [RequisitiMinimi]            NVARCHAR (500)   NULL,
    [FonteNormativa]             NVARCHAR (200)   NULL,
    [RichiedeIscrizioneAlbo]     BIT              NOT NULL,
    [AlboRiferimento]            NVARCHAR (100)   NULL,
    [LimiteMaxPerOrganizzazione] INT              NULL,
    [LimiteMaxPerUO]             INT              NULL,
    [Ordine]                     INT              NULL,
    [Attivo]                     BIT              NOT NULL,
    [DataCreazione]              DATETIME2 (7)    NOT NULL,
    [CreatoDa]                   INT              NULL,
    [DataModifica]               DATETIME2 (7)    NULL,
    [ModificatoDa]               INT              NULL,
    [DataCancellazione]          DATETIME2 (7)    NULL,
    [CancellatoDa]               INT              NULL,
    [UniqueRowId]                UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]         DATETIME2 (7)    NOT NULL,
    [DataFineValidita]           DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_TipoRuoloStorico]
    ON [Tipologica].[TipoRuoloStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

