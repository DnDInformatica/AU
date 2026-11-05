CREATE TABLE [Workflow].[TaskStorico] (
    [TaskId]                INT              NOT NULL,
    [WorkflowIstanzaId]     INT              NOT NULL,
    [Titolo]                NVARCHAR (500)   NOT NULL,
    [Descrizione]           NVARCHAR (MAX)   NULL,
    [AssegnatoAPersonaId]   INT              NULL,
    [TipoRuoloAccrediaId]   INT              NULL,
    [DataScadenza]          DATETIME2 (7)    NULL,
    [DataCompletamento]     DATETIME2 (7)    NULL,
    [DataCreazione]         DATETIME2 (7)    NOT NULL,
    [CreatoDa]              INT              NULL,
    [DataModifica]          DATETIME2 (7)    NULL,
    [ModificatoDa]          INT              NULL,
    [DataCancellazione]     DATETIME2 (7)    NULL,
    [CancellatoDa]          INT              NULL,
    [UniqueRowId]           UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]    DATETIME2 (7)    NOT NULL,
    [DataFineValidita]      DATETIME2 (7)    NOT NULL,
    [PrioritaLavorazioneId] INT              NOT NULL,
    [EsitoLavorazioneId]    INT              NULL,
    [StatoTaskId]           INT              NOT NULL,
    [TipoTaskId]            INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_TaskStorico]
    ON [Workflow].[TaskStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

