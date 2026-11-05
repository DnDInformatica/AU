CREATE TABLE [Eventi].[PuntoOdGRelatoreStorico] (
    [PuntoOdGRelatoreId] INT              NOT NULL,
    [PuntoOdGId]         INT              NOT NULL,
    [PersonaId]          INT              NOT NULL,
    [DataDesignazione]   DATE             NULL,
    [Note]               NVARCHAR (2000)  NULL,
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

CREATE CLUSTERED INDEX [ix_PuntoOdGRelatoreStorico]
    ON [Eventi].[PuntoOdGRelatoreStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

