CREATE TABLE [Processi].[DeliberaStorico] (
    [DeliberaId]         INT              NOT NULL,
    [PraticaId]          INT              NOT NULL,
    [EventoId]           INT              NULL,
    [DocumentoId]        INT              NULL,
    [NumeroDelibera]     NVARCHAR (100)   NULL,
    [DataDelibera]       DATETIME2 (7)    NOT NULL,
    [TestoSintesi]       NVARCHAR (MAX)   NULL,
    [DataCreazione]      DATETIME2 (7)    NOT NULL,
    [CreatoDa]           INT              NULL,
    [DataModifica]       DATETIME2 (7)    NULL,
    [ModificatoDa]       INT              NULL,
    [DataCancellazione]  DATETIME2 (7)    NULL,
    [CancellatoDa]       INT              NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita] DATETIME2 (7)    NOT NULL,
    [DataFineValidita]   DATETIME2 (7)    NOT NULL,
    [EsitoDeliberaId]    INT              NOT NULL,
    [StatoDeliberaId]    INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_DeliberaStorico]
    ON [Processi].[DeliberaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

