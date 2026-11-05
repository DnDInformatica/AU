CREATE TABLE [Standard].[NACERevisioneStorico] (
    [NaceRevisioneId]    INT              NOT NULL,
    [CodiceRevisione]    NVARCHAR (20)    NOT NULL,
    [Denominazione]      NVARCHAR (200)   NOT NULL,
    [DataPubblicazione]  DATE             NOT NULL,
    [DataDecorrenza]     DATE             NOT NULL,
    [DataCessazione]     DATE             NULL,
    [Ente]               NVARCHAR (100)   NOT NULL,
    [UrlRiferimento]     NVARCHAR (500)   NULL,
    [Note]               NVARCHAR (1000)  NULL,
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

CREATE CLUSTERED INDEX [ix_NACERevisioneStorico]
    ON [Standard].[NACERevisioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

