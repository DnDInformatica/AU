CREATE TABLE [Standard].[NACECorrispondenza] (
    [NACECorrispondenzaId] INT                                                IDENTITY (1, 1) NOT NULL,
    [VersioneDaId]         INT                                                NOT NULL,
    [NaceDaId]             INT                                                NOT NULL,
    [VersioneAId]          INT                                                NOT NULL,
    [NaceAId]              INT                                                NOT NULL,
    [Peso]                 DECIMAL (9, 6)                                     NULL,
    [Nota]                 NVARCHAR (500)                                     NULL,
    [DataCreazione]        DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [UniqueRowId]          UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]     DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_NACECorrispondenza] PRIMARY KEY CLUSTERED ([NACECorrispondenzaId] ASC),
    CONSTRAINT [FK_NACECorr_A] FOREIGN KEY ([NaceAId]) REFERENCES [Standard].[NACE] ([NaceId]),
    CONSTRAINT [FK_NACECorr_Da] FOREIGN KEY ([NaceDaId]) REFERENCES [Standard].[NACE] ([NaceId]),
    CONSTRAINT [FK_NACECorr_VerA] FOREIGN KEY ([VersioneAId]) REFERENCES [Standard].[ClassificazioneVersione] ([ClassificazioneVersioneId]),
    CONSTRAINT [FK_NACECorr_VerDa] FOREIGN KEY ([VersioneDaId]) REFERENCES [Standard].[ClassificazioneVersione] ([ClassificazioneVersioneId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[NACECorrispondenzaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'VersioneDaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'Nota';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NACECorrispondenza;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'VersioneAId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NACECorrispondenza","column":"Peso","data_type":"decimal","max_length":5,"precision":9,"scale":6,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'Peso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NACECorrispondenza","temporal":true,"temporal_type":2,"history_table":"Standard.NACECorrispondenzaStorico","soft_delete":false,"audit":false,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'NaceDaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'NACECorrispondenzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'VersioneDaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NACECorrispondenza;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'NaceAId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NACECorrispondenza","column":"Nota","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'Nota';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NACECorrispondenza;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'NACECorrispondenzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'NaceAId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NACECorrispondenza;NotNull', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'Nota';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NACECorrispondenza","column":"VersioneAId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Standard.ClassificazioneVersione.ClassificazioneVersioneId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'VersioneAId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'Peso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NACECorrispondenza;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'VersioneDaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NACECorrispondenza;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'NaceDaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'NACECorrispondenzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NACECorrispondenza","column":"NaceAId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Standard.NACE.NaceId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'NaceAId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NACECorrispondenza","column":"NACECorrispondenzaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'NACECorrispondenzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'NaceAId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'NaceDaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'VersioneAId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'Nota';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NACECorrispondenza","column":"VersioneDaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Standard.ClassificazioneVersione.ClassificazioneVersioneId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'VersioneDaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'Peso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NACECorrispondenza;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NACECorrispondenza","column":"NaceDaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Standard.NACE.NaceId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'NaceDaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;TemporalCurrent', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'NaceDaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'LOOKUP', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'VersioneAId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'NaceAId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NACECorrispondenza","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NACECorrispondenza;Nullable', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'Peso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'VersioneAId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'NACECorrispondenzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'Peso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NACECorrispondenza","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'VersioneDaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NACECorrispondenza;Nullable', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NACECorrispondenza', @level2type = N'COLUMN', @level2name = N'Nota';


GO

