CREATE TABLE [Accreditamento].[OrganizzazioneEnteAccreditamento] (
    [OrganizzazioneEnteAccreditamentoId] INT                                                IDENTITY (1, 1) NOT NULL,
    [OrganizzazioneId]                   INT                                                NOT NULL,
    [EnteAccreditamentoId]               INT                                                NOT NULL,
    [TipoRelazione]                      NVARCHAR (30)                                      NOT NULL,
    [DataInizioRelazione]                DATE                                               NULL,
    [DataFineRelazione]                  DATE                                               NULL,
    [Note]                               NVARCHAR (500)                                     NULL,
    [DataCreazione]                      DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                           INT                                                NULL,
    [DataModifica]                       DATETIME2 (7)                                      NULL,
    [ModificatoDa]                       INT                                                NULL,
    [DataCancellazione]                  DATETIME2 (7)                                      NULL,
    [CancellatoDa]                       INT                                                NULL,
    [UniqueRowId]                        UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                 DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]                   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_OrganizzazioneEnteAccreditamento] PRIMARY KEY CLUSTERED ([OrganizzazioneEnteAccreditamentoId] ASC),
    CONSTRAINT [CK_OrgEA_DataFine] CHECK ([DataFineRelazione] IS NULL OR [DataFineRelazione]>[DataInizioRelazione]),
    CONSTRAINT [CK_OrgEA_TipoRelazione] CHECK ([TipoRelazione]='ACCREDITATA_DA' OR [TipoRelazione]='E_ENTE_ACCREDITAMENTO'),
    CONSTRAINT [FK_OrgEA_EnteAccreditamento] FOREIGN KEY ([EnteAccreditamentoId]) REFERENCES [Accreditamento].[EnteAccreditamento] ([EnteAccreditamentoId]),
    CONSTRAINT [FK_OrgEA_Organizzazione] FOREIGN KEY ([OrganizzazioneId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId]),
    CONSTRAINT [UQ_OrgEA_Org_EA_Tipo] UNIQUE NONCLUSTERED ([OrganizzazioneId] ASC, [EnteAccreditamentoId] ASC, [TipoRelazione] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Accreditamento].[OrganizzazioneEnteAccreditamentoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"OrganizzazioneEnteAccreditamento","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'TipoRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:OrganizzazioneEnteAccreditamento;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'TipoRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"OrganizzazioneEnteAccreditamento","column":"Note","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"OrganizzazioneEnteAccreditamento","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataFineRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:OrganizzazioneEnteAccreditamento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tabella dominio Accreditamento con gestione audit, soft-delete e system-versioning dove previsto.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'OrganizzazioneEnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:OrganizzazioneEnteAccreditamento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"OrganizzazioneEnteAccreditamento","column":"OrganizzazioneId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Organizzazioni.Organizzazione.OrganizzazioneId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataFineRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note e annotazioni operative.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataInizioRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"OrganizzazioneEnteAccreditamento","column":"TipoRelazione","data_type":"nvarchar","max_length":60,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'TipoRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"OrganizzazioneEnteAccreditamento","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"OrganizzazioneEnteAccreditamento","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso l''organizzazione collegata a un ente di accreditamento. Serve a rappresentare relazioni istituzionali, non il singolo accreditamento/scopo.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:OrganizzazioneEnteAccreditamento;Nullable', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataFineRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:OrganizzazioneEnteAccreditamento;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'OrganizzazioneEnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'OrganizzazioneEnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"OrganizzazioneEnteAccreditamento","column":"DataFineRelazione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataFineRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo di relazione fra organizzazione ed ente di accreditamento. Da tipizzare se usato per autorizzazioni o workflow.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'TipoRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataInizioRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'TipoRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data fine della relazione fra organizzazione ed ente.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataFineRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:OrganizzazioneEnteAccreditamento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:OrganizzazioneEnteAccreditamento;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:OrganizzazioneEnteAccreditamento;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco del record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'OrganizzazioneEnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"OrganizzazioneEnteAccreditamento","column":"OrganizzazioneEnteAccreditamentoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'OrganizzazioneEnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:OrganizzazioneEnteAccreditamento;Nullable', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataInizioRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"OrganizzazioneEnteAccreditamento","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataInizioRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:OrganizzazioneEnteAccreditamento;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ASSOCIAZIONE', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"OrganizzazioneEnteAccreditamento","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:OrganizzazioneEnteAccreditamento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'TipoRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"OrganizzazioneEnteAccreditamento","column":"EnteAccreditamentoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Accreditamento.EnteAccreditamento.EnteAccreditamentoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataFineRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso l''ente di accreditamento nella relazione con l''organizzazione.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"OrganizzazioneEnteAccreditamento","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data inizio della relazione fra organizzazione ed ente.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataInizioRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'OrganizzazioneEnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:OrganizzazioneEnteAccreditamento;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:OrganizzazioneEnteAccreditamento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"OrganizzazioneEnteAccreditamento","temporal":true,"temporal_type":2,"history_table":"Accreditamento.OrganizzazioneEnteAccreditamentoStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record (GUID tecnico).', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"OrganizzazioneEnteAccreditamento","column":"DataInizioRelazione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'DataInizioRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:OrganizzazioneEnteAccreditamento;Nullable', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'OrganizzazioneEnteAccreditamento', @level2type = N'COLUMN', @level2name = N'Note';


GO

