CREATE TABLE [Workflow].[Notifica] (
    [NotificaId]            INT                                                IDENTITY (1, 1) NOT NULL,
    [OggettoId]             INT                                                NOT NULL,
    [TaskId]                INT                                                NULL,
    [DestinatarioPersonaId] INT                                                NULL,
    [Canale]                NVARCHAR (30)                                      DEFAULT ('EMAIL') NOT NULL,
    [OggettoMessaggio]      NVARCHAR (500)                                     NOT NULL,
    [CorpoMessaggio]        NVARCHAR (MAX)                                     NOT NULL,
    [DataProgrammata]       DATETIME2 (7)                                      NULL,
    [DataInvio]             DATETIME2 (7)                                      NULL,
    [ErroreInvio]           NVARCHAR (1000)                                    NULL,
    [DataCreazione]         DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]              INT                                                NULL,
    [DataModifica]          DATETIME2 (7)                                      NULL,
    [ModificatoDa]          INT                                                NULL,
    [DataCancellazione]     DATETIME2 (7)                                      NULL,
    [CancellatoDa]          INT                                                NULL,
    [UniqueRowId]           UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]    DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]      DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [StatoInvioNotificaId]  INT                                                NOT NULL,
    [TipoOggettoDominioId]  INT                                                NOT NULL,
    CONSTRAINT [PK_Notifica] PRIMARY KEY CLUSTERED ([NotificaId] ASC),
    CONSTRAINT [CK_Notifica_Canale_Enum] CHECK ([Canale]=N'SISTEMA' OR [Canale]=N'INTERNA' OR [Canale]=N'EMAIL'),
    CONSTRAINT [CK_Notifica_Date] CHECK ([DataInvio] IS NULL OR [DataProgrammata] IS NULL OR [DataInvio]>=[DataProgrammata]),
    CONSTRAINT [FK_Notifica_DestinatarioPersona] FOREIGN KEY ([DestinatarioPersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [FK_Notifica_StatoInvioNotifica] FOREIGN KEY ([StatoInvioNotificaId]) REFERENCES [Tipologica].[StatoInvioNotifica] ([StatoInvioNotificaId]),
    CONSTRAINT [FK_Notifica_Task] FOREIGN KEY ([TaskId]) REFERENCES [Workflow].[Task] ([TaskId]),
    CONSTRAINT [FK_Notifica_TipoOggettoDominio] FOREIGN KEY ([TipoOggettoDominioId]) REFERENCES [Tipologica].[TipoOggettoDominio] ([TipoOggettoDominioId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Workflow].[NotificaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_Notifica_TipoOggettoDominioId]
    ON [Workflow].[Notifica]([TipoOggettoDominioId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Notifica_StatoInvioNotificaId]
    ON [Workflow].[Notifica]([StatoInvioNotificaId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Notifica","column":"OggettoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Notifica;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'ErroreInvio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'CorpoMessaggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'workflow;notifica;kernel', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Notifiche applicative e di recapito associate agli oggetti.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Notifica;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'OggettoMessaggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'Canale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Data di business da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataProgrammata';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Notifica;Nullable', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataProgrammata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Notifica;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Data di business da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataInvio';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Notifica","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Notifica","column":"OggettoMessaggio","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'OggettoMessaggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DestinatarioPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'NotificaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataProgrammata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Notifica;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'CorpoMessaggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'OggettoMessaggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Notifica;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Notifica;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DestinatarioPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Notifica","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Notifica;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'NotificaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataProgrammata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Notifica","column":"CorpoMessaggio","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'CorpoMessaggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Notifica","column":"TaskId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Workflow.Task.TaskId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Notifica;Nullable', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataInvio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DestinatarioPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Permesso/abilitazione booleana da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'Canale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'ErroreInvio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Notifica","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Notifica","temporal":true,"temporal_type":2,"history_table":"Workflow.NotificaStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Notifica","column":"DataProgrammata","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataProgrammata';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'CorpoMessaggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataInvio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DestinatarioPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Notifica;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'Canale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'NotificaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Notifica","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Notifica;Nullable', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'ErroreInvio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'ErroreInvio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Notifica;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataProgrammata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Notifica;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Notifica","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'OggettoMessaggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Notifica","column":"DestinatarioPersonaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DestinatarioPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Notifica","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'Canale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataInvio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'NotificaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Notifica","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'ErroreInvio';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'CorpoMessaggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Notifica;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Notifica;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'OggettoMessaggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DestinatarioPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'Canale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Notifica","column":"NotificaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'NotificaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Notifica","column":"DataInvio","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataInvio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Notifica","column":"ErroreInvio","data_type":"nvarchar","max_length":2000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'ErroreInvio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Notifica;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'CorpoMessaggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:Notifica;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'NotificaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'OggettoMessaggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"Notifica","column":"Canale","data_type":"nvarchar","max_length":60,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'Canale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'Notifica', @level2type = N'COLUMN', @level2name = N'DataInvio';


GO

