CREATE TABLE [Eventi].[VerbaleStorico] (
    [VerbaleId]          INT              NOT NULL,
    [EventoId]           INT              NOT NULL,
    [DocumentoId]        INT              NOT NULL,
    [DataRedazione]      DATETIME2 (7)    NOT NULL,
    [DataApprovazione]   DATETIME2 (7)    NULL,
    [Sintesi]            NVARCHAR (MAX)   NULL,
    [DataCreazione]      DATETIME2 (7)    NOT NULL,
    [CreatoDa]           INT              NULL,
    [DataModifica]       DATETIME2 (7)    NULL,
    [ModificatoDa]       INT              NULL,
    [DataCancellazione]  DATETIME2 (7)    NULL,
    [CancellatoDa]       INT              NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita] DATETIME2 (7)    NOT NULL,
    [DataFineValidita]   DATETIME2 (7)    NOT NULL,
    [StatoVerbaleId]     INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_VerbaleStorico]
    ON [Eventi].[VerbaleStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

