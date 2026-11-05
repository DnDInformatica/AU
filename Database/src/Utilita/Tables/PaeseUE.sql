CREATE TABLE [Utilita].[PaeseUE] (
    [CountryCode] CHAR (2)       NOT NULL,
    [NomePaese]   NVARCHAR (100) NOT NULL,
    [IsAttivo]    BIT            DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PaeseUE] PRIMARY KEY CLUSTERED ([CountryCode] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"PaeseUE","temporal":false,"temporal_type":0,"history_table":null,"soft_delete":false,"audit":false,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:PaeseUE;NotNull', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE', @level2type = N'COLUMN', @level2name = N'IsAttivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE', @level2type = N'COLUMN', @level2name = N'IsAttivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:PaeseUE;NotNull;PII', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE', @level2type = N'COLUMN', @level2name = N'NomePaese';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE', @level2type = N'COLUMN', @level2name = N'NomePaese';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE', @level2type = N'COLUMN', @level2name = N'NomePaese';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"PaeseUE","column":"NomePaese","data_type":"nvarchar","max_length":200,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"PII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE', @level2type = N'COLUMN', @level2name = N'NomePaese';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE', @level2type = N'COLUMN', @level2name = N'IsAttivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"PaeseUE","column":"IsAttivo","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE', @level2type = N'COLUMN', @level2name = N'IsAttivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE', @level2type = N'COLUMN', @level2name = N'IsAttivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE', @level2type = N'COLUMN', @level2name = N'CountryCode';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;NonTemporal', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'CONFIGURAZIONE', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE', @level2type = N'COLUMN', @level2name = N'NomePaese';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:PaeseUE;PK;NotNull', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE', @level2type = N'COLUMN', @level2name = N'CountryCode';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE', @level2type = N'COLUMN', @level2name = N'CountryCode';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"PaeseUE","column":"CountryCode","data_type":"char","max_length":2,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE', @level2type = N'COLUMN', @level2name = N'CountryCode';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'PaeseUE', @level2type = N'COLUMN', @level2name = N'CountryCode';


GO

