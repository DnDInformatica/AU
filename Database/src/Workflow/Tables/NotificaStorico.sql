CREATE TABLE [Workflow].[NotificaStorico] (
    [NotificaId]            INT              NOT NULL,
    [OggettoId]             INT              NOT NULL,
    [TaskId]                INT              NULL,
    [DestinatarioPersonaId] INT              NULL,
    [Canale]                NVARCHAR (30)    NOT NULL,
    [OggettoMessaggio]      NVARCHAR (500)   NOT NULL,
    [CorpoMessaggio]        NVARCHAR (MAX)   NOT NULL,
    [DataProgrammata]       DATETIME2 (7)    NULL,
    [DataInvio]             DATETIME2 (7)    NULL,
    [ErroreInvio]           NVARCHAR (1000)  NULL,
    [DataCreazione]         DATETIME2 (7)    NOT NULL,
    [CreatoDa]              INT              NULL,
    [DataModifica]          DATETIME2 (7)    NULL,
    [ModificatoDa]          INT              NULL,
    [DataCancellazione]     DATETIME2 (7)    NULL,
    [CancellatoDa]          INT              NULL,
    [UniqueRowId]           UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]    DATETIME2 (7)    NOT NULL,
    [DataFineValidita]      DATETIME2 (7)    NOT NULL,
    [StatoInvioNotificaId]  INT              NOT NULL,
    [TipoOggettoDominioId]  INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_NotificaStorico]
    ON [Workflow].[NotificaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

