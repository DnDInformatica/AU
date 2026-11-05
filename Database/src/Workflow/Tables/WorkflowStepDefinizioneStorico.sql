CREATE TABLE [Workflow].[WorkflowStepDefinizioneStorico] (
    [WorkflowStepDefinizioneId] INT              NOT NULL,
    [WorkflowDefinizioneId]     INT              NOT NULL,
    [CodiceStep]                NVARCHAR (100)   NOT NULL,
    [NomeStep]                  NVARCHAR (300)   NOT NULL,
    [OrdineStep]                INT              NOT NULL,
    [IsFinale]                  BIT              NOT NULL,
    [TipoRuoloAccrediaId]       INT              NULL,
    [DataCreazione]             DATETIME2 (7)    NOT NULL,
    [CreatoDa]                  INT              NULL,
    [DataModifica]              DATETIME2 (7)    NULL,
    [ModificatoDa]              INT              NULL,
    [DataCancellazione]         DATETIME2 (7)    NULL,
    [CancellatoDa]              INT              NULL,
    [UniqueRowId]               UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]        DATETIME2 (7)    NOT NULL,
    [DataFineValidita]          DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_WorkflowStepDefinizioneStorico]
    ON [Workflow].[WorkflowStepDefinizioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

