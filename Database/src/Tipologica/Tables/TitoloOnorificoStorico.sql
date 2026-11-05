CREATE TABLE [Tipologica].[TitoloOnorificoStorico] (
    [TitoloOnorificoId]  INT              NOT NULL,
    [Codice]             NVARCHAR (10)    NOT NULL,
    [Descrizione]        NVARCHAR (100)   NOT NULL,
    [TitoloMaschile]     NVARCHAR (50)    NULL,
    [TitoloFemminile]    NVARCHAR (50)    NULL,
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

CREATE CLUSTERED INDEX [ix_TitoloOnorificoStorico]
    ON [Tipologica].[TitoloOnorificoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

