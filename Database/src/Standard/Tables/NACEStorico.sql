CREATE TABLE [Standard].[NACEStorico] (
    [NaceId]                    INT              NOT NULL,
    [Codice]                    NVARCHAR (10)    NOT NULL,
    [Livello]                   TINYINT          NOT NULL,
    [DescrizioneIta]            NVARCHAR (500)   NOT NULL,
    [DescrizioneEng]            NVARCHAR (500)   NULL,
    [NacePadreId]               INT              NULL,
    [Attivo]                    BIT              NOT NULL,
    [DataCreazione]             DATETIME2 (7)    NOT NULL,
    [CreatoDa]                  INT              NULL,
    [DataModifica]              DATETIME2 (7)    NULL,
    [ModificatoDa]              INT              NULL,
    [DataCancellazione]         DATETIME2 (7)    NULL,
    [CancellatoDa]              INT              NULL,
    [UniqueRowId]               UNIQUEIDENTIFIER NOT NULL,
    [NaceRevisioneId]           INT              NOT NULL,
    [ClassificazioneVersioneId] INT              NULL,
    [DataInizioValidita]        DATETIME2 (7)    NOT NULL,
    [DataFineValidita]          DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_NACEStorico]
    ON [Standard].[NACEStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

