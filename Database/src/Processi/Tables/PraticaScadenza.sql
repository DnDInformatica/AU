CREATE TABLE [Processi].[PraticaScadenza] (
    [PraticaScadenzaId]       INT                                                IDENTITY (1, 1) NOT NULL,
    [PraticaId]               INT                                                NULL,
    [DataScadenza]            DATETIME2 (7)                                      NOT NULL,
    [IsBloccante]             BIT                                                DEFAULT ((0)) NOT NULL,
    [Note]                    NVARCHAR (2000)                                    NULL,
    [DataCreazione]           DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                INT                                                NULL,
    [DataModifica]            DATETIME2 (7)                                      NULL,
    [ModificatoDa]            INT                                                NULL,
    [DataCancellazione]       DATETIME2 (7)                                      NULL,
    [CancellatoDa]            INT                                                NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]      DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]        DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [PraticaAccreditamentoId] INT                                                NULL,
    [StatoScadenzaPraticaId]  INT                                                NOT NULL,
    [TipoScadenzaPraticaId]   INT                                                NOT NULL,
    CONSTRAINT [PK_PraticaScadenza] PRIMARY KEY CLUSTERED ([PraticaScadenzaId] ASC),
    CONSTRAINT [CK_PraticaScadenza_Riferimento] CHECK ([PraticaId] IS NOT NULL AND [PraticaAccreditamentoId] IS NULL OR [PraticaId] IS NULL AND [PraticaAccreditamentoId] IS NOT NULL),
    CONSTRAINT [FK_PraticaScadenza_Pratica] FOREIGN KEY ([PraticaId]) REFERENCES [Processi].[Pratica] ([PraticaId]),
    CONSTRAINT [FK_PraticaScadenza_PraticaAccreditamento] FOREIGN KEY ([PraticaAccreditamentoId]) REFERENCES [Accreditamento].[PraticaAccreditamento] ([PraticaAccreditamentoId]),
    CONSTRAINT [FK_PraticaScadenza_StatoScadenzaPratica] FOREIGN KEY ([StatoScadenzaPraticaId]) REFERENCES [Tipologica].[StatoScadenzaPratica] ([StatoScadenzaPraticaId]),
    CONSTRAINT [FK_PraticaScadenza_TipoScadenzaPratica] FOREIGN KEY ([TipoScadenzaPraticaId]) REFERENCES [Tipologica].[TipoScadenzaPratica] ([TipoScadenzaPraticaId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Processi].[PraticaScadenzaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_PraticaScadenza_StatoScadenzaPraticaId]
    ON [Processi].[PraticaScadenza]([StatoScadenzaPraticaId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_PraticaScadenza_TipoScadenzaPraticaId]
    ON [Processi].[PraticaScadenza]([TipoScadenzaPraticaId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaScadenza","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaScadenza;NotNull', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaScadenza","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Collegamento alternativo a Pratica (mutuamente esclusivo, CK_PraticaScadenza_Riferimento): usato per TipoScadenza=SCADENZA_CICLO, l''avviso di scadenza del ciclo di accreditamento calcolato su Accreditamento.PraticaAccreditamento.DataScadenza. Esiste PRIMA che una Processi.Pratica di rinnovo venga aperta - è l''innesco del workflow RINNOVO, non una scadenza procedurale interna a un caso già aperto (quelle usano PraticaId).', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'PraticaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaScadenza;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaScadenza","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaScadenza;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaScadenza","column":"Note","data_type":"nvarchar","max_length":4000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Note e annotazioni libere da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaScadenza;Nullable', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaScadenza;NotNull', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'IsBloccante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'IsBloccante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Flag booleano da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'IsBloccante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaScadenza","temporal":true,"temporal_type":2,"history_table":"Processi.PraticaScadenzaStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaScadenza;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaScadenza","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaScadenza;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaScadenza","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaScadenza;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaScadenza","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaScadenza","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaScadenza;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'PraticaScadenzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaScadenza;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'PraticaScadenzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'PraticaScadenzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaScadenza","column":"PraticaScadenzaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'PraticaScadenzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'PraticaScadenzaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Scadenze tipizzate collegate a una pratica.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'PraticaScadenzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'processi;scadenze;alert;csa', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'IsBloccante';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Data di business da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'IsBloccante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaScadenza","column":"IsBloccante","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'IsBloccante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaScadenza","column":"DataScadenza","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaScadenza;NotNull', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:PraticaScadenza;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"PraticaScadenza","column":"PraticaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Processi.Pratica.PraticaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'PraticaScadenza', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

