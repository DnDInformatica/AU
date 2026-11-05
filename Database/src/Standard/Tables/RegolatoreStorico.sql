CREATE TABLE [Standard].[RegolatoreStorico] (
    [RegolatoreId]       INT              NOT NULL,
    [OrganizzazioneId]   INT              NULL,
    [Codice]             NVARCHAR (50)    NOT NULL,
    [Denominazione]      NVARCHAR (400)   NOT NULL,
    [TipoRegolatore]     NVARCHAR (40)    NOT NULL,
    [Giurisdizione]      NVARCHAR (100)   NULL,
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

CREATE CLUSTERED INDEX [ix_RegolatoreStorico]
    ON [Standard].[RegolatoreStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

