CREATE TABLE [Standard].[NormaEdizioneDipartimentoStorico] (
    [NormaEdizioneDipartimentoId] INT              NOT NULL,
    [NormaEdizioneId]             INT              NOT NULL,
    [DipartimentoAccrediaId]      INT              NOT NULL,
    [Note]                        NVARCHAR (500)   NULL,
    [Attivo]                      BIT              NOT NULL,
    [DataCreazione]               DATETIME2 (7)    NOT NULL,
    [CreatoDa]                    INT              NULL,
    [DataModifica]                DATETIME2 (7)    NULL,
    [ModificatoDa]                INT              NULL,
    [DataCancellazione]           DATETIME2 (7)    NULL,
    [CancellatoDa]                INT              NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER NOT NULL,
    [SettoreAccrediaId]           INT              NOT NULL,
    [DataInizioValidita]          DATETIME2 (7)    NOT NULL,
    [DataFineValidita]            DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_NormaEdizioneDipartimentoStorico]
    ON [Standard].[NormaEdizioneDipartimentoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

