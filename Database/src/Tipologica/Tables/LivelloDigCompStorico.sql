CREATE TABLE [Tipologica].[LivelloDigCompStorico] (
    [LivelloDigCompId]       TINYINT          NOT NULL,
    [Fascia]                 NVARCHAR (30)    NOT NULL,
    [DescrizioneIta]         NVARCHAR (100)   NOT NULL,
    [DescrizioneEng]         NVARCHAR (100)   NOT NULL,
    [ValoriSiacAttesi]       NVARCHAR (500)   NULL,
    [Attivo]                 BIT              NOT NULL,
    [DataCreazione]          DATETIME2 (7)    NOT NULL,
    [CreatoDa]               INT              NULL,
    [DataModifica]           DATETIME2 (7)    NULL,
    [ModificatoDa]           INT              NULL,
    [DataCancellazione]      DATETIME2 (7)    NULL,
    [CancellatoDa]           INT              NULL,
    [UniqueRowId]            UNIQUEIDENTIFIER NOT NULL,
    [TipoScala]              NVARCHAR (20)    NOT NULL,
    [DataInizioValidita]     DATETIME2 (7)    NOT NULL,
    [DataFineValidita]       DATETIME2 (7)    NOT NULL,
    [ScalaLivelloDigCompId]  INT              NOT NULL,
    [FasciaLivelloDigCompId] INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_LivelloDigCompStorico]
    ON [Tipologica].[LivelloDigCompStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

