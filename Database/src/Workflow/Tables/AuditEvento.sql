CREATE TABLE [Workflow].[AuditEvento] (
    [AuditEventoId]        INT                                                IDENTITY (1, 1) NOT NULL,
    [OggettoId]            INT                                                NOT NULL,
    [Azione]               NVARCHAR (100)                                     NOT NULL,
    [Descrizione]          NVARCHAR (1000)                                    NULL,
    [AutorePersonaId]      INT                                                NULL,
    [DataEvento]           DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [PayloadJson]          NVARCHAR (MAX)                                     NULL,
    [DataCreazione]        DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]             INT                                                NULL,
    [DataModifica]         DATETIME2 (7)                                      NULL,
    [ModificatoDa]         INT                                                NULL,
    [DataCancellazione]    DATETIME2 (7)                                      NULL,
    [CancellatoDa]         INT                                                NULL,
    [UniqueRowId]          UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]     DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [TipoOggettoDominioId] INT                                                NOT NULL,
    CONSTRAINT [PK_AuditEvento] PRIMARY KEY CLUSTERED ([AuditEventoId] ASC),
    CONSTRAINT [CK_AuditEvento_Azione_Enum] CHECK ([Azione]=N'ANNULLAMENTO' OR [Azione]=N'CANCELLAZIONE' OR [Azione]=N'ASSEGNAZIONE' OR [Azione]=N'CAMBIO_STATO' OR [Azione]=N'MODIFICA' OR [Azione]=N'CREAZIONE'),
    CONSTRAINT [FK_AuditEvento_AutorePersona] FOREIGN KEY ([AutorePersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [FK_AuditEvento_TipoOggettoDominio] FOREIGN KEY ([TipoOggettoDominioId]) REFERENCES [Tipologica].[TipoOggettoDominio] ([TipoOggettoDominioId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Workflow].[AuditEventoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_AuditEvento_TipoOggettoDominioId]
    ON [Workflow].[AuditEvento]([TipoOggettoDominioId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Payload strutturato in formato JSON associato all''evento.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'PayloadJson';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataEvento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"AuditEvento","column":"Descrizione","data_type":"nvarchar","max_length":2000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:AuditEvento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:AuditEvento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:AuditEvento;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'AuditEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:AuditEvento;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'AutorePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"AuditEvento","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"AuditEvento","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'AuditEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'AutorePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:AuditEvento;Nullable', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'PayloadJson';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'Azione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"AuditEvento","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'AutorePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'Azione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'PayloadJson';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'AuditEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:AuditEvento;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'Azione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'PayloadJson';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'AuditEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"AuditEvento","column":"PayloadJson","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'PayloadJson';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"AuditEvento","column":"AuditEventoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'AuditEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"AuditEvento","column":"AutorePersonaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'AutorePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'AutorePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'Azione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:AuditEvento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'AutorePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'Azione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Audit trail applicativo per eventi di business rilevanti.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:AuditEvento;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Data di business da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataEvento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"AuditEvento","column":"Azione","data_type":"nvarchar","max_length":200,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'Azione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'AuditEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"AuditEvento","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'PayloadJson';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:AuditEvento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:AuditEvento;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataEvento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"AuditEvento","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:AuditEvento;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione testuale da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'workflow;audit;kernel;compliance', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:AuditEvento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:AuditEvento;Nullable', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataEvento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"AuditEvento","temporal":true,"temporal_type":2,"history_table":"Workflow.AuditEventoStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"AuditEvento","column":"DataEvento","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataEvento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"AuditEvento","column":"OggettoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"AuditEvento","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataEvento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Workflow","table":"AuditEvento","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Workflow;Table:AuditEvento;NotNull', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'TABLE', @level1name = N'AuditEvento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

