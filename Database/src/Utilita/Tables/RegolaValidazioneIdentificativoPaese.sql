CREATE TABLE [Utilita].[RegolaValidazioneIdentificativoPaese] (
    [RegolaValidazioneIdentificativoPaeseId] INT             IDENTITY (1, 1) NOT NULL,
    [CountryCode]                            CHAR (2)        NOT NULL,
    [TipoIdentificativo]                     VARCHAR (10)    NOT NULL,
    [MetodoFormale]                          VARCHAR (30)    NOT NULL,
    [RichiedeVerificaOnline]                 BIT             NOT NULL,
    [FonteOnlineSuggerita]                   VARCHAR (20)    NULL,
    [Note]                                   NVARCHAR (1000) NULL,
    [IsAttiva]                               BIT             DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_RegolaValidazioneIdentificativoPaese] PRIMARY KEY CLUSTERED ([RegolaValidazioneIdentificativoPaeseId] ASC),
    CONSTRAINT [CK_RegolaValidazioneIdentificativoPaese_Fonte] CHECK ([FonteOnlineSuggerita] IS NULL OR ([FonteOnlineSuggerita]='ALTRO' OR [FonteOnlineSuggerita]='MANUALE' OR [FonteOnlineSuggerita]='VIES' OR [FonteOnlineSuggerita]='AE')),
    CONSTRAINT [CK_RegolaValidazioneIdentificativoPaese_Metodo] CHECK ([MetodoFormale]='NONE' OR [MetodoFormale]='EU_VAT_GENERIC' OR [MetodoFormale]='IT_CF' OR [MetodoFormale]='IT_PIVA'),
    CONSTRAINT [CK_RegolaValidazioneIdentificativoPaese_Tipo] CHECK ([TipoIdentificativo]='PIVA' OR [TipoIdentificativo]='CF'),
    CONSTRAINT [UQ_RegolaValidazioneIdentificativoPaese] UNIQUE NONCLUSTERED ([CountryCode] ASC, [TipoIdentificativo] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:RegolaValidazioneIdentificativoPaese;NotNull', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'MetodoFormale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'MetodoFormale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"RegolaValidazioneIdentificativoPaese","column":"RichiedeVerificaOnline","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'RichiedeVerificaOnline';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'RichiedeVerificaOnline';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'MetodoFormale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:RegolaValidazioneIdentificativoPaese;NotNull', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'TipoIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'MetodoFormale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"RegolaValidazioneIdentificativoPaese","column":"MetodoFormale","data_type":"varchar","max_length":30,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'MetodoFormale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"RegolaValidazioneIdentificativoPaese","column":"TipoIdentificativo","data_type":"varchar","max_length":10,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'TipoIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'TipoIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:RegolaValidazioneIdentificativoPaese;NotNull', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'CountryCode';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'TipoIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'TipoIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'IsAttiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"RegolaValidazioneIdentificativoPaese","column":"CountryCode","data_type":"char","max_length":2,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'CountryCode';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'CountryCode';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'IsAttiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:RegolaValidazioneIdentificativoPaese;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'RegolaValidazioneIdentificativoPaeseId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'CountryCode';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'CountryCode';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:RegolaValidazioneIdentificativoPaese;NotNull', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'IsAttiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'RegolaValidazioneIdentificativoPaeseId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;NonTemporal', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:RegolaValidazioneIdentificativoPaese;Nullable', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"RegolaValidazioneIdentificativoPaese","column":"IsAttiva","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'IsAttiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'RegolaValidazioneIdentificativoPaeseId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'RegolaValidazioneIdentificativoPaeseId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"RegolaValidazioneIdentificativoPaese","column":"RegolaValidazioneIdentificativoPaeseId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'RegolaValidazioneIdentificativoPaeseId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'IsAttiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"RegolaValidazioneIdentificativoPaese","temporal":false,"temporal_type":0,"history_table":null,"soft_delete":false,"audit":false,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"RegolaValidazioneIdentificativoPaese","column":"Note","data_type":"nvarchar","max_length":2000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'CONFIGURAZIONE', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'FonteOnlineSuggerita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Utilita","table":"RegolaValidazioneIdentificativoPaese","column":"FonteOnlineSuggerita","data_type":"varchar","max_length":20,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'FonteOnlineSuggerita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:RegolaValidazioneIdentificativoPaese;Nullable', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'FonteOnlineSuggerita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'FonteOnlineSuggerita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'RichiedeVerificaOnline';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'RichiedeVerificaOnline';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'FonteOnlineSuggerita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Utilita;Table:RegolaValidazioneIdentificativoPaese;NotNull', @level0type = N'SCHEMA', @level0name = N'Utilita', @level1type = N'TABLE', @level1name = N'RegolaValidazioneIdentificativoPaese', @level2type = N'COLUMN', @level2name = N'RichiedeVerificaOnline';


GO

