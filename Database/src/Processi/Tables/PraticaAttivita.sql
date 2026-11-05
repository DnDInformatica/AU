CREATE TABLE [Processi].[PraticaAttivita] (
    [PraticaAttivitaId]      INT                                                IDENTITY (1, 1) NOT NULL,
    [PraticaId]              INT                                                NOT NULL,
    [TaskId]                 INT                                                NULL,
    [Titolo]                 NVARCHAR (1000)                                    NOT NULL,
    [Descrizione]            NVARCHAR (MAX)                                     NULL,
    [AssegnatoAPersonaId]    INT                                                NULL,
    [TipoRuoloAccrediaId]    INT                                                NULL,
    [DataScadenza]           DATETIME2 (7)                                      NULL,
    [DataCompletamento]      DATETIME2 (7)                                      NULL,
    [DataCreazione]          DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]               INT                                                NULL,
    [DataModifica]           DATETIME2 (7)                                      NULL,
    [ModificatoDa]           INT                                                NULL,
    [DataCancellazione]      DATETIME2 (7)                                      NULL,
    [CancellatoDa]           INT                                                NULL,
    [UniqueRowId]            UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]     DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [EsitoLavorazioneId]     INT                                                NULL,
    [StatoAttivitaPraticaId] INT                                                NOT NULL,
    [TipoAttivitaPraticaId]  INT                                                NOT NULL,
    CONSTRAINT [PK_PraticaAttivita] PRIMARY KEY CLUSTERED ([PraticaAttivitaId] ASC),
    CONSTRAINT [CK_PraticaAttivita_Date] CHECK ([DataCompletamento] IS NULL OR [DataScadenza] IS NULL OR [DataCompletamento]>=[DataScadenza]),
    CONSTRAINT [FK_PraticaAttivita_AssegnatoAPersona] FOREIGN KEY ([AssegnatoAPersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [FK_PraticaAttivita_EsitoLavorazione] FOREIGN KEY ([EsitoLavorazioneId]) REFERENCES [Tipologica].[EsitoLavorazione] ([EsitoLavorazioneId]),
    CONSTRAINT [FK_PraticaAttivita_Pratica] FOREIGN KEY ([PraticaId]) REFERENCES [Processi].[Pratica] ([PraticaId]),
    CONSTRAINT [FK_PraticaAttivita_StatoAttivitaPratica] FOREIGN KEY ([StatoAttivitaPraticaId]) REFERENCES [Tipologica].[StatoAttivitaPratica] ([StatoAttivitaPraticaId]),
    CONSTRAINT [FK_PraticaAttivita_Task] FOREIGN KEY ([TaskId]) REFERENCES [Workflow].[Task] ([TaskId]),
    CONSTRAINT [FK_PraticaAttivita_TipoAttivitaPratica] FOREIGN KEY ([TipoAttivitaPraticaId]) REFERENCES [Tipologica].[TipoAttivitaPratica] ([TipoAttivitaPraticaId]),
    CONSTRAINT [FK_PraticaAttivita_TipoRuoloAccredia] FOREIGN KEY ([TipoRuoloAccrediaId]) REFERENCES [Tipologica].[TipoRuoloAccredia] ([TipoRuoloAccrediaId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Processi].[PraticaAttivitaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_PraticaAttivita_TipoAttivitaPraticaId]
    ON [Processi].[PraticaAttivita]([TipoAttivitaPraticaId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_PraticaAttivita_EsitoLavorazioneId]
    ON [Processi].[PraticaAttivita]([EsitoLavorazioneId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_PraticaAttivita_StatoAttivitaPraticaId]
    ON [Processi].[PraticaAttivita]([StatoAttivitaPraticaId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaAttivita","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaAttivita;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaAttivita;NotNull', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaAttivita;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'TipoRuoloAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'TipoRuoloAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'TipoRuoloAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'PraticaAttivitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaAttivita;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaAttivita","column":"TipoRuoloId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.TipoRuolo.TipoRuoloId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'TipoRuoloAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaAttivita","column":"Titolo","data_type":"nvarchar","max_length":2000,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaAttivita;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'PraticaAttivitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaAttivita","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'TipoRuoloAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaAttivita;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'PraticaAttivitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaAttivita","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaAttivita","column":"DataScadenza","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaAttivita","temporal":true,"temporal_type":2,"history_table":"Processi.PraticaAttivitaStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaAttivita","column":"Descrizione","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaAttivita;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaAttivita","column":"PraticaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Processi.Pratica.PraticaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaAttivita;NotNull', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaAttivita","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Titolo o identificativo descrittivo da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'TipoRuoloAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'processi;attivita;followup;csa', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'AssegnatoAPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaAttivita","column":"TaskId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Workflow.Task.TaskId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione testuale da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaAttivita","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaAttivita","column":"DataCompletamento","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaAttivita;Nullable', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Data di business da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaAttivita;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaAttivita;Nullable', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaAttivita;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaAttivita","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'PraticaAttivitaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'AssegnatoAPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaAttivita","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaAttivita;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaAttivita","column":"PraticaAttivitaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'PraticaAttivitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaAttivita;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'AssegnatoAPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaAttivita;Nullable', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'AssegnatoAPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Data di business da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'PraticaAttivitaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Attivita operative e follow-up collegati a una pratica.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaAttivita","column":"AssegnatoAPersonaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'AssegnatoAPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'AssegnatoAPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaAttivita;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaAttivita', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

