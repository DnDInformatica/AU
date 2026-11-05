CREATE TABLE [Accreditamento].[PraticaAltroSchemaSQ] (
    [PraticaAltroSchemaSQId]  INT                                                IDENTITY (1, 1) NOT NULL,
    [PraticaAccreditamentoId] INT                                                NOT NULL,
    [AltroSchemaSQId]         INT                                                NOT NULL,
    [LimitazioneIta]          NVARCHAR (MAX)                                     NULL,
    [LimitazioneEng]          NVARCHAR (MAX)                                     NULL,
    [DataCreazione]           DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                INT                                                NULL,
    [DataModifica]            DATETIME2 (7)                                      NULL,
    [ModificatoDa]            INT                                                NULL,
    [DataCancellazione]       DATETIME2 (7)                                      NULL,
    [CancellatoDa]            INT                                                NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [UltimaReleaseId]         INT                                                NULL,
    [ChecksumSemantico]       BIGINT                                             NULL,
    [SchemaAccreditamentoId]  INT                                                NOT NULL,
    [DataInizioValidita]      DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]        DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_PraticaAltroSchemaSQ] PRIMARY KEY CLUSTERED ([PraticaAltroSchemaSQId] ASC),
    CONSTRAINT [FK_PraticaAltroSchemaSQ_SchemaAccreditamento] FOREIGN KEY ([SchemaAccreditamentoId]) REFERENCES [Standard].[SchemaAccreditamento] ([SchemaAccreditamentoId]),
    CONSTRAINT [FK_PraticaSQ_Pratica] FOREIGN KEY ([PraticaAccreditamentoId]) REFERENCES [Accreditamento].[PraticaAccreditamento] ([PraticaAccreditamentoId]),
    CONSTRAINT [UQ_PraticaSQ_Pratica_Schema] UNIQUE NONCLUSTERED ([PraticaAccreditamentoId] ASC, [AltroSchemaSQId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Accreditamento].[PraticaAltroSchemaSQStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:PraticaAltroSchemaSQ;Nullable', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'ChecksumSemantico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'PraticaAltroSchemaSQId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco del record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'UltimaReleaseId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso la pratica cui e associato uno schema supplementare di sistema di gestione.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'PraticaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'PraticaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:PraticaAltroSchemaSQ;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ASSOCIAZIONE', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"PraticaAltroSchemaSQ","column":"LimitazioneIta","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'LimitazioneIta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"PraticaAltroSchemaSQ","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'AltroSchemaSQId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'PraticaAltroSchemaSQId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:PraticaAltroSchemaSQ;Nullable', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'LimitazioneIta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'UltimaReleaseId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:PraticaAltroSchemaSQ;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'UltimaReleaseId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'PraticaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:PraticaAltroSchemaSQ;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:PraticaAltroSchemaSQ;Nullable', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'LimitazioneEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"PraticaAltroSchemaSQ","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"PraticaAltroSchemaSQ","column":"LimitazioneEng","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'LimitazioneEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dello schema supplementare/altro schema SQ collegato alla pratica. Da ricondurre a tassonomia strutturata quando usato per autorizzazione o pubblicazione.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'AltroSchemaSQId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'PraticaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'ChecksumSemantico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"PraticaAltroSchemaSQ","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'AltroSchemaSQId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"PraticaAltroSchemaSQ","column":"PraticaAltroSchemaSQId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'PraticaAltroSchemaSQId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo di dominio ChecksumSemantico.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'ChecksumSemantico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'LimitazioneIta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:PraticaAltroSchemaSQ;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"PraticaAltroSchemaSQ","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'AltroSchemaSQId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'LimitazioneEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:PraticaAltroSchemaSQ;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'ChecksumSemantico';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Limitazione in italiano applicabile allo schema supplementare. Campo descrittivo da interpretare con la pratica e con eventuale voce di scopo.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'LimitazioneIta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:PraticaAltroSchemaSQ;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'PraticaAltroSchemaSQId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"PraticaAltroSchemaSQ","column":"UltimaReleaseId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'UltimaReleaseId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:PraticaAltroSchemaSQ;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'PraticaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo di dominio LimitazioneEng.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'LimitazioneEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:PraticaAltroSchemaSQ;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:PraticaAltroSchemaSQ;Nullable', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'UltimaReleaseId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"PraticaAltroSchemaSQ","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"PraticaAltroSchemaSQ","column":"PraticaAccreditamentoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Accreditamento.PraticaAccreditamento.PraticaAccreditamentoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'PraticaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'ChecksumSemantico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'LimitazioneIta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"PraticaAltroSchemaSQ","column":"AltroSchemaSQId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Standard.AltroSchemaSQ.AltroSchemaSQId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'AltroSchemaSQId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'PraticaAltroSchemaSQId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:PraticaAltroSchemaSQ;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.SchemaAccreditamento. Esplicita lo schema di accreditamento a cui appartiene l''altro schema SQ.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'SchemaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'LimitazioneIta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tabella dominio Accreditamento con gestione audit, soft-delete e system-versioning dove previsto.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record (GUID tecnico).', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"PraticaAltroSchemaSQ","temporal":true,"temporal_type":2,"history_table":"Accreditamento.PraticaAltroSchemaSQStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"PraticaAltroSchemaSQ","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'LimitazioneEng';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"PraticaAltroSchemaSQ","column":"ChecksumSemantico","data_type":"bigint","max_length":8,"precision":19,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'ChecksumSemantico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'LimitazioneEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"PraticaAltroSchemaSQ","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco del record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'PraticaAltroSchemaSQId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'UltimaReleaseId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:PraticaAltroSchemaSQ;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'PraticaAltroSchemaSQ', @level2type = N'COLUMN', @level2name = N'AltroSchemaSQId';


GO

