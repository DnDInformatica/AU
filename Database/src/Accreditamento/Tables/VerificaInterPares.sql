CREATE TABLE [Accreditamento].[VerificaInterPares] (
    [VerificaInterParesId]         INT                                                IDENTITY (1, 1) NOT NULL,
    [EnteAccreditamentoValutatoId] INT                                                NOT NULL,
    [TipoVerifica]                 NVARCHAR (30)                                      NOT NULL,
    [DataInizio]                   DATE                                               NOT NULL,
    [DataFine]                     DATE                                               NULL,
    [OrganoDeliberante]            NVARCHAR (100)                                     DEFAULT (N'EA MAC') NOT NULL,
    [DataDecisione]                DATE                                               NULL,
    [EsitoDecisione]               NVARCHAR (50)                                      NULL,
    [DataProssimaVerifica]         DATE                                               NULL,
    [Note]                         NVARCHAR (MAX)                                     NULL,
    [DataCreazione]                DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                     INT                                                NULL,
    [DataModifica]                 DATETIME2 (7)                                      NULL,
    [ModificatoDa]                 INT                                                NULL,
    [DataCancellazione]            DATETIME2 (7)                                      NULL,
    [CancellatoDa]                 INT                                                NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]           DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]             DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_VerificaInterPares] PRIMARY KEY CLUSTERED ([VerificaInterParesId] ASC),
    CONSTRAINT [CK_VerificaInterPares_DataDec] CHECK ([DataDecisione] IS NULL OR [DataDecisione]>=[DataInizio]),
    CONSTRAINT [CK_VerificaInterPares_DataFine] CHECK ([DataFine] IS NULL OR [DataFine]>=[DataInizio]),
    CONSTRAINT [CK_VerificaInterPares_Esito] CHECK ([EsitoDecisione] IS NULL OR ([EsitoDecisione]='NEGATIVO' OR [EsitoDecisione]='SOSPESO' OR [EsitoDecisione]='CONFERMATO_CON_AZIONI' OR [EsitoDecisione]='CONFERMATO' OR [EsitoDecisione]='IN_CORSO')),
    CONSTRAINT [CK_VerificaInterPares_TipoVerifica] CHECK ([TipoVerifica]='WITNESS_AUDIT' OR [TipoVerifica]='FOLLOW_UP' OR [TipoVerifica]='FULL_EVALUATION'),
    CONSTRAINT [FK_VerificaInterPares_EA] FOREIGN KEY ([EnteAccreditamentoValutatoId]) REFERENCES [Accreditamento].[EnteAccreditamento] ([EnteAccreditamentoId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Accreditamento].[VerificaInterParesStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"VerificaInterPares","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:VerificaInterPares;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo di dominio TipoVerifica.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'TipoVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"VerificaInterPares","column":"DataProssimaVerifica","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataProssimaVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataDecisione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'TipoVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note e annotazioni operative.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:VerificaInterPares;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'VerificaInterParesId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"VerificaInterPares","column":"Note","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data rilevante per il processo di accreditamento.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'EsitoDecisione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"VerificaInterPares","column":"VerificaInterParesId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'VerificaInterParesId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:VerificaInterPares;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataDecisione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:VerificaInterPares;Nullable', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataProssimaVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data rilevante per il processo di accreditamento.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataProssimaVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:VerificaInterPares;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'TipoVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo di dominio OrganoDeliberante.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'OrganoDeliberante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:VerificaInterPares;Nullable', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"VerificaInterPares","column":"TipoVerifica","data_type":"nvarchar","max_length":60,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'TipoVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"VerificaInterPares","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:VerificaInterPares;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoValutatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'OrganoDeliberante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"VerificaInterPares","column":"EnteAccreditamentoValutatoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Accreditamento.EnteAccreditamento.EnteAccreditamentoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoValutatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'EsitoDecisione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"VerificaInterPares","temporal":true,"temporal_type":2,"history_table":"Accreditamento.VerificaInterParesStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataProssimaVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:VerificaInterPares;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:VerificaInterPares;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"VerificaInterPares","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataDecisione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"VerificaInterPares","column":"DataInizio","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"VerificaInterPares","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoValutatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"VerificaInterPares","column":"OrganoDeliberante","data_type":"nvarchar","max_length":200,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'OrganoDeliberante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"VerificaInterPares","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoValutatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'EsitoDecisione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'VerificaInterParesId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:VerificaInterPares;Nullable', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"VerificaInterPares","column":"DataFine","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data rilevante per il processo di accreditamento.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataDecisione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'MASTER', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:VerificaInterPares;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'VerificaInterParesId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:VerificaInterPares;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataProssimaVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"VerificaInterPares","column":"DataDecisione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataDecisione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:VerificaInterPares;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record (GUID tecnico).', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo di dominio EsitoDecisione.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'EsitoDecisione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:VerificaInterPares;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'OrganoDeliberante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'TipoVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'TipoVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"VerificaInterPares","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Valutazione inter pares (peer assessment) condotta da EA su un ente di accreditamento. Riferimento normativo europeo: Reg. CE 765/2008 artt. 10–11 — gli EA membri di EA sono soggetti a peer assessment periodico come condizione per mantenere il riconoscimento e la partecipazione ai MLA; il ciclo è tipicamente quadriennale. EA-2/13 — procedura EA per il peer assessment. Fonda la legittimità del valore dei certificati emessi dagli OdC accreditati da ACCREDIA nel mercato interno UE.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'VerificaInterParesId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:VerificaInterPares;Nullable', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataDecisione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data rilevante per il processo di accreditamento.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataProssimaVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:VerificaInterPares;Nullable', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'EsitoDecisione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'OrganoDeliberante';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Accreditamento.EnteAccreditamento.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoValutatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:VerificaInterPares;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoValutatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'OrganoDeliberante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"VerificaInterPares","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"VerificaInterPares","column":"EsitoDecisione","data_type":"nvarchar","max_length":100,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'EsitoDecisione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco del record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'VerificaInterPares', @level2type = N'COLUMN', @level2name = N'VerificaInterParesId';


GO

