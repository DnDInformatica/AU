CREATE TABLE [Utilita].[VerificaIdentificativoFiscale] (
    [VerificaIdentificativoFiscaleId] BIGINT           IDENTITY (1, 1) NOT NULL,
    [CorrelationId]                   UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [TipoIdentificativo]              VARCHAR (10)     NOT NULL,
    [Identificativo]                  VARCHAR (64)     NOT NULL,
    [CountryCode]                     CHAR (2)         DEFAULT ('IT') NOT NULL,
    [EsitoFormale]                    BIT              NULL,
    [EsitoOnline]                     VARCHAR (30)     NULL,
    [FonteOnline]                     VARCHAR (20)     NULL,
    [DataRichiestaUtc]                DATETIME2 (7)    DEFAULT (sysutcdatetime()) NOT NULL,
    [DataRispostaUtc]                 DATETIME2 (7)    NULL,
    [Dettaglio]                       NVARCHAR (2000)  NULL,
    [PayloadHash]                     VARBINARY (32)   NULL,
    [PayloadSnapshot]                 NVARCHAR (MAX)   NULL,
    [DataCreazione]                   DATETIME2 (7)    DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_VerificaIdentificativoFiscale] PRIMARY KEY CLUSTERED ([VerificaIdentificativoFiscaleId] ASC),
    CONSTRAINT [CK_VerificaIdentificativoFiscale_EsitoOnline] CHECK ([EsitoOnline] IS NULL OR ([EsitoOnline]='ERRORE' OR [EsitoOnline]='DA_RIVERIFICARE' OR [EsitoOnline]='NON_VERIFICABILE' OR [EsitoOnline]='NON_VALIDO' OR [EsitoOnline]='VALIDO')),
    CONSTRAINT [CK_VerificaIdentificativoFiscale_FonteOnline] CHECK ([FonteOnline] IS NULL OR ([FonteOnline]='ALTRO' OR [FonteOnline]='MANUALE' OR [FonteOnline]='VIES' OR [FonteOnline]='AE')),
    CONSTRAINT [CK_VerificaIdentificativoFiscale_Tipo] CHECK ([TipoIdentificativo]='PIVA' OR [TipoIdentificativo]='CF')
);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'PayloadHash';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:VerificaIdentificativoFiscale;Nullable', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'FonteOnline';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'VerificaIdentificativoFiscaleId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:VerificaIdentificativoFiscale;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"VerificaIdentificativoFiscale","column":"CountryCode","data_type":"char","max_length":2,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'CountryCode';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'FonteOnline';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'CountryCode';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'DataRichiestaUtc';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'VerificaIdentificativoFiscaleId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"VerificaIdentificativoFiscale","column":"PayloadHash","data_type":"varbinary","max_length":32,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'PayloadHash';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"VerificaIdentificativoFiscale","column":"VerificaIdentificativoFiscaleId","data_type":"bigint","max_length":8,"precision":19,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'VerificaIdentificativoFiscaleId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'CountryCode';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'Dettaglio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'CONFIGURAZIONE', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:VerificaIdentificativoFiscale;NotNull', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'Identificativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"VerificaIdentificativoFiscale","column":"FonteOnline","data_type":"varchar","max_length":20,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'FonteOnline';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:VerificaIdentificativoFiscale;Nullable', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'Dettaglio';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Log verifiche CF/PIVA con esito formale e anagrafico online (AE/VIES). Fonti ufficiali: Agenzia Entrate (verifica CF/PIVA), Commissione UE VIES.', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'CountryCode';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;NonTemporal', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'FonteOnline';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"VerificaIdentificativoFiscale","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"VerificaIdentificativoFiscale","column":"Dettaglio","data_type":"nvarchar","max_length":4000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'Dettaglio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"VerificaIdentificativoFiscale","temporal":false,"temporal_type":0,"history_table":null,"soft_delete":false,"audit":false,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Esito verifica online: VALIDO, NON_VALIDO, NON_VERIFICABILE, DA_RIVERIFICARE, ERRORE.', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'EsitoOnline';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"VerificaIdentificativoFiscale","column":"Identificativo","data_type":"varchar","max_length":64,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'Identificativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'Dettaglio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'Identificativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'FonteOnline';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'Identificativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:VerificaIdentificativoFiscale;Nullable', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'PayloadSnapshot';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:VerificaIdentificativoFiscale;NotNull', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'TipoIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:VerificaIdentificativoFiscale;Nullable', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'DataRispostaUtc';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'EsitoOnline';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'Dettaglio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:VerificaIdentificativoFiscale;Nullable', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'EsitoOnline';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'Identificativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'DataRispostaUtc';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"VerificaIdentificativoFiscale","column":"EsitoOnline","data_type":"varchar","max_length":30,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'EsitoOnline';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"VerificaIdentificativoFiscale","column":"TipoIdentificativo","data_type":"varchar","max_length":10,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'TipoIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'PayloadSnapshot';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'TipoIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'DataRispostaUtc';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'PayloadSnapshot';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'EsitoOnline';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'TipoIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:VerificaIdentificativoFiscale;NotNull', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'CorrelationId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:VerificaIdentificativoFiscale;Nullable', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'EsitoFormale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'DataRispostaUtc';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'PayloadSnapshot';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'CorrelationId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'EsitoFormale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'EsitoOnline';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'TipoIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"VerificaIdentificativoFiscale","column":"DataRispostaUtc","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'DataRispostaUtc';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"VerificaIdentificativoFiscale","column":"PayloadSnapshot","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'PayloadSnapshot';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'DataRichiestaUtc';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"VerificaIdentificativoFiscale","column":"CorrelationId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'CorrelationId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"VerificaIdentificativoFiscale","column":"EsitoFormale","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'EsitoFormale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'CorrelationId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'PayloadHash';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:VerificaIdentificativoFiscale;NotNull', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'DataRichiestaUtc';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'CorrelationId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:VerificaIdentificativoFiscale;Nullable', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'PayloadHash';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'EsitoFormale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"VerificaIdentificativoFiscale","column":"DataRichiestaUtc","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'DataRichiestaUtc';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'VerificaIdentificativoFiscaleId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:VerificaIdentificativoFiscale;NotNull', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'CountryCode';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'DataRichiestaUtc';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'EsitoFormale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:VerificaIdentificativoFiscale;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'VerificaIdentificativoFiscaleId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'VerificaIdentificativoFiscale', @level2type = N'COLUMN', @level2name = N'PayloadHash';


GO

