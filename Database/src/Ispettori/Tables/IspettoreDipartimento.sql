CREATE TABLE [Ispettori].[IspettoreDipartimento] (
    [IspettoreDipartimentoId]  INT                                                IDENTITY (1, 1) NOT NULL,
    [IspettoreId]              INT                                                NOT NULL,
    [DipartimentoAccrediaId]   INT                                                NOT NULL,
    [StatoNelDipartimento]     NVARCHAR (20)                                      DEFAULT ('ATTIVO') NOT NULL,
    [DataInizioCollaborazione] DATE                                               NOT NULL,
    [DataFineCollaborazione]   DATE                                               NULL,
    [NumeroConvenzione]        NVARCHAR (50)                                      NULL,
    [DataFirmaConvenzione]     DATE                                               NULL,
    [IsDipartimentoPrincipale] BIT                                                DEFAULT ((0)) NOT NULL,
    [TariffaGiornaliera]       DECIMAL (10, 2)                                    NULL,
    [Note]                     NVARCHAR (500)                                     NULL,
    [DataCreazione]            DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                 INT                                                NULL,
    [DataModifica]             DATETIME2 (7)                                      NULL,
    [ModificatoDa]             INT                                                NULL,
    [DataCancellazione]        DATETIME2 (7)                                      NULL,
    [CancellatoDa]             INT                                                NULL,
    [UniqueRowId]              UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]         DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_IspettoreDipartimento] PRIMARY KEY CLUSTERED ([IspettoreDipartimentoId] ASC),
    CONSTRAINT [CK_IspDip_Stato] CHECK ([StatoNelDipartimento]='IN_FORMAZIONE' OR [StatoNelDipartimento]='CESSATO' OR [StatoNelDipartimento]='SOSPESO' OR [StatoNelDipartimento]='ATTIVO'),
    CONSTRAINT [FK_IspDip_Dipartimento] FOREIGN KEY ([DipartimentoAccrediaId]) REFERENCES [Tipologica].[DipartimentoAccredia] ([DipartimentoAccrediaId]),
    CONSTRAINT [FK_IspDip_Ispettore] FOREIGN KEY ([IspettoreId]) REFERENCES [Ispettori].[Ispettore] ([IspettoreId]),
    CONSTRAINT [UQ_IspettoreDipartimento] UNIQUE NONCLUSTERED ([IspettoreId] ASC, [DipartimentoAccrediaId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Ispettori].[IspettoreDipartimentoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'IspettoreDipartimentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"IspettoreDipartimento","column":"IspettoreDipartimentoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'IspettoreDipartimentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ASSOCIAZIONE', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'IspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"IspettoreDipartimento","column":"IspettoreId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Ispettori.Ispettore.IspettoreId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'IspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'IspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'IspettoreDipartimentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'IspettoreDipartimentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:IspettoreDipartimento;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'IspettoreDipartimentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:IspettoreDipartimento;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'IsDipartimentoPrincipale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"IspettoreDipartimento","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'IsDipartimentoPrincipale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"IspettoreDipartimento","column":"TariffaGiornaliera","data_type":"decimal","max_length":9,"precision":10,"scale":2,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'TariffaGiornaliera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:IspettoreDipartimento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'TariffaGiornaliera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'TariffaGiornaliera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:IspettoreDipartimento;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'TariffaGiornaliera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'TariffaGiornaliera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"IspettoreDipartimento","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"IspettoreDipartimento","column":"Note","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"IspettoreDipartimento","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:IspettoreDipartimento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataFirmaConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"IspettoreDipartimento","column":"DataFirmaConvenzione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataFirmaConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:IspettoreDipartimento;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataFirmaConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"IspettoreDipartimento","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataFirmaConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'IsDipartimentoPrincipale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:IspettoreDipartimento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'IsDipartimentoPrincipale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"IspettoreDipartimento","column":"IsDipartimentoPrincipale","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'IsDipartimentoPrincipale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"IspettoreDipartimento","temporal":true,"temporal_type":2,"history_table":"Ispettori.IspettoreDipartimentoStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"IspettoreDipartimento","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"IspettoreDipartimento","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:IspettoreDipartimento;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:IspettoreDipartimento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:IspettoreDipartimento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:IspettoreDipartimento;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"IspettoreDipartimento","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataInizioCollaborazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:IspettoreDipartimento;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataInizioCollaborazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataFineCollaborazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"IspettoreDipartimento","column":"DataFineCollaborazione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataFineCollaborazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:IspettoreDipartimento;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'StatoNelDipartimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataInizioCollaborazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"IspettoreDipartimento","column":"DataInizioCollaborazione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataInizioCollaborazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataInizioCollaborazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'NumeroConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"IspettoreDipartimento","column":"NumeroConvenzione","data_type":"nvarchar","max_length":100,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'NumeroConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'NumeroConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:IspettoreDipartimento;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'NumeroConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:IspettoreDipartimento;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataFirmaConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataFineCollaborazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataFineCollaborazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:IspettoreDipartimento;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DataFineCollaborazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'NumeroConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"IspettoreDipartimento","column":"DipartimentoAccrediaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.DipartimentoAccredia.DipartimentoAccrediaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'IspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:IspettoreDipartimento;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'IspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"IspettoreDipartimento","column":"StatoNelDipartimento","data_type":"nvarchar","max_length":40,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'StatoNelDipartimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'StatoNelDipartimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'StatoNelDipartimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:IspettoreDipartimento;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'IspettoreDipartimento', @level2type = N'COLUMN', @level2name = N'StatoNelDipartimento';


GO

