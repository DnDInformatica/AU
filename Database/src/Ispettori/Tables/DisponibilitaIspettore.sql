CREATE TABLE [Ispettori].[DisponibilitaIspettore] (
    [DisponibilitaIspettoreId]   INT                                                IDENTITY (1, 1) NOT NULL,
    [IspettoreId]                INT                                                NOT NULL,
    [DataInizio]                 DATE                                               NOT NULL,
    [DataFine]                   DATE                                               NOT NULL,
    [TipoDisponibilita]          NVARCHAR (20)                                      NOT NULL,
    [Motivo]                     NVARCHAR (200)                                     NULL,
    [GiorniSettimanaDisponibili] NVARCHAR (50)                                      NULL,
    [OreGiornaliereMax]          INT                                                NULL,
    [Note]                       NVARCHAR (500)                                     NULL,
    [DataCreazione]              DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                   INT                                                NULL,
    [DataModifica]               DATETIME2 (7)                                      NULL,
    [ModificatoDa]               INT                                                NULL,
    [DataCancellazione]          DATETIME2 (7)                                      NULL,
    [CancellatoDa]               INT                                                NULL,
    [UniqueRowId]                UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]         DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]           DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_DisponibilitaIspettore] PRIMARY KEY CLUSTERED ([DisponibilitaIspettoreId] ASC),
    CONSTRAINT [CK_DisponibilitaIspettore_Date] CHECK ([DataFine]>=[DataInizio]),
    CONSTRAINT [CK_DisponibilitaIspettore_Tipo] CHECK ([TipoDisponibilita]='LIMITATA' OR [TipoDisponibilita]='NON_DISPONIBILE' OR [TipoDisponibilita]='DISPONIBILE'),
    CONSTRAINT [FK_DisponibilitaIspettore_Ispettore] FOREIGN KEY ([IspettoreId]) REFERENCES [Ispettori].[Ispettore] ([IspettoreId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Ispettori].[DisponibilitaIspettoreStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"DisponibilitaIspettore","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:DisponibilitaIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'GiorniSettimanaDisponibili';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'Motivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"DisponibilitaIspettore","column":"DataFine","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'IspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'TipoDisponibilita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:DisponibilitaIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"DisponibilitaIspettore","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'TipoDisponibilita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:DisponibilitaIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'Motivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"DisponibilitaIspettore","temporal":true,"temporal_type":2,"history_table":"Ispettori.DisponibilitaIspettoreStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"DisponibilitaIspettore","column":"IspettoreId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Ispettori.Ispettore.IspettoreId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'IspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"DisponibilitaIspettore","column":"DataInizio","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DisponibilitaIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:DisponibilitaIspettore;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"DisponibilitaIspettore","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'OreGiornaliereMax';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'GiorniSettimanaDisponibili';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:DisponibilitaIspettore;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'IspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"DisponibilitaIspettore","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"DisponibilitaIspettore","column":"TipoDisponibilita","data_type":"nvarchar","max_length":40,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'TipoDisponibilita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:DisponibilitaIspettore;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DisponibilitaIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:DisponibilitaIspettore;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'Motivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'GiorniSettimanaDisponibili';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:DisponibilitaIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'OreGiornaliereMax';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'Motivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'IspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'OreGiornaliereMax';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"DisponibilitaIspettore","column":"GiorniSettimanaDisponibili","data_type":"nvarchar","max_length":100,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'GiorniSettimanaDisponibili';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DisponibilitaIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:DisponibilitaIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:DisponibilitaIspettore;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DisponibilitaIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:DisponibilitaIspettore;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'TipoDisponibilita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"DisponibilitaIspettore","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:DisponibilitaIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"DisponibilitaIspettore","column":"Motivo","data_type":"nvarchar","max_length":400,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'Motivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"DisponibilitaIspettore","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:DisponibilitaIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"DisponibilitaIspettore","column":"DisponibilitaIspettoreId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DisponibilitaIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:DisponibilitaIspettore;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'OreGiornaliereMax';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"DisponibilitaIspettore","column":"Note","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:DisponibilitaIspettore;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"DisponibilitaIspettore","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:DisponibilitaIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'TipoDisponibilita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'GiorniSettimanaDisponibili';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'IspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"DisponibilitaIspettore","column":"OreGiornaliereMax","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'DisponibilitaIspettore', @level2type = N'COLUMN', @level2name = N'OreGiornaliereMax';


GO

