CREATE TABLE [Persone].[PersonaUtente] (
    [PersonaUtenteId]    INT                                                IDENTITY (1, 1) NOT NULL,
    [PersonaId]          INT                                                NOT NULL,
    [UserId]             NVARCHAR (450)                                     NOT NULL,
    [DataCreazione]      DATETIME2 (7)                                      DEFAULT (sysdatetime()) NOT NULL,
    [CreatoDa]           INT                                                NULL,
    [DataModifica]       DATETIME2 (7)                                      NULL,
    [ModificatoDa]       INT                                                NULL,
    [DataCancellazione]  DATETIME2 (7)                                      NULL,
    [CancellatoDa]       INT                                                NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER                                   DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_PersonaUtente] PRIMARY KEY CLUSTERED ([PersonaUtenteId] ASC),
    CONSTRAINT [CK_PersonaUtente_Validita] CHECK ([DataFineValidita]>[DataInizioValidita]),
    CONSTRAINT [FK_PersonaUtente_Persona] FOREIGN KEY ([PersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Persone].[PersonaUtenteStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaUtente","column":"PersonaUtenteId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'PersonaUtenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaUtente;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaUtente","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaUtente;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaUtente","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'UserId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'PersonaUtenteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'PersonaUtenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaUtente;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'UserId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaUtente","entity":"PersonaUtente","temporal":true,"temporal_type":2,"history_table":"Persone.PersonaUtenteStorico","doc":{"ms_description":"MS_Description","extended_doc":"Accredia.Doc","model_note":"Accredia.ModelNote"}}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaUtente","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaUtente","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ASSOCIAZIONE', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaUtente;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione tabella da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'UserId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaUtente","column":"UserId","data_type":"nvarchar","max_length":900,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'UserId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'PersonaUtenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'UserId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaUtente;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'PersonaUtenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'UserId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaUtente","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaUtente;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaUtente;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaUtente","column":"PersonaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaUtente","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'persone;anagrafica;audit;compliance', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaUtente;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"PersonaUtente","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaUtente;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:PersonaUtente;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'PersonaUtente', @level2type = N'COLUMN', @level2name = N'PersonaUtenteId';


GO

