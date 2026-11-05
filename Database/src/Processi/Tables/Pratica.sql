CREATE TABLE [Processi].[Pratica] (
    [PraticaId]                  INT                                                IDENTITY (1, 1) NOT NULL,
    [Codice]                     NVARCHAR (100)                                     NOT NULL,
    [Oggetto]                    NVARCHAR (1000)                                    NOT NULL,
    [Descrizione]                NVARCHAR (MAX)                                     NULL,
    [StatoPraticaId]             TINYINT                                            DEFAULT ((1)) NOT NULL,
    [DipartimentoAccrediaId]     INT                                                NULL,
    [OrganizzazioneId]           INT                                                NULL,
    [PraticaAccreditamentoId]    INT                                                NULL,
    [SchemaAccreditamentoId]     INT                                                NULL,
    [ResponsabilePersonaId]      INT                                                NULL,
    [DataApertura]               DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [DataChiusura]               DATETIME2 (7)                                      NULL,
    [DataCreazione]              DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                   INT                                                NULL,
    [DataModifica]               DATETIME2 (7)                                      NULL,
    [ModificatoDa]               INT                                                NULL,
    [DataCancellazione]          DATETIME2 (7)                                      NULL,
    [CancellatoDa]               INT                                                NULL,
    [UniqueRowId]                UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]         DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]           DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [TipoPraticaProcessoId]      INT                                                NULL,
    [NaturaProceduralePraticaId] INT                                                NOT NULL,
    [PrioritaLavorazioneId]      INT                                                NOT NULL,
    CONSTRAINT [PK_ProcessiPratica] PRIMARY KEY CLUSTERED ([PraticaId] ASC),
    CONSTRAINT [CK_ProcessiPratica_Date] CHECK ([DataChiusura] IS NULL OR [DataChiusura]>=[DataApertura]),
    CONSTRAINT [FK_Pratica_PrioritaLavorazione] FOREIGN KEY ([PrioritaLavorazioneId]) REFERENCES [Tipologica].[PrioritaLavorazione] ([PrioritaLavorazioneId]),
    CONSTRAINT [FK_ProcessiPratica_DipartimentoAccredia] FOREIGN KEY ([DipartimentoAccrediaId]) REFERENCES [Tipologica].[DipartimentoAccredia] ([DipartimentoAccrediaId]),
    CONSTRAINT [FK_ProcessiPratica_NaturaProceduralePratica] FOREIGN KEY ([NaturaProceduralePraticaId]) REFERENCES [Tipologica].[NaturaProceduralePratica] ([NaturaProceduralePraticaId]),
    CONSTRAINT [FK_ProcessiPratica_Organizzazione] FOREIGN KEY ([OrganizzazioneId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId]),
    CONSTRAINT [FK_ProcessiPratica_PraticaAccreditamento] FOREIGN KEY ([PraticaAccreditamentoId]) REFERENCES [Accreditamento].[PraticaAccreditamento] ([PraticaAccreditamentoId]),
    CONSTRAINT [FK_ProcessiPratica_ResponsabilePersona] FOREIGN KEY ([ResponsabilePersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [FK_ProcessiPratica_SchemaAccreditamento] FOREIGN KEY ([SchemaAccreditamentoId]) REFERENCES [Standard].[SchemaAccreditamento] ([SchemaAccreditamentoId]),
    CONSTRAINT [FK_ProcessiPratica_StatoPratica] FOREIGN KEY ([StatoPraticaId]) REFERENCES [Accreditamento].[StatoPratica] ([StatoPraticaId]),
    CONSTRAINT [FK_ProcessiPratica_TipoPraticaProcesso] FOREIGN KEY ([TipoPraticaProcessoId]) REFERENCES [Tipologica].[TipoPraticaProcesso] ([TipoPraticaProcessoId]),
    CONSTRAINT [UQ_ProcessiPratica_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Processi].[PraticaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_Pratica_PrioritaLavorazioneId]
    ON [Processi].[Pratica]([PrioritaLavorazioneId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Pratica;NotNull', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Pratica","column":"PraticaAccreditamentoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Accreditamento.PraticaAccreditamento.PraticaAccreditamentoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'PraticaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'processi;pratiche;csa;kernel', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'StatoPraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'SchemaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'Oggetto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'PraticaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataApertura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Pratica","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataApertura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Pratica","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Pratica;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'SchemaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione testuale da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Pratica","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'Oggetto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'SchemaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Pratica;Nullable', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataChiusura';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Oggetto sintetico della pratica da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'Oggetto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'StatoPraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'PraticaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Pratica","column":"ResponsabilePersonaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'ResponsabilePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Pratica","column":"StatoPraticaId","data_type":"tinyint","max_length":1,"precision":3,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Accreditamento.StatoPratica.StatoPraticaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'StatoPraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Pratica;NotNull', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'Oggetto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'PraticaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Pratica;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'ResponsabilePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Pratica;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Data di business da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataApertura';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Pratica trasversale per processi non specialistici e gestione CSA.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Pratica;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Pratica;NotNull', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataApertura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Pratica;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Pratica","column":"Codice","data_type":"nvarchar","max_length":200,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Pratica;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'ResponsabilePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Pratica","temporal":true,"temporal_type":2,"history_table":"Processi.PraticaStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'SchemaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataChiusura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Pratica;NotNull', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataChiusura';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'PraticaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Pratica","column":"Descrizione","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Pratica;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'StatoPraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Pratica","column":"PraticaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Pratica","column":"OrganizzazioneId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Organizzazioni.Organizzazione.OrganizzazioneId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'ResponsabilePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Pratica","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Pratica","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'ResponsabilePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'StatoPraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Pratica","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Pratica","column":"DataChiusura","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataChiusura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Pratica;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'PraticaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Pratica;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Pratica","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Pratica","column":"Oggetto","data_type":"nvarchar","max_length":2000,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'Oggetto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Pratica","column":"DataApertura","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataApertura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Pratica","column":"DipartimentoAccrediaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.DipartimentoAccredia.DipartimentoAccrediaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Data di business da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataChiusura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataApertura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'Oggetto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'SchemaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Pratica;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Pratica","column":"SchemaAccreditamentoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Standard.SchemaAccreditamento.SchemaAccreditamentoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'SchemaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Pratica;Nullable', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DataChiusura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Pratica;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Pratica;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Pratica;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'StatoPraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Codice univoco identificativo da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Pratica', @level2type = N'COLUMN', @level2name = N'ResponsabilePersonaId';


GO

