CREATE TABLE [Eventi].[EventoPraticaStorico] (
    [EventoPraticaId]           INT              NOT NULL,
    [EventoId]                  INT              NOT NULL,
    [PraticaId]                 INT              NOT NULL,
    [PuntoOdGId]                INT              NULL,
    [NumeroOrdineTrattazione]   INT              NULL,
    [RelatorePersonaId]         INT              NULL,
    [Note]                      NVARCHAR (2000)  NULL,
    [DataCreazione]             DATETIME2 (7)    NOT NULL,
    [CreatoDa]                  INT              NULL,
    [DataModifica]              DATETIME2 (7)    NULL,
    [ModificatoDa]              INT              NULL,
    [DataCancellazione]         DATETIME2 (7)    NULL,
    [CancellatoDa]              INT              NULL,
    [UniqueRowId]               UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]        DATETIME2 (7)    NOT NULL,
    [DataFineValidita]          DATETIME2 (7)    NOT NULL,
    [EsitoDiscussionePraticaId] INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_EventoPraticaStorico]
    ON [Eventi].[EventoPraticaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

