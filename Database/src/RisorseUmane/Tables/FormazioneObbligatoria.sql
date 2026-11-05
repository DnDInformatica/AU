CREATE TABLE [RisorseUmane].[FormazioneObbligatoria] (
    [FormazioneObbligatoriaId]     INT                                                IDENTITY (1, 1) NOT NULL,
    [DipendenteId]                 INT                                                NOT NULL,
    [TipoFormazioneObbligatoriaId] INT                                                NOT NULL,
    [DataCompletamento]            DATE                                               NOT NULL,
    [DataScadenza]                 DATE                                               NULL,
    [EstremiAttestato]             NVARCHAR (200)                                     NULL,
    [EnteFormatore]                NVARCHAR (200)                                     NULL,
    [DurataOreCorso]               INT                                                NULL,
    [Note]                         NVARCHAR (MAX)                                     NULL,
    [DataCreazione]                DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                     INT                                                NULL,
    [DataModifica]                 DATETIME2 (7)                                      NULL,
    [ModificatoDa]                 INT                                                NULL,
    [DataCancellazione]            DATETIME2 (7)                                      NULL,
    [CancellatoDa]                 INT                                                NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]           DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_FormazioneObbligatoria_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]             DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_FormazioneObbligatoria_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_FormazioneObbligatoria] PRIMARY KEY CLUSTERED ([FormazioneObbligatoriaId] ASC),
    CONSTRAINT [CK_FormazioneObbligatoria_Date] CHECK ([DataScadenza] IS NULL OR [DataScadenza]>[DataCompletamento]),
    CONSTRAINT [FK_FormazioneObbligatoria_Dipendente] FOREIGN KEY ([DipendenteId]) REFERENCES [RisorseUmane].[Dipendente] ([DipendenteId]),
    CONSTRAINT [FK_FormazioneObbligatoria_Tipo] FOREIGN KEY ([TipoFormazioneObbligatoriaId]) REFERENCES [Tipologica].[TipoFormazioneObbligatoria] ([TipoFormazioneObbligatoriaId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[RisorseUmane].[FormazioneObbligatoriaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"FormazioneObbligatoria","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"FormazioneObbligatoria","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"FormazioneObbligatoria","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"FormazioneObbligatoria","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane / RSPP', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'FormazioneObbligatoriaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'MASTER', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"FormazioneObbligatoria","column":"DurataOreCorso","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DurataOreCorso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"FormazioneObbligatoria","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'TipoFormazioneObbligatoriaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"FormazioneObbligatoria","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'EstremiAttestato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"FormazioneObbligatoria","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'EnteFormatore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:FormazioneObbligatoria;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'FormazioneObbligatoriaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'risorse-umane,formazione,sicurezza,compliance,scadenze,temporal,audit', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"FormazioneObbligatoria","column":"Note","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:FormazioneObbligatoria;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane / RSPP', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'EnteFormatore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"FormazioneObbligatoria","column":"DataCompletamento","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:FormazioneObbligatoria;Nullable', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane / RSPP', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane / RSPP', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'FormazioneObbligatoriaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Durata in ore del corso completato.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DurataOreCorso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane / RSPP', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane / RSPP', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"FormazioneObbligatoria","column":"DataScadenza","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane / RSPP', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane / RSPP', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DurataOreCorso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane / RSPP', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'TipoFormazioneObbligatoriaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"FormazioneObbligatoria","column":"EstremiAttestato","data_type":"nvarchar","max_length":400,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'EstremiAttestato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane / RSPP', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"FormazioneObbligatoria","column":"EnteFormatore","data_type":"nvarchar","max_length":400,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'EnteFormatore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:FormazioneObbligatoria;Nullable', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'EnteFormatore';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data scadenza validità. NULL se non scade.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{
        "schema":"RisorseUmane",
        "table":"FormazioneObbligatoria",
        "entity":"FormazioneObbligatoria",
        "temporal":true,
        "temporal_type":2,
        "history_table":"RisorseUmane.FormazioneObbligatoriaStorico",
        "soft_delete":true,
        "audit":true,
        "business_rules":{
            "alert_before_expiry_days":30,
            "mandatory_courses_check":true,
            "expiry_calculation":"DataCompletamento + DurataValiditaMesi"
        },
        "reference":"D.Lgs. 81/2008, GDPR, Piano Formativo ACCREDIA"
    }', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane / RSPP', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane / RSPP', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'TipoFormazioneObbligatoriaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane / RSPP', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'FormazioneObbligatoriaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane / RSPP', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:FormazioneObbligatoria;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:FormazioneObbligatoria;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:FormazioneObbligatoria;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento all''attestato (numero, codice).', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'EstremiAttestato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane / RSPP', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:FormazioneObbligatoria;Nullable', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DurataOreCorso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:FormazioneObbligatoria;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:FormazioneObbligatoria;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:FormazioneObbligatoria;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"FormazioneObbligatoria","column":"TipoFormazioneObbligatoriaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.TipoFormazioneObbligatoria.TipoFormazioneObbligatoriaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'TipoFormazioneObbligatoriaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ente che ha erogato la formazione.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'EnteFormatore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane / RSPP', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'EstremiAttestato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:FormazioneObbligatoria;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"FormazioneObbligatoria","column":"FormazioneObbligatoriaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'FormazioneObbligatoriaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"FormazioneObbligatoria","column":"DipendenteId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"RisorseUmane.Dipendente.DipendenteId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:FormazioneObbligatoria;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'EstremiAttestato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:FormazioneObbligatoria;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'TipoFormazioneObbligatoriaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DurataOreCorso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'EnteFormatore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane / RSPP', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogate auto-incrementale.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'FormazioneObbligatoriaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Registro corsi di formazione obbligatoria completati dai dipendenti ACCREDIA.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:FormazioneObbligatoria;Nullable', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Tipologica.TipoFormazioneObbligatoria.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'TipoFormazioneObbligatoriaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso RisorseUmane.Dipendente.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data completamento/superamento del corso.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:FormazioneObbligatoria;Nullable', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'EstremiAttestato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'DurataOreCorso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'FormazioneObbligatoria', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

