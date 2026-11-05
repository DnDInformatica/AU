CREATE TABLE [Workflow].[WorkflowIstanza] (
    [WorkflowIstanzaId]                 INT                                                IDENTITY (1, 1) NOT NULL,
    [WorkflowDefinizioneId]             INT                                                NOT NULL,
    [OggettoId]                         INT                                                NOT NULL,
    [WorkflowStepDefinizioneCorrenteId] INT                                                NULL,
    [DataApertura]                      DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [DataChiusura]                      DATETIME2 (7)                                      NULL,
    [AvviatoDaPersonaId]                INT                                                NULL,
    [DataCreazione]                     DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                          INT                                                NULL,
    [DataModifica]                      DATETIME2 (7)                                      NULL,
    [ModificatoDa]                      INT                                                NULL,
    [DataCancellazione]                 DATETIME2 (7)                                      NULL,
    [CancellatoDa]                      INT                                                NULL,
    [UniqueRowId]                       UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]                  DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [StatoIstanzaWorkflowId]            INT                                                NOT NULL,
    [TipoOggettoDominioId]              INT                                                NOT NULL,
    CONSTRAINT [PK_WorkflowIstanza] PRIMARY KEY CLUSTERED ([WorkflowIstanzaId] ASC),
    CONSTRAINT [CK_WorkflowIstanza_Date] CHECK ([DataChiusura] IS NULL OR [DataChiusura]>=[DataApertura]),
    CONSTRAINT [FK_WorkflowIstanza_AvviatoDaPersona] FOREIGN KEY ([AvviatoDaPersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [FK_WorkflowIstanza_StatoIstanzaWorkflow] FOREIGN KEY ([StatoIstanzaWorkflowId]) REFERENCES [Tipologica].[StatoIstanzaWorkflow] ([StatoIstanzaWorkflowId]),
    CONSTRAINT [FK_WorkflowIstanza_TipoOggettoDominio] FOREIGN KEY ([TipoOggettoDominioId]) REFERENCES [Tipologica].[TipoOggettoDominio] ([TipoOggettoDominioId]),
    CONSTRAINT [FK_WorkflowIstanza_WorkflowDefinizione] FOREIGN KEY ([WorkflowDefinizioneId]) REFERENCES [Workflow].[WorkflowDefinizione] ([WorkflowDefinizioneId]),
    CONSTRAINT [FK_WorkflowIstanza_WorkflowStepCorrente] FOREIGN KEY ([WorkflowStepDefinizioneCorrenteId]) REFERENCES [Workflow].[WorkflowStepDefinizione] ([WorkflowStepDefinizioneId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Workflow].[WorkflowIstanzaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_WorkflowIstanza_TipoOggettoDominioId]
    ON [Workflow].[WorkflowIstanza]([TipoOggettoDominioId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_WorkflowIstanza_StatoIstanzaWorkflowId]
    ON [Workflow].[WorkflowIstanza]([StatoIstanzaWorkflowId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'WorkflowDefinizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowIstanza","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'workflow;istanza;kernel', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowIstanza;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'WorkflowStepDefinizioneCorrenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowIstanza;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'WorkflowStepDefinizioneCorrenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataApertura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataChiusura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowIstanza;Nullable', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataChiusura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'AvviatoDaPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowIstanza;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'WorkflowDefinizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowIstanza;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowIstanza","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowIstanza;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowIstanza","column":"WorkflowIstanzaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowIstanza","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'WorkflowStepDefinizioneCorrenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowIstanza","column":"DataApertura","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataApertura';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Data di business da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataApertura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataChiusura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowIstanza","column":"AvviatoDaPersonaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'AvviatoDaPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'AvviatoDaPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'WorkflowDefinizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowIstanza","column":"OggettoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowIstanza;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowIstanza;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowIstanza","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowIstanza;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowIstanza;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'WorkflowStepDefinizioneCorrenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataApertura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowIstanza;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataApertura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataChiusura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'AvviatoDaPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'WorkflowDefinizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowIstanza;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'AvviatoDaPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowIstanza","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowIstanza;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istanze operative dei workflow su oggetti applicativi.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:WorkflowIstanza;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowIstanza","temporal":true,"temporal_type":2,"history_table":"Workflow.WorkflowIstanzaStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowIstanza","column":"WorkflowStepDefinizioneCorrenteId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Workflow.WorkflowStepDefinizione.WorkflowStepDefinizioneId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'WorkflowStepDefinizioneCorrenteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'WorkflowStepDefinizioneCorrenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataApertura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowIstanza","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowIstanza","column":"DataChiusura","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataChiusura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowIstanza","column":"WorkflowDefinizioneId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Workflow.WorkflowDefinizione.WorkflowDefinizioneId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'WorkflowDefinizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Data di business da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataChiusura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'AvviatoDaPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"WorkflowIstanza","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'WorkflowDefinizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'WorkflowIstanza', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

