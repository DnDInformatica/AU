CREATE TABLE [Standard].[DominioSemanticoStorico] (
    [DominioSemanticoId] INT              NOT NULL,
    [Codice]             NVARCHAR (120)   NOT NULL,
    [Denominazione]      NVARCHAR (400)   NOT NULL,
    [Descrizione]        NVARCHAR (2000)  NULL,
    [IndiceOrdinamento]  INT              NULL,
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

CREATE CLUSTERED INDEX [ix_DominioSemanticoStorico]
    ON [Standard].[DominioSemanticoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

