CREATE TABLE [Tipologica].[StatoDocumentoStorico] (
    [StatoDocumentoId]   INT              NOT NULL,
    [Codice]             NVARCHAR (50)    NOT NULL,
    [DescrizioneIta]     NVARCHAR (1000)  NOT NULL,
    [DescrizioneEng]     NVARCHAR (1000)  NULL,
    [Categoria]          NVARCHAR (30)    NOT NULL,
    [StatoFinale]        BIT              NOT NULL,
    [FonteNormativa]     NVARCHAR (500)   NULL,
    [Ordine]             INT              NULL,
    [Attivo]             BIT              NOT NULL,
    [DataCreazione]      DATETIME2 (7)    NOT NULL,
    [CreatoDa]           INT              NULL,
    [DataModifica]       DATETIME2 (7)    NULL,
    [ModificatoDa]       INT              NULL,
    [DataCancellazione]  DATETIME2 (7)    NULL,
    [CancellatoDa]       INT              NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita] DATETIME2 (7)    NOT NULL,
    [DataFineValidita]   DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_StatoDocumentoStorico]
    ON [Tipologica].[StatoDocumentoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

