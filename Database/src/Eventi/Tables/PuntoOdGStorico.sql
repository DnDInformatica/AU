CREATE TABLE [Eventi].[PuntoOdGStorico] (
    [PuntoOdGId]         INT              NOT NULL,
    [EventoId]           INT              NOT NULL,
    [NumeroOrdine]       INT              NOT NULL,
    [Titolo]             NVARCHAR (1000)  NOT NULL,
    [Descrizione]        NVARCHAR (MAX)   NULL,
    [DataCreazione]      DATETIME2 (7)    NOT NULL,
    [CreatoDa]           INT              NULL,
    [DataModifica]       DATETIME2 (7)    NULL,
    [ModificatoDa]       INT              NULL,
    [DataCancellazione]  DATETIME2 (7)    NULL,
    [CancellatoDa]       INT              NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita] DATETIME2 (7)    NOT NULL,
    [DataFineValidita]   DATETIME2 (7)    NOT NULL,
    [StatoPuntoOdGId]    INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_PuntoOdGStorico]
    ON [Eventi].[PuntoOdGStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

