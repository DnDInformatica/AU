CREATE TABLE [Tipologica].[TipoContattoStorico] (
    [TipoContattoId]     INT              NOT NULL,
    [Descrizione]        NVARCHAR (100)   NOT NULL,
    [Codice]             NVARCHAR (20)    NOT NULL,
    [Categoria]          NVARCHAR (50)    NOT NULL,
    [FormatoValidazione] NVARCHAR (500)   NULL,
    [PrefissoValore]     NVARCHAR (20)    NULL,
    [IconaCss]           NVARCHAR (50)    NULL,
    [Ordine]             INT              NULL,
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

CREATE CLUSTERED INDEX [ix_TipoContattoStorico]
    ON [Tipologica].[TipoContattoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

