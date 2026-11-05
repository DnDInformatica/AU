CREATE TABLE [Standard].[NormaAccreditamentoGerarchia] (
    [NormaAccreditamentoGerarchiaId] INT                                                IDENTITY (1, 1) NOT NULL,
    [PadreId]                        INT                                                NOT NULL,
    [FiglioId]                       INT                                                NOT NULL,
    [Profondita]                     INT                                                NOT NULL,
    [DataCreazione]                  DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                       INT                                                NULL,
    [DataModifica]                   DATETIME2 (7)                                      NULL,
    [ModificatoDa]                   INT                                                NULL,
    [DataCancellazione]              DATETIME2 (7)                                      NULL,
    [CancellatoDa]                   INT                                                NULL,
    [UniqueRowId]                    UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [TipoRelazioneNormaId]           INT                                                NOT NULL,
    [DataInizioValidita]             DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]               DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_NormaAccreditamentoGerarchia] PRIMARY KEY CLUSTERED ([NormaAccreditamentoGerarchiaId] ASC),
    CONSTRAINT [CK_NormaGerarchia_Profondita] CHECK ([Profondita]>=(0)),
    CONSTRAINT [FK_NormaAccreditamentoGerarchia_TipoRelazione] FOREIGN KEY ([TipoRelazioneNormaId]) REFERENCES [Standard].[TipoRelazioneNorma] ([TipoRelazioneNormaId]),
    CONSTRAINT [FK_NormaGerarchia_Figlio] FOREIGN KEY ([FiglioId]) REFERENCES [Standard].[NormaAccreditamento] ([NormaAccreditamentoId]),
    CONSTRAINT [FK_NormaGerarchia_Padre] FOREIGN KEY ([PadreId]) REFERENCES [Standard].[NormaAccreditamento] ([NormaAccreditamentoId]),
    CONSTRAINT [UQ_NormaAccreditamentoGerarchia_Coppia] UNIQUE NONCLUSTERED ([PadreId] ASC, [FiglioId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[NormaAccreditamentoGerarchiaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamentoGerarchia;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamentoGerarchia","column":"NormaAccreditamentoGerarchiaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'NormaAccreditamentoGerarchiaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamentoGerarchia","column":"Profondita","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'Profondita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamentoGerarchia;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'PadreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'FiglioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamentoGerarchia;NotNull', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02-b', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamentoGerarchia","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'NormaAccreditamentoGerarchiaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'Profondita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'NormaAccreditamentoGerarchiaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Distanza in passi tra antenato e discendente: 0=self, 1=successione diretta.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'Profondita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamentoGerarchia","column":"TipoRelazioneNormaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Standard.TipoRelazioneNorma.TipoRelazioneNormaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'TipoRelazioneNormaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamentoGerarchia;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02-b', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02-b', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'FiglioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamentoGerarchia","temporal":true,"history_table":"Standard.NormaAccreditamentoGerarchiaStorico","reference":"Closure Table pattern","business_rules":{"pattern":"closure_table","tipo_relazione_lookup":"Standard.TipoRelazioneNorma","note":"PadreId/FiglioId sostituiscono AntenatoId/DiscendenteId da 2026.02-b"}}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02-b', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'TipoRelazioneNormaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'PadreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'FiglioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamentoGerarchia;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'LOOKUP', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamentoGerarchia","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02-b', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02-b', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02-b', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'PadreId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK alla norma "figlia" nella relazione (versione piÃ¹ recente o norma che rimpiazza). Per la self-reference, FiglioId = PadreId.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'FiglioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamentoGerarchia","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamentoGerarchia;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'TipoRelazioneNormaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Closure Table per la navigazione transitiva delle IDENTITÀ tra norme: una self-row (Profondita=0, tipo ''self'') per ogni norma curata, più link di tipo ''variante'' (variante denominativa: stessa norma reale con denominazione diversa per prefisso UNI/CEI/EN, es. ISO/IEC 17024:2012 -> UNI CEI EN ISO/IEC 17024:2012). Un singolo join espande la canonica a tutte le sue incarnazioni: le righe applicative agganciate alla variante confluiscono automaticamente nella canonica. Le relazioni semantiche SENZA espansione automatica (revisione, sostituzione, corequisito) vivono in NormaAccreditamentoRelazione. Test decisionale: "interrogando la norma A, le righe agganciate a B devono essere incluse automaticamente come se fossero A?" Sì -> qui; No -> Relazione. NB storico: 3 link di tipo ''revisione'' presenti in closure sono un residuo da riallineare (v. bonifica profili PPA).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK alla norma "padre" nella relazione (versione precedente o norma sostituita). Per la self-reference, PadreId = FiglioId.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'PadreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02-b', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamentoGerarchia;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamentoGerarchia","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02-b', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'NormaAccreditamentoGerarchiaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02-b', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'Profondita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamentoGerarchia;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamentoGerarchia;NotNull', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'Profondita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamentoGerarchia","column":"FiglioId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Standard.NormaAccreditamento.NormaAccreditamentoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'FiglioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'TipoRelazioneNormaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamentoGerarchia","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02-b', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02-b', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamentoGerarchia;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'NormaAccreditamentoGerarchiaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamentoGerarchia;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamentoGerarchia","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamentoGerarchia","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamentoGerarchia","column":"PadreId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Standard.NormaAccreditamento.NormaAccreditamentoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'PadreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamentoGerarchia;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'FiglioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'TipoRelazioneNormaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'accreditamento,norme,gerarchia,closure-table,transizione', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02-b', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'NormaAccreditamentoGerarchiaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'Profondita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'PadreId';


GO

