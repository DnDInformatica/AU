CREATE TABLE [Workflow].[WorkflowDefinizioneStorico] (
    [WorkflowDefinizioneId] INT              NOT NULL,
    [Codice]                NVARCHAR (100)   NOT NULL,
    [Nome]                  NVARCHAR (300)   NOT NULL,
    [Descrizione]           NVARCHAR (MAX)   NULL,
    [Attivo]                BIT              NOT NULL,
    [DataCreazione]         DATETIME2 (7)    NOT NULL,
    [CreatoDa]              INT              NULL,
    [DataModifica]          DATETIME2 (7)    NULL,
    [ModificatoDa]          INT              NULL,
    [DataCancellazione]     DATETIME2 (7)    NULL,
    [CancellatoDa]          INT              NULL,
    [UniqueRowId]           UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]    DATETIME2 (7)    NOT NULL,
    [DataFineValidita]      DATETIME2 (7)    NOT NULL,
    [TipoOggettoDominioId]  INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_WorkflowDefinizioneStorico]
    ON [Workflow].[WorkflowDefinizioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

