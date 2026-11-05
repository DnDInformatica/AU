CREATE TABLE [Tipologica].[FasciaLivelloDigCompStorico] (
    [FasciaLivelloDigCompId] INT              NOT NULL,
    [ScalaLivelloDigCompId]  INT              NOT NULL,
    [Codice]                 NVARCHAR (40)    NOT NULL,
    [Descrizione]            NVARCHAR (400)   NOT NULL,
    [DescrizioneEng]         NVARCHAR (400)   NULL,
    [Ordine]                 INT              NULL,
    [Attivo]                 BIT              NOT NULL,
    [DataCreazione]          DATETIME2 (7)    NOT NULL,
    [CreatoDa]               INT              NULL,
    [DataModifica]           DATETIME2 (7)    NULL,
    [ModificatoDa]           INT              NULL,
    [DataCancellazione]      DATETIME2 (7)    NULL,
    [CancellatoDa]           INT              NULL,
    [UniqueRowId]            UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]     DATETIME2 (7)    NOT NULL,
    [DataFineValidita]       DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_FasciaLivelloDigCompStorico]
    ON [Tipologica].[FasciaLivelloDigCompStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

