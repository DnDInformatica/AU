CREATE TABLE [Accreditamento].[EnteAccreditamentoRete] (
    [EnteAccreditamentoReteId] INT                                                IDENTITY (1, 1) NOT NULL,
    [EnteAccreditamentoId]     INT                                                NOT NULL,
    [TipoRete]                 NVARCHAR (20)                                      NOT NULL,
    [TipoMembership]           NVARCHAR (30)                                      NOT NULL,
    [DataAdesione]             DATE                                               NOT NULL,
    [DataCessazione]           DATE                                               NULL,
    [DataCreazione]            DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                 INT                                                NULL,
    [DataModifica]             DATETIME2 (7)                                      NULL,
    [ModificatoDa]             INT                                                NULL,
    [DataCancellazione]        DATETIME2 (7)                                      NULL,
    [CancellatoDa]             INT                                                NULL,
    [UniqueRowId]              UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]         DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_EnteAccreditamentoRete] PRIMARY KEY CLUSTERED ([EnteAccreditamentoReteId] ASC),
    CONSTRAINT [CK_EnteAccreditamentoRete_Date] CHECK ([DataCessazione] IS NULL OR [DataCessazione]>[DataAdesione]),
    CONSTRAINT [CK_EnteAccreditamentoRete_Memb] CHECK ([TipoMembership]='OSSERVATORE' OR [TipoMembership]='MEMBRO_ASSOCIATO' OR [TipoMembership]='MEMBRO_FULL'),
    CONSTRAINT [CK_EnteAccreditamentoRete_Rete] CHECK ([TipoRete]='GLOBAC' OR [TipoRete]='ILAC' OR [TipoRete]='IAF' OR [TipoRete]='EA'),
    CONSTRAINT [FK_EnteAccreditamentoRete_EA] FOREIGN KEY ([EnteAccreditamentoId]) REFERENCES [Accreditamento].[EnteAccreditamento] ([EnteAccreditamentoId]),
    CONSTRAINT [UQ_EnteAccreditamentoRete_EA_Rt] UNIQUE NONCLUSTERED ([EnteAccreditamentoId] ASC, [TipoRete] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Accreditamento].[EnteAccreditamentoReteStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:EnteAccreditamentoRete;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:EnteAccreditamentoRete;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'TipoMembership';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:EnteAccreditamentoRete;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:EnteAccreditamentoRete;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:EnteAccreditamentoRete;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'TipoRete';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:EnteAccreditamentoRete;Nullable', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoReteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:EnteAccreditamentoRete;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataAdesione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:EnteAccreditamentoRete;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data rilevante per il processo di accreditamento.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataAdesione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoReteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data rilevante per il processo di accreditamento.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:EnteAccreditamentoRete;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'TipoRete';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ASSOCIAZIONE', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo di dominio TipoRete.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'TipoRete';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:EnteAccreditamentoRete;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoReteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record (GUID tecnico).', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo di dominio TipoMembership.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'TipoMembership';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:EnteAccreditamentoRete;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'TipoMembership';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"EnteAccreditamentoRete","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"EnteAccreditamentoRete","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataAdesione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Accreditamento.EnteAccreditamento.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"EnteAccreditamentoRete","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"EnteAccreditamentoRete","column":"DataAdesione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataAdesione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tabella dominio Accreditamento con gestione audit, soft-delete e system-versioning dove previsto.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"EnteAccreditamentoRete","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"EnteAccreditamentoRete","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco del record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoReteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"EnteAccreditamentoRete","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"EnteAccreditamentoRete","column":"DataCessazione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'TipoRete';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"EnteAccreditamentoRete","column":"TipoRete","data_type":"nvarchar","max_length":40,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'TipoRete';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataAdesione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"EnteAccreditamentoRete","column":"TipoMembership","data_type":"nvarchar","max_length":60,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'TipoMembership';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"EnteAccreditamentoRete","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'TipoRete';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoReteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'TipoMembership';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"EnteAccreditamentoRete","column":"EnteAccreditamentoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Accreditamento.EnteAccreditamento.EnteAccreditamentoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'TipoMembership';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:EnteAccreditamentoRete;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:EnteAccreditamentoRete;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"EnteAccreditamentoRete","temporal":true,"temporal_type":2,"history_table":"Accreditamento.EnteAccreditamentoReteStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataAdesione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"EnteAccreditamentoRete","column":"EnteAccreditamentoReteId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'EnteAccreditamentoRete', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoReteId';


GO

