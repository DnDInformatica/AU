CREATE TABLE [RisorseUmane].[Dotazione] (
    [DotazioneId]        INT                                                IDENTITY (1, 1) NOT NULL,
    [DipendenteId]       INT                                                NOT NULL,
    [TipoDotazioneId]    INT                                                NOT NULL,
    [Descrizione]        NVARCHAR (200)                                     NOT NULL,
    [NumeroInventario]   NVARCHAR (50)                                      NULL,
    [NumeroSerie]        NVARCHAR (100)                                     NULL,
    [DataAssegnazione]   DATE                                               NOT NULL,
    [DataRestituzione]   DATE                                               NULL,
    [IsRestituito]       BIT                                                DEFAULT ((0)) NOT NULL,
    [Note]               NVARCHAR (MAX)                                     NULL,
    [DataCreazione]      DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]           INT                                                NULL,
    [DataModifica]       DATETIME2 (7)                                      NULL,
    [ModificatoDa]       INT                                                NULL,
    [DataCancellazione]  DATETIME2 (7)                                      NULL,
    [CancellatoDa]       INT                                                NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_Dotazione_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_Dotazione_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_Dotazione] PRIMARY KEY CLUSTERED ([DotazioneId] ASC),
    CONSTRAINT [CK_Dotazione_Date] CHECK ([DataRestituzione] IS NULL OR [DataRestituzione]>=[DataAssegnazione]),
    CONSTRAINT [CK_Dotazione_Restituito] CHECK ([IsRestituito]=(1) AND [DataRestituzione] IS NOT NULL OR [IsRestituito]=(0)),
    CONSTRAINT [FK_Dotazione_Dipendente] FOREIGN KEY ([DipendenteId]) REFERENCES [RisorseUmane].[Dipendente] ([DipendenteId]),
    CONSTRAINT [FK_Dotazione_TipoDotazione] FOREIGN KEY ([TipoDotazioneId]) REFERENCES [Tipologica].[TipoDotazione] ([TipoDotazioneId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[RisorseUmane].[DotazioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'NumeroSerie';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dotazione","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'TRUE se la dotazione è stata restituita.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'IsRestituito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione IT / Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataAssegnazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dotazione;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Tipologica.TipoDotazione.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'TipoDotazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DotazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dotazione;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dotazione","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dotazione","column":"NumeroInventario","data_type":"nvarchar","max_length":100,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'NumeroInventario';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione IT / Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione IT / Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'NumeroSerie';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{
        "schema":"RisorseUmane",
        "table":"Dotazione",
        "entity":"Dotazione",
        "temporal":true,
        "temporal_type":2,
        "history_table":"RisorseUmane.DotazioneStorico",
        "soft_delete":true,
        "audit":true,
        "business_rules":{
            "inventory_required_for":[
                "PC_FISSO",
                "PC_PORTATILE",
                "TELEFONO_MOBILE",
                "AUTO"
            ],
            "return_required_on_cessation":true
        },
        "reference":"Regolamento Dotazioni Aziendali"
    }', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione IT / Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data restituzione. NULL se ancora in uso.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataRestituzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dotazione;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataAssegnazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DotazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'NumeroInventario';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso RisorseUmane.Dipendente.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dotazione;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dotazione","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dotazione;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione IT / Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'NumeroSerie';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'TipoDotazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione IT / Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dotazione;Nullable', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataRestituzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione IT / Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DotazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dotazione;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'IsRestituito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataAssegnazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione specifica del bene (es. Dell Latitude 5540, iPhone 14 Pro).', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dotazione","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione IT / Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dotazione;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'TipoDotazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dotazione","column":"NumeroSerie","data_type":"nvarchar","max_length":200,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'NumeroSerie';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dotazione","column":"DotazioneId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DotazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dotazione;Nullable', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataRestituzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione IT / Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'NumeroInventario';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione IT / Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione IT / Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dotazione","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dotazione","column":"TipoDotazioneId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.TipoDotazione.TipoDotazioneId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'TipoDotazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione IT / Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dotazione;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero inventario aziendale.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'NumeroInventario';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'risorse-umane,dotazione,asset,inventario,temporal,audit', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dotazione","column":"DataRestituzione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataRestituzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'IsRestituito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione IT / Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataAssegnazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dotazione;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'TipoDotazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione IT / Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dotazione","column":"DataAssegnazione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataAssegnazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dotazione","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'IsRestituito';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Asset aziendali assegnati ai dipendenti ACCREDIA (PC, telefoni, badge, auto, etc.).', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dotazione","column":"DipendenteId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"RisorseUmane.Dipendente.DipendenteId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataRestituzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione IT / Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'IsRestituito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dotazione","column":"Descrizione","data_type":"nvarchar","max_length":400,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data consegna al dipendente.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataAssegnazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dotazione","column":"Note","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dotazione;Nullable', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'NumeroSerie';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dotazione;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'NumeroInventario';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dotazione;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DotazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione IT / Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'TipoDotazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dotazione","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione IT / Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dotazione","column":"IsRestituito","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'IsRestituito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione IT / Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataRestituzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dotazione;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogate auto-incrementale.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DotazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dotazione;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'MASTER', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dotazione;Nullable', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'NumeroInventario';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero di serie del dispositivo.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'NumeroSerie';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dotazione', @level2type = N'COLUMN', @level2name = N'Note';


GO

