CREATE TABLE [Workflow].[WorkflowStepDefinizione] (
    [WorkflowStepDefinizioneId] INT                                                IDENTITY (1, 1) NOT NULL,
    [WorkflowDefinizioneId]     INT                                                NOT NULL,
    [CodiceStep]                NVARCHAR (100)                                     NOT NULL,
    [NomeStep]                  NVARCHAR (300)                                     NOT NULL,
    [OrdineStep]                INT                                                NOT NULL,
    [IsFinale]                  BIT                                                DEFAULT ((0)) NOT NULL,
    [TipoRuoloAccrediaId]       INT                                                NULL,
    [DataCreazione]             DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                  INT                                                NULL,
    [DataModifica]              DATETIME2 (7)                                      NULL,
    [ModificatoDa]              INT                                                NULL,
    [DataCancellazione]         DATETIME2 (7)                                      NULL,
    [CancellatoDa]              INT                                                NULL,
    [UniqueRowId]               UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]        DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]          DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_WorkflowStepDefinizione] PRIMARY KEY CLUSTERED ([WorkflowStepDefinizioneId] ASC),
    CONSTRAINT [CK_WorkflowStepDefinizione_Ordine] CHECK ([OrdineStep]>(0)),
    CONSTRAINT [FK_WorkflowStepDefinizione_TipoRuoloAccredia] FOREIGN KEY ([TipoRuoloAccrediaId]) REFERENCES [Tipologica].[TipoRuoloAccredia] ([TipoRuoloAccrediaId]),
    CONSTRAINT [FK_WorkflowStepDefinizione_WorkflowDefinizione] FOREIGN KEY ([WorkflowDefinizioneId]) REFERENCES [Workflow].[WorkflowDefinizione] ([WorkflowDefinizioneId]),
    CONSTRAINT [UQ_WorkflowStepDefinizione] UNIQUE NONCLUSTERED ([WorkflowDefinizioneId] ASC, [CodiceStep] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Workflow].[WorkflowStepDefinizioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'OrdineStep';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowStepDefinizione;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'CodiceStep';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'TipoRuoloAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'WorkflowDefinizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowStepDefinizione","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowStepDefinizione;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'WorkflowStepDefinizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowStepDefinizione;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowStepDefinizione;NotNull;PII', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'NomeStep';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'WorkflowDefinizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'TipoRuoloAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'WorkflowStepDefinizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowStepDefinizione","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowStepDefinizione","column":"OrdineStep","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'OrdineStep';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'NomeStep';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowStepDefinizione;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'IsFinale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowStepDefinizione","column":"WorkflowDefinizioneId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Workflow.WorkflowDefinizione.WorkflowDefinizioneId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'WorkflowDefinizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'NomeStep';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowStepDefinizione;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'OrdineStep';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'CodiceStep';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Flag booleano da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'IsFinale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowStepDefinizione;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowStepDefinizione","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'WorkflowStepDefinizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'OrdineStep';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'CodiceStep';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowStepDefinizione","column":"IsFinale","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'IsFinale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowStepDefinizione;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'WorkflowDefinizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'TipoRuoloAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowStepDefinizione;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Step ordinati associati a una definizione workflow.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowStepDefinizione","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowStepDefinizione","column":"CodiceStep","data_type":"nvarchar","max_length":200,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'CodiceStep';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowStepDefinizione;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'IsFinale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'TipoRuoloAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'WorkflowDefinizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'WorkflowStepDefinizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'OrdineStep';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'NomeStep';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowStepDefinizione","column":"TipoRuoloId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.TipoRuolo.TipoRuoloId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'TipoRuoloAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'WorkflowDefinizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowStepDefinizione;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowStepDefinizione","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'workflow;step;kernel', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'NomeStep';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'IsFinale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowStepDefinizione;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'CodiceStep';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowStepDefinizione;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'TipoRuoloAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'WorkflowStepDefinizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'OrdineStep';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowStepDefinizione","column":"NomeStep","data_type":"nvarchar","max_length":600,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"PII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'NomeStep';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'IsFinale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'CodiceStep';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowStepDefinizione;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowStepDefinizione","temporal":true,"temporal_type":2,"history_table":"Workflow.WorkflowStepDefinizioneStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowStepDefinizione","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowStepDefinizione","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowStepDefinizione","column":"WorkflowStepDefinizioneId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowStepDefinizione', @level2type = N'COLUMN', @level2name = N'WorkflowStepDefinizioneId';


GO

