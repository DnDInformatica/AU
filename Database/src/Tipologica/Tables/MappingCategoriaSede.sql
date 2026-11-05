CREATE TABLE [Tipologica].[MappingCategoriaSede] (
    [MappingId]                INT                                                IDENTITY (1, 1) NOT NULL,
    [CategoriaOrigine]         NVARCHAR (100)                                     NULL,
    [TipoUnitaOrganizzativaId] INT                                                NOT NULL,
    [TipoSedeId]               INT                                                NOT NULL,
    [Principale]               BIT                                                DEFAULT ((0)) NOT NULL,
    [Escludere]                BIT                                                DEFAULT ((0)) NOT NULL,
    [Note]                     NVARCHAR (500)                                     NULL,
    [DataInizioValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]         DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK__MappingC__8B57819D2AE35DB6] PRIMARY KEY CLUSTERED ([MappingId] ASC),
    CONSTRAINT [FK_Mapping_TipoSede] FOREIGN KEY ([TipoSedeId]) REFERENCES [Tipologica].[TipoSede] ([TipoSedeId]),
    CONSTRAINT [FK_Mapping_TipoUO] FOREIGN KEY ([TipoUnitaOrganizzativaId]) REFERENCES [Tipologica].[TipoUnitaOrganizzativa] ([TipoUnitaOrganizzativaId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Tipologica].[MappingCategoriaSedeStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:MappingCategoriaSede;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'CategoriaOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'Escludere';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2025.12', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"MappingCategoriaSede","column":"TipoUnitaOrganizzativaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.TipoUnitaOrganizzativa.TipoUnitaOrganizzativaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'TipoUnitaOrganizzativaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:MappingCategoriaSede;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2025.12', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'CategoriaOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"MappingCategoriaSede","column":"Escludere","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'Escludere';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"MappingCategoriaSede","entity":"MappingCategoriaSede","temporal":false,"temporal_type":0,"history_table":null,"doc":{"ms_description":"MS_Description","extended_doc":"Accredia.Doc","model_note":"Accredia.ModelNote"}}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2025.12', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'CategoriaOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:MappingCategoriaSede;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'TipoSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2025.12', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'MappingId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:MappingCategoriaSede;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'MappingId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"MappingCategoriaSede","column":"Principale","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:MappingCategoriaSede;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'TipoUnitaOrganizzativaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;NonTemporal;Lookup;Mapping', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2025.12', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'TipoSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'TipoSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'MappingId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'TipoUnitaOrganizzativaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:MappingCategoriaSede;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'Escludere';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2025.12', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'Escludere';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2025.12', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2025.12', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'TipoUnitaOrganizzativaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"MappingCategoriaSede","column":"Note","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'LOOKUP', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"MappingCategoriaSede","column":"CategoriaOrigine","data_type":"nvarchar","max_length":200,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'CategoriaOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'CategoriaOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'Escludere';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'TipoSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'MappingId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:MappingCategoriaSede;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'TipoUnitaOrganizzativaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tabella tecnica di mapping a supporto del modello dati ACCREDIA. Utilizzata per la gestione delle relazioni di dominio senza semantica autonoma.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"MappingCategoriaSede","column":"MappingId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'MappingId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"MappingCategoriaSede","column":"TipoSedeId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.TipoSede.TipoSedeId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingCategoriaSede', @level2type = N'COLUMN', @level2name = N'TipoSedeId';


GO

