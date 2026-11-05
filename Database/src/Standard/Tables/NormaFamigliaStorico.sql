CREATE TABLE [Standard].[NormaFamigliaStorico] (
    [NormaFamigliaId]    INT              NOT NULL,
    [CodiceFamiglia]     NVARCHAR (100)   NOT NULL,
    [NumeroFamiglia]     NVARCHAR (50)    NOT NULL,
    [DesignazioneBase]   NVARCHAR (200)   NOT NULL,
    [TitoloBaseIta]      NVARCHAR (1000)  NULL,
    [TitoloBaseEng]      NVARCHAR (1000)  NULL,
    [TipoAggregazione]   VARCHAR (30)     NOT NULL,
    [Descrizione]        NVARCHAR (2000)  NULL,
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

CREATE CLUSTERED INDEX [ix_NormaFamigliaStorico]
    ON [Standard].[NormaFamigliaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

