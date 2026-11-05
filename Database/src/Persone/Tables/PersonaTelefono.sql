CREATE TABLE [Persone].[PersonaTelefono] (
    [PersonaTelefonoId]      INT                                                IDENTITY (1, 1) NOT NULL,
    [PersonaId]              INT                                                NOT NULL,
    [TipoTelefonoId]         INT                                                NOT NULL,
    [PrefissoInternazionale] NVARCHAR (10)                                      NULL,
    [Numero]                 NVARCHAR (50)                                      NOT NULL,
    [Estensione]             NVARCHAR (10)                                      NULL,
    [Principale]             BIT                                                DEFAULT ((0)) NOT NULL,
    [Verificato]             BIT                                                DEFAULT ((0)) NOT NULL,
    [DataVerifica]           DATETIME2 (7)                                      NULL,
    [DataCreazione]          DATETIME2 (7)                                      DEFAULT (sysdatetime()) NOT NULL,
    [CreatoDa]               INT                                                NULL,
    [DataModifica]           DATETIME2 (7)                                      NULL,
    [ModificatoDa]           INT                                                NULL,
    [DataCancellazione]      DATETIME2 (7)                                      NULL,
    [CancellatoDa]           INT                                                NULL,
    [UniqueRowId]            UNIQUEIDENTIFIER                                   DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita]     DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_PersonaTelefono] PRIMARY KEY CLUSTERED ([PersonaTelefonoId] ASC),
    CONSTRAINT [CK_PersonaTelefono_Numero_MinLen] CHECK (len(ltrim(rtrim([Numero])))>=(3)),
    CONSTRAINT [CK_PersonaTelefono_Validita] CHECK ([DataFineValidita]>[DataInizioValidita]),
    CONSTRAINT [FK_PersonaTelefono_Persona] FOREIGN KEY ([PersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [FK_PersonaTelefono_TipoTelefono] FOREIGN KEY ([TipoTelefonoId]) REFERENCES [Tipologica].[TipoTelefono] ([TipoTelefonoId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Persone].[PersonaTelefonoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaTelefono;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'PrefissoInternazionale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaTelefono;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Verificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Estensione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'PersonaTelefonoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaTelefono","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'PrefissoInternazionale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaTelefono","column":"Estensione","data_type":"nvarchar","max_length":20,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Estensione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaTelefono;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Verificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'PrefissoInternazionale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaTelefono","column":"PersonaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'persone;anagrafica;audit;compliance', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Verificato';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Numero';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaTelefono;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaTelefono","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'TipoTelefonoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Numero';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaTelefono;PK;Identity;NotNull;PII', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'PersonaTelefonoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaTelefono;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaTelefono;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaTelefono","column":"Principale","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaTelefono","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Numero';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaTelefono","column":"TipoTelefonoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.TipoTelefono.TipoTelefonoId","audit_column":false,"temporal_period_column":false,"pii_class":"PII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'TipoTelefonoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Estensione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaTelefono;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'PersonaTelefonoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Verificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaTelefono;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaTelefono","column":"PersonaTelefonoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"PII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'PersonaTelefonoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaTelefono","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'PrefissoInternazionale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Verificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaTelefono;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Estensione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaTelefono","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaTelefono","column":"PrefissoInternazionale","data_type":"nvarchar","max_length":20,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'PrefissoInternazionale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione tabella da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaTelefono;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Estensione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaTelefono","column":"Verificato","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Verificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaTelefono;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Numero';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ASSOCIAZIONE', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'TipoTelefonoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaTelefono;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaTelefono;FK;NotNull;PII', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'TipoTelefonoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaTelefono","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Numero';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'PersonaTelefonoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaTelefono","column":"Numero","data_type":"nvarchar","max_length":100,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Numero';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'TipoTelefonoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaTelefono;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'PersonaTelefonoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaTelefono","entity":"PersonaTelefono","temporal":true,"temporal_type":2,"history_table":"Persone.PersonaTelefonoStorico","doc":{"ms_description":"MS_Description","extended_doc":"Accredia.Doc","model_note":"Accredia.ModelNote"}}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Principale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaTelefono","column":"DataVerifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'PrefissoInternazionale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaTelefono","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaTelefono;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'Estensione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'TipoTelefonoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaTelefono', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

