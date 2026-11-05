CREATE TABLE [Tipologica].[StatoElementoFlessibileStorico] (
    [StatoElementoFlessibileId] TINYINT          NOT NULL,
    [Codice]                    NVARCHAR (40)    NOT NULL,
    [Descrizione]               NVARCHAR (400)   NOT NULL,
    [Attivo]                    BIT              NOT NULL,
    [UniqueRowId]               UNIQUEIDENTIFIER NOT NULL,
    [DataCreazione]             DATETIME2 (7)    NOT NULL,
    [CreatoDa]                  INT              NULL,
    [DataModifica]              DATETIME2 (7)    NULL,
    [ModificatoDa]              INT              NULL,
    [DataCancellazione]         DATETIME2 (7)    NULL,
    [CancellatoDa]              INT              NULL,
    [DataInizioValidita]        DATETIME2 (7)    NOT NULL,
    [DataFineValidita]          DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_StatoElementoFlessibileStorico]
    ON [Tipologica].[StatoElementoFlessibileStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

