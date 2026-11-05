CREATE TABLE [Workflow].[Task] (
    [TaskId]                INT                                                IDENTITY (1, 1) NOT NULL,
    [WorkflowIstanzaId]     INT                                                NOT NULL,
    [Titolo]                NVARCHAR (500)                                     NOT NULL,
    [Descrizione]           NVARCHAR (MAX)                                     NULL,
    [AssegnatoAPersonaId]   INT                                                NULL,
    [TipoRuoloAccrediaId]   INT                                                NULL,
    [DataScadenza]          DATETIME2 (7)                                      NULL,
    [DataCompletamento]     DATETIME2 (7)                                      NULL,
    [DataCreazione]         DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]              INT                                                NULL,
    [DataModifica]          DATETIME2 (7)                                      NULL,
    [ModificatoDa]          INT                                                NULL,
    [DataCancellazione]     DATETIME2 (7)                                      NULL,
    [CancellatoDa]          INT                                                NULL,
    [UniqueRowId]           UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]    DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]      DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [PrioritaLavorazioneId] INT                                                NOT NULL,
    [EsitoLavorazioneId]    INT                                                NULL,
    [StatoTaskId]           INT                                                NOT NULL,
    [TipoTaskId]            INT                                                NOT NULL,
    CONSTRAINT [PK_Task] PRIMARY KEY CLUSTERED ([TaskId] ASC),
    CONSTRAINT [CK_Task_Date] CHECK ([DataCompletamento] IS NULL OR [DataScadenza] IS NULL OR [DataCompletamento]>=[DataScadenza]),
    CONSTRAINT [FK_Task_AssegnatoAPersona] FOREIGN KEY ([AssegnatoAPersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [FK_Task_EsitoLavorazione] FOREIGN KEY ([EsitoLavorazioneId]) REFERENCES [Tipologica].[EsitoLavorazione] ([EsitoLavorazioneId]),
    CONSTRAINT [FK_Task_PrioritaLavorazione] FOREIGN KEY ([PrioritaLavorazioneId]) REFERENCES [Tipologica].[PrioritaLavorazione] ([PrioritaLavorazioneId]),
    CONSTRAINT [FK_Task_StatoTask] FOREIGN KEY ([StatoTaskId]) REFERENCES [Tipologica].[StatoTask] ([StatoTaskId]),
    CONSTRAINT [FK_Task_TipoRuoloAccredia] FOREIGN KEY ([TipoRuoloAccrediaId]) REFERENCES [Tipologica].[TipoRuoloAccredia] ([TipoRuoloAccrediaId]),
    CONSTRAINT [FK_Task_TipoTask] FOREIGN KEY ([TipoTaskId]) REFERENCES [Tipologica].[TipoTask] ([TipoTaskId]),
    CONSTRAINT [FK_Task_WorkflowIstanza] FOREIGN KEY ([WorkflowIstanzaId]) REFERENCES [Workflow].[WorkflowIstanza] ([WorkflowIstanzaId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Workflow].[TaskStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_Task_TipoTaskId]
    ON [Workflow].[Task]([TipoTaskId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Task_PrioritaLavorazioneId]
    ON [Workflow].[Task]([PrioritaLavorazioneId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Task_EsitoLavorazioneId]
    ON [Workflow].[Task]([EsitoLavorazioneId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Task_StatoTaskId]
    ON [Workflow].[Task]([StatoTaskId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Task;Nullable', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Task operativi generati dai workflow.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'AssegnatoAPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione testuale da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Task;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Titolo descrittivo da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'TipoRuoloAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Task","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Task","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Task;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'TipoRuoloAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'workflow;task;kernel', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Task;Nullable', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Task","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Task;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'AssegnatoAPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Task;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Task;Nullable', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Task;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Task;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Task;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Task;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'TipoRuoloAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'AssegnatoAPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Task","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'AssegnatoAPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Task","column":"DataCompletamento","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Task;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Task","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'TipoRuoloAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Task","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Task","column":"TipoRuoloId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.TipoRuolo.TipoRuoloId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'TipoRuoloAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Task","column":"DataScadenza","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Task","column":"TaskId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Task;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Task","column":"AssegnatoAPersonaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'AssegnatoAPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Task","column":"WorkflowIstanzaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Workflow.WorkflowIstanza.WorkflowIstanzaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Task","column":"Descrizione","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Task","column":"Titolo","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'AssegnatoAPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Data di business da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Task;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Task","temporal":true,"temporal_type":2,"history_table":"Workflow.TaskStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Task;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Task","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Data di business da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'TipoRuoloAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

