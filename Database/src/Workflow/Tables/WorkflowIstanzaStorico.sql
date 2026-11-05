CREATE TABLE [Workflow].[WorkflowIstanzaStorico] (
    [WorkflowIstanzaId]                 INT              NOT NULL,
    [WorkflowDefinizioneId]             INT              NOT NULL,
    [OggettoId]                         INT              NOT NULL,
    [WorkflowStepDefinizioneCorrenteId] INT              NULL,
    [DataApertura]                      DATETIME2 (7)    NOT NULL,
    [DataChiusura]                      DATETIME2 (7)    NULL,
    [AvviatoDaPersonaId]                INT              NULL,
    [DataCreazione]                     DATETIME2 (7)    NOT NULL,
    [CreatoDa]                          INT              NULL,
    [DataModifica]                      DATETIME2 (7)    NULL,
    [ModificatoDa]                      INT              NULL,
    [DataCancellazione]                 DATETIME2 (7)    NULL,
    [CancellatoDa]                      INT              NULL,
    [UniqueRowId]                       UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                  DATETIME2 (7)    NOT NULL,
    [StatoIstanzaWorkflowId]            INT              NOT NULL,
    [TipoOggettoDominioId]              INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_WorkflowIstanzaStorico]
    ON [Workflow].[WorkflowIstanzaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

