CREATE TABLE [Ispettori].[GruppoVerifica] (
    [GruppoVerificaId]       INT                                                IDENTITY (1, 1) NOT NULL,
    [VisitaIspettivaId]      INT                                                NULL,
    [OrganismoAccreditatoId] INT                                                NOT NULL,
    [DipartimentoAccrediaId] INT                                                NOT NULL,
    [CodiceGruppo]           NVARCHAR (50)                                      NOT NULL,
    [DataCostituzione]       DATE                                               NOT NULL,
    [DataVerifica]           DATE                                               NULL,
    [DataFineVerifica]       DATE                                               NULL,
    [TipoVerifica]           NVARCHAR (50)                                      NOT NULL,
    [ModalitaVerifica]       NVARCHAR (50)                                      DEFAULT ('IN_SEDE') NOT NULL,
    [TeamLeaderId]           INT                                                NOT NULL,
    [StatoGruppo]            NVARCHAR (20)                                      DEFAULT ('COSTITUITO') NOT NULL,
    [ConflittiVerificati]    BIT                                                DEFAULT ((0)) NOT NULL,
    [DataVerificaConflitti]  DATETIME2 (7)                                      NULL,
    [VerificaConflittiDa]    INT                                                NULL,
    [Note]                   NVARCHAR (MAX)                                     NULL,
    [NoteInterne]            NVARCHAR (MAX)                                     NULL,
    [DataCreazione]          DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]               INT                                                NULL,
    [DataModifica]           DATETIME2 (7)                                      NULL,
    [ModificatoDa]           INT                                                NULL,
    [DataCancellazione]      DATETIME2 (7)                                      NULL,
    [CancellatoDa]           INT                                                NULL,
    [UniqueRowId]            UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]     DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_GruppoVerifica] PRIMARY KEY CLUSTERED ([GruppoVerificaId] ASC),
    CONSTRAINT [CK_GruppoVerifica_Modalita] CHECK ([ModalitaVerifica]='ACCOMPAGNAMENTO' OR [ModalitaVerifica]='MISTA' OR [ModalitaVerifica]='REMOTO' OR [ModalitaVerifica]='IN_SEDE'),
    CONSTRAINT [CK_GruppoVerifica_Stato] CHECK ([StatoGruppo]='ANNULLATO' OR [StatoGruppo]='COMPLETATO' OR [StatoGruppo]='IN_CORSO' OR [StatoGruppo]='CONFERMATO' OR [StatoGruppo]='COSTITUITO'),
    CONSTRAINT [CK_GruppoVerifica_TipoVerifica] CHECK ([TipoVerifica]='STRAORDINARIA' OR [TipoVerifica]='ESTENSIONE' OR [TipoVerifica]='RINNOVO' OR [TipoVerifica]='SORVEGLIANZA' OR [TipoVerifica]='PRIMO_ACCREDITAMENTO'),
    CONSTRAINT [FK_GruppoVerifica_Dipartimento] FOREIGN KEY ([DipartimentoAccrediaId]) REFERENCES [Tipologica].[DipartimentoAccredia] ([DipartimentoAccrediaId]),
    CONSTRAINT [FK_GruppoVerifica_TeamLeader] FOREIGN KEY ([TeamLeaderId]) REFERENCES [Ispettori].[Ispettore] ([IspettoreId]),
    CONSTRAINT [UQ_GruppoVerifica_Codice] UNIQUE NONCLUSTERED ([CodiceGruppo] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Ispettori].[GruppoVerificaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'TipoVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'OrganismoAccreditatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"TeamLeaderId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Ispettori.Ispettore.IspettoreId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'TeamLeaderId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"VisitaIspettivaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'VisitaIspettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataVerificaConflitti';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataCostituzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"Note","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataFineVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'StatoGruppo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'CodiceGruppo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'TeamLeaderId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'TipoVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'OrganismoAccreditatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'VisitaIspettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataVerificaConflitti';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'GruppoVerificaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataCostituzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"DataFineVerifica","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataFineVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'ConflittiVerificati';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"CodiceGruppo","data_type":"nvarchar","max_length":100,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'CodiceGruppo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'ModalitaVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"TipoVerifica","data_type":"nvarchar","max_length":100,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'TipoVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"DataCostituzione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataCostituzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"DataVerificaConflitti","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataVerificaConflitti';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataVerificaConflitti';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'VerificaConflittiDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'GruppoVerificaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"OrganismoAccreditatoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'OrganismoAccreditatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'StatoGruppo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'NoteInterne';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'TeamLeaderId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'TipoVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'VisitaIspettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataCostituzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataVerificaConflitti';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'NoteInterne';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'OrganismoAccreditatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'StatoGruppo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'ModalitaVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'VerificaConflittiDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'CodiceGruppo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"NoteInterne","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'NoteInterne';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"DataVerifica","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'VisitaIspettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'GruppoVerificaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'ConflittiVerificati';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'StatoGruppo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataFineVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'ModalitaVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'NoteInterne';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataCostituzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'ConflittiVerificati';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'GruppoVerificaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'OrganismoAccreditatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'TipoVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"StatoGruppo","data_type":"nvarchar","max_length":40,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'StatoGruppo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'VerificaConflittiDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'ModalitaVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'TeamLeaderId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'VerificaConflittiDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'VisitaIspettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"GruppoVerificaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'GruppoVerificaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"ConflittiVerificati","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'ConflittiVerificati';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'CodiceGruppo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataFineVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"VerificaConflittiDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'VerificaConflittiDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"ModalitaVerifica","data_type":"nvarchar","max_length":100,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'ModalitaVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'CodiceGruppo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'NoteInterne';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","column":"DipartimentoAccrediaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.DipartimentoAccredia.DipartimentoAccrediaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"GruppoVerifica","temporal":true,"temporal_type":2,"history_table":"Ispettori.GruppoVerificaStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'ConflittiVerificati';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:GruppoVerifica;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'TeamLeaderId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'GruppoVerifica', @level2type = N'COLUMN', @level2name = N'DataFineVerifica';


GO

