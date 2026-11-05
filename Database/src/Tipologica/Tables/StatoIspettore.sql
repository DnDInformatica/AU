CREATE TABLE [Tipologica].[StatoIspettore] (
    [StatoIspettoreId]     INT                                                IDENTITY (1, 1) NOT NULL,
    [Codice]               NVARCHAR (20)                                      NOT NULL,
    [Descrizione]          NVARCHAR (200)                                     NOT NULL,
    [DescrizioneEstesa]    NVARCHAR (500)                                     NULL,
    [Categoria]            NVARCHAR (50)                                      NOT NULL,
    [ConsenteAssegnazione] BIT                                                DEFAULT ((0)) NOT NULL,
    [ConsenteFormazione]   BIT                                                DEFAULT ((1)) NOT NULL,
    [RichiedeMotivazione]  BIT                                                DEFAULT ((0)) NOT NULL,
    [ColoreUI]             NVARCHAR (7)                                       NULL,
    [Ordine]               INT                                                DEFAULT ((0)) NOT NULL,
    [Attivo]               BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]        DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]             INT                                                NULL,
    [DataModifica]         DATETIME2 (7)                                      NULL,
    [ModificatoDa]         INT                                                NULL,
    [DataCancellazione]    DATETIME2 (7)                                      NULL,
    [CancellatoDa]         INT                                                NULL,
    [UniqueRowId]          UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]     DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_StatoIspettore] PRIMARY KEY CLUSTERED ([StatoIspettoreId] ASC),
    CONSTRAINT [CK_StatoIspettore_Categoria] CHECK ([Categoria]='FORMAZIONE' OR [Categoria]='CESSATO' OR [Categoria]='SOSPESO' OR [Categoria]='ATTIVO'),
    CONSTRAINT [UQ_StatoIspettore_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Tipologica].[StatoIspettoreStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'ColoreUI';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:StatoIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'ColoreUI';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"StatoIspettore","column":"Codice","data_type":"nvarchar","max_length":40,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'ColoreUI';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"StatoIspettore","column":"Ordine","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"StatoIspettore","column":"RichiedeMotivazione","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'RichiedeMotivazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"StatoIspettore","column":"StatoIspettoreId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'StatoIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'RichiedeMotivazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'StatoIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'RichiedeMotivazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:StatoIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'RichiedeMotivazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'RichiedeMotivazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'StatoIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:StatoIspettore;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'StatoIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"StatoIspettore","column":"ColoreUI","data_type":"nvarchar","max_length":14,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'ColoreUI';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'ColoreUI';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"StatoIspettore","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:StatoIspettore;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:StatoIspettore;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:StatoIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'DescrizioneEstesa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"StatoIspettore","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:StatoIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:StatoIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"StatoIspettore","column":"Attivo","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:StatoIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"StatoIspettore","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"StatoIspettore","column":"Descrizione","data_type":"nvarchar","max_length":400,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"StatoIspettore","column":"Categoria","data_type":"nvarchar","max_length":100,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Categoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Categoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Categoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"StatoIspettore","temporal":true,"temporal_type":2,"history_table":"Tipologica.StatoIspettoreStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:StatoIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Categoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"StatoIspettore","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"StatoIspettore","column":"DescrizioneEstesa","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'DescrizioneEstesa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:StatoIspettore;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"StatoIspettore","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:StatoIspettore;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'DescrizioneEstesa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:StatoIspettore;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:StatoIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'DescrizioneEstesa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'DescrizioneEstesa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"StatoIspettore","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:StatoIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:StatoIspettore;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"StatoIspettore","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'Categoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'ConsenteFormazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;TemporalCurrent;SoftDelete;Audit;Lookup', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stati del ciclo di vita degli ispettori ACCREDIA', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'ConsenteFormazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"StatoIspettore","column":"ConsenteFormazione","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'ConsenteFormazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'ConsenteFormazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'StatoIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:StatoIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'ConsenteFormazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'ConsenteAssegnazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'ConsenteAssegnazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"StatoIspettore","column":"ConsenteAssegnazione","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'ConsenteAssegnazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'ConsenteAssegnazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:StatoIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore', @level2type = N'COLUMN', @level2name = N'ConsenteAssegnazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'LOOKUP', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoIspettore';


GO

