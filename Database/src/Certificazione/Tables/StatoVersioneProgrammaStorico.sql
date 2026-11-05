CREATE TABLE [Certificazione].[StatoVersioneProgrammaStorico] (
    [StatoVersioneProgrammaId] INT              NOT NULL,
    [Codice]                   VARCHAR (30)     NOT NULL,
    [Descrizione]              NVARCHAR (400)   NOT NULL,
    [Attivo]                   BIT              NOT NULL,
    [DataCreazione]            DATETIME2 (7)    NOT NULL,
    [CreatoDa]                 INT              NULL,
    [DataModifica]             DATETIME2 (7)    NULL,
    [ModificatoDa]             INT              NULL,
    [DataCancellazione]        DATETIME2 (7)    NULL,
    [CancellatoDa]             INT              NULL,
    [UniqueRowId]              UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]       DATETIME2 (7)    NOT NULL,
    [DataFineValidita]         DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_StatoVersioneProgrammaStorico]
    ON [Certificazione].[StatoVersioneProgrammaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

