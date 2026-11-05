CREATE TABLE [Organizzazioni].[UnitaOrganizzativaFunzione] (
    [UnitaOrganizzativaFunzioneId] INT                                                IDENTITY (1, 1) NOT NULL,
    [UnitaOrganizzativaId]         INT                                                NOT NULL,
    [TipoFunzioneUnitaLocaleId]    INT                                                NOT NULL,
    [Principale]                   BIT                                                DEFAULT ((0)) NOT NULL,
    [Note]                         NVARCHAR (500)                                     NULL,
    [DataCreazione]                DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                     INT                                                NULL,
    [DataModifica]                 DATETIME2 (7)                                      NULL,
    [ModificatoDa]                 INT                                                NULL,
    [DataCancellazione]            DATETIME2 (7)                                      NULL,
    [CancellatoDa]                 INT                                                NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER                                   DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita]           DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]             DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_UnitaOrganizzativaFunzione] PRIMARY KEY CLUSTERED ([UnitaOrganizzativaFunzioneId] ASC),
    CONSTRAINT [FK_UnitaOrgFunzione_TipoFunzione] FOREIGN KEY ([TipoFunzioneUnitaLocaleId]) REFERENCES [Tipologica].[TipoFunzioneUnitaLocale] ([TipoFunzioneUnitaLocaleId]),
    CONSTRAINT [FK_UnitaOrgFunzione_UnitaOrganizzativa] FOREIGN KEY ([UnitaOrganizzativaId]) REFERENCES [Organizzazioni].[UnitaOrganizzativa] ([UnitaOrganizzativaId]),
    CONSTRAINT [UQ_UnitaOrgFunzione_UnitaTipo] UNIQUE NONCLUSTERED ([UnitaOrganizzativaId] ASC, [TipoFunzioneUnitaLocaleId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Organizzazioni].[UnitaOrganizzativaFunzioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"UnitaOrganizzativaFunzione","column":"Note","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'UnitaOrganizzativaFunzioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica del record.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'TipoFunzioneUnitaLocaleId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'UnitaOrganizzativaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"UnitaOrganizzativaFunzione","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:UnitaOrganizzativaFunzione;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'TipoFunzioneUnitaLocaleId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'CONFIGURAZIONE', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"UnitaOrganizzativaFunzione","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"UnitaOrganizzativaFunzione","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"UnitaOrganizzativaFunzione","column":"UnitaOrganizzativaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Organizzazioni.UnitaOrganizzativa.UnitaOrganizzativaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'UnitaOrganizzativaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'TipoFunzioneUnitaLocaleId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'UnitaOrganizzativaFunzioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indicatore booleano di stato/priorità.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"UnitaOrganizzativaFunzione","column":"TipoFunzioneUnitaLocaleId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.TipoFunzioneUnitaLocale.TipoFunzioneUnitaLocaleId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'TipoFunzioneUnitaLocaleId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"UnitaOrganizzativaFunzione","temporal":true,"temporal_type":2,"history_table":"Organizzazioni.UnitaOrganizzativaFunzioneStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:UnitaOrganizzativaFunzione;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:UnitaOrganizzativaFunzione;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:UnitaOrganizzativaFunzione;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'UnitaOrganizzativaFunzioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:UnitaOrganizzativaFunzione;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'TipoFunzioneUnitaLocaleId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:UnitaOrganizzativaFunzione;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'GUID tecnico univoco del record.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'UnitaOrganizzativaFunzioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha cancellato il record', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha modificato il record', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:UnitaOrganizzativaFunzione;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'UnitaOrganizzativaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"UnitaOrganizzativaFunzione","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"UnitaOrganizzativaFunzione","column":"UnitaOrganizzativaFunzioneId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'UnitaOrganizzativaFunzioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'UnitaOrganizzativaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"UnitaOrganizzativaFunzione","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"UnitaOrganizzativaFunzione","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"UnitaOrganizzativaFunzione","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'UnitaOrganizzativaFunzioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:UnitaOrganizzativaFunzione;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'TipoFunzioneUnitaLocaleId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'organizzazioni;anagrafica;audit;compliance', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:UnitaOrganizzativaFunzione;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'UnitaOrganizzativaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Entità del dominio unità organizzative: UnitaOrganizzativaFunzione. Modella struttura, relazioni e funzioni interne.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note e annotazioni libere di supporto operativo.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:UnitaOrganizzativaFunzione;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:UnitaOrganizzativaFunzione;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'UnitaOrganizzativaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"UnitaOrganizzativaFunzione","column":"Principale","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:UnitaOrganizzativaFunzione;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaFunzione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

