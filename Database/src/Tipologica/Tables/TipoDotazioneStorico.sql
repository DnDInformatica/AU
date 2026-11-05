CREATE TABLE [Tipologica].[TipoDotazioneStorico] (
    [TipoDotazioneId]          INT              NOT NULL,
    [Codice]                   NVARCHAR (30)    NOT NULL,
    [Descrizione]              NVARCHAR (100)   NOT NULL,
    [DescrizioneEstesa]        NVARCHAR (500)   NULL,
    [Categoria]                NVARCHAR (30)    NOT NULL,
    [RichiedeNumeroInventario] BIT              NOT NULL,
    [RichiedeRestituzione]     BIT              NOT NULL,
    [Icona]                    NVARCHAR (50)    NULL,
    [Ordine]                   INT              NOT NULL,
    [Attivo]                   BIT              NOT NULL,
    [DataCreazione]            DATETIME2 (7)    NOT NULL,
    [CreatoDa]                 INT              NULL,
    [DataModifica]             DATETIME2 (7)    NULL,
    [ModificatoDa]             INT              NULL,
    [DataCancellazione]        DATETIME2 (7)    NULL,
    [CancellatoDa]             INT              NULL,
    [UniqueRowId]              UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]       DATETIME2 (7)    NOT NULL,
    [DataFineValidita]         DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_TipoDotazioneStorico]
    ON [Tipologica].[TipoDotazioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

