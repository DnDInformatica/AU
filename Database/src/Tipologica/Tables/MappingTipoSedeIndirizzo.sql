CREATE TABLE [Tipologica].[MappingTipoSedeIndirizzo] (
    [MappingId]          INT                                                IDENTITY (1, 1) NOT NULL,
    [TipoSedeOrigine]    NVARCHAR (100)                                     NULL,
    [TipoIndirizzoId]    INT                                                NOT NULL,
    [Principale]         BIT                                                DEFAULT ((0)) NOT NULL,
    [Note]               NVARCHAR (200)                                     NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK__MappingT__8B57819D70B02E3B] PRIMARY KEY CLUSTERED ([MappingId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Tipologica].[MappingTipoSedeIndirizzoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"MappingTipoSedeIndirizzo","column":"Principale","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:MappingTipoSedeIndirizzo;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2025.12', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'TipoSedeOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"MappingTipoSedeIndirizzo","column":"TipoSedeOrigine","data_type":"nvarchar","max_length":200,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'TipoSedeOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2025.12', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'TipoIndirizzoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:MappingTipoSedeIndirizzo;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'TipoIndirizzoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'TipoIndirizzoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"MappingTipoSedeIndirizzo","column":"MappingId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'MappingId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;NonTemporal;Lookup;Mapping', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'MappingId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"MappingTipoSedeIndirizzo","entity":"MappingTipoSedeIndirizzo","temporal":false,"temporal_type":0,"history_table":null,"doc":{"ms_description":"MS_Description","extended_doc":"Accredia.Doc","model_note":"Accredia.ModelNote"}}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2025.12', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:MappingTipoSedeIndirizzo;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"MappingTipoSedeIndirizzo","column":"Note","data_type":"nvarchar","max_length":400,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2025.12', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'TipoSedeOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:MappingTipoSedeIndirizzo;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'TipoSedeOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'TipoSedeOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'TipoIndirizzoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"MappingTipoSedeIndirizzo","column":"TipoIndirizzoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'TipoIndirizzoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'MappingId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'LOOKUP', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:MappingTipoSedeIndirizzo;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'MappingId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2025.12', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo', @level2type = N'COLUMN', @level2name = N'MappingId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DG', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2025.12', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'MappingTipoSedeIndirizzo';


GO

