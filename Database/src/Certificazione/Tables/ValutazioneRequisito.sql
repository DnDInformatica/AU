CREATE TABLE [Certificazione].[ValutazioneRequisito] (
    [ValutazioneRequisitoId]          INT                                                IDENTITY (1, 1) NOT NULL,
    [CertificazioneId]                INT                                                NOT NULL,
    [ProgrammaRequisitoId]            INT                                                NOT NULL,
    [TipoEsitoValutazioneRequisitoId] INT                                                NOT NULL,
    [WorkflowIstanzaId]               INT                                                NULL,
    [TaskId]                          INT                                                NULL,
    [DeliberaId]                      INT                                                NULL,
    [ProgressivoValutazione]          SMALLINT                                           DEFAULT ((1)) NOT NULL,
    [DataValutazione]                 DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [ValutatoDa]                      INT                                                NULL,
    [CommentoValutazione]             NVARCHAR (MAX)                                     NULL,
    [MotivazioneNonApplicabilita]     NVARCHAR (MAX)                                     NULL,
    [RichiedeAzioneCorrettiva]        BIT                                                DEFAULT ((0)) NOT NULL,
    [Punteggio]                       DECIMAL (9, 2)                                     NULL,
    [Peso]                            DECIMAL (9, 2)                                     NULL,
    [Attivo]                          BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]                   DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                        INT                                                NULL,
    [DataModifica]                    DATETIME2 (7)                                      NULL,
    [ModificatoDa]                    INT                                                NULL,
    [DataCancellazione]               DATETIME2 (7)                                      NULL,
    [CancellatoDa]                    INT                                                NULL,
    [UniqueRowId]                     UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]              DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]                DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_ValutazioneRequisito] PRIMARY KEY CLUSTERED ([ValutazioneRequisitoId] ASC),
    CONSTRAINT [CK_ValutazioneRequisito_Peso] CHECK ([Peso] IS NULL OR [Peso]>=(0)),
    CONSTRAINT [CK_ValutazioneRequisito_ProgressivoValutazione] CHECK ([ProgressivoValutazione]>(0)),
    CONSTRAINT [CK_ValutazioneRequisito_Punteggio] CHECK ([Punteggio] IS NULL OR [Punteggio]>=(0)),
    CONSTRAINT [FK_ValutazioneRequisito_Certificazione] FOREIGN KEY ([CertificazioneId]) REFERENCES [Certificazione].[Certificazione] ([CertificazioneId]),
    CONSTRAINT [FK_ValutazioneRequisito_Delibera] FOREIGN KEY ([DeliberaId]) REFERENCES [Processi].[Delibera] ([DeliberaId]),
    CONSTRAINT [FK_ValutazioneRequisito_ProgrammaRequisito] FOREIGN KEY ([ProgrammaRequisitoId]) REFERENCES [Certificazione].[ProgrammaRequisito] ([ProgrammaRequisitoId]),
    CONSTRAINT [FK_ValutazioneRequisito_Task] FOREIGN KEY ([TaskId]) REFERENCES [Workflow].[Task] ([TaskId]),
    CONSTRAINT [FK_ValutazioneRequisito_TipoEsitoValutazioneRequisito] FOREIGN KEY ([TipoEsitoValutazioneRequisitoId]) REFERENCES [Certificazione].[TipoEsitoValutazioneRequisito] ([TipoEsitoValutazioneRequisitoId]),
    CONSTRAINT [FK_ValutazioneRequisito_WorkflowIstanza] FOREIGN KEY ([WorkflowIstanzaId]) REFERENCES [Workflow].[WorkflowIstanza] ([WorkflowIstanzaId]),
    CONSTRAINT [UQ_ValutazioneRequisito_Cert_Requisito_Workflow_Progressivo] UNIQUE NONCLUSTERED ([CertificazioneId] ASC, [ProgrammaRequisitoId] ASC, [WorkflowIstanzaId] ASC, [ProgressivoValutazione] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Certificazione].[ValutazioneRequisitoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'ProgrammaRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di completamento della valutazione del requisito da parte del valutatore.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataValutazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ValutazioneRequisito","column":"ValutazioneRequisitoId","data_type":"int","max_length":4,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'ValutazioneRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:ValutazioneRequisito;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'TipoEsitoValutazioneRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso il workflow all interno del quale è avvenuta la valutazione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:ValutazioneRequisito;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'RichiedeAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:ValutazioneRequisito;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'Punteggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:ValutazioneRequisito;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'Peso';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Progressivo della valutazione del medesimo requisito all’interno della stessa certificazione e istanza workflow. Consente riesami, rivalutazioni, verifiche successive o chiusure a seguito di azioni correttive.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'ProgressivoValutazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Commento libero del valutatore sull esito della verifica del requisito.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CommentoValutazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:ValutazioneRequisito;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ValutazioneRequisito","temporal":true,"temporal_type":2,"history_table":"Certificazione.ValutazioneRequisitoStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'TipoEsitoValutazioneRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ValutazioneRequisito","column":"CancellatoDa","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'ProgrammaRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ValutazioneRequisito","column":"CertificazioneId","data_type":"int","max_length":4,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Certificazione.Certificazione.CertificazioneId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'RichiedeAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:ValutazioneRequisito;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'ValutazioneRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'Punteggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'Peso';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso la delibera associata alla valutazione, se la valutazione è stata ratificata formalmente.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:ValutazioneRequisito;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CommentoValutazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso il task specifico del workflow durante il quale è stata effettuata la valutazione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ValutazioneRequisito","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Motivazione della non applicabilità del requisito, da valorizzare quando l’esito è NON_APPLICABILE.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'MotivazioneNonApplicabilita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Peso del requisito nel calcolo del punteggio complessivo. Nullable per sistemi pass/fail.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'Peso';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se la valutazione richiede la definizione di un azione correttiva. Default 0. Automaticamente 1 per esito NON_CONFORME su requisiti obbligatori.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'RichiedeAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:ValutazioneRequisito;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Certificazione.ProgrammaRequisito. Requisito del programma oggetto di valutazione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'ProgrammaRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:ValutazioneRequisito;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ValutazioneRequisito","column":"DeliberaId","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:ValutazioneRequisito;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'ValutazioneRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CommentoValutazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:ValutazioneRequisito;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:ValutazioneRequisito;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'ProgrammaRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto che ha effettuato la valutazione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'ValutatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'ValutazioneRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Certificazione.TipoEsitoValutazioneRequisito. Esito: CONFORME, NON_CONFORME, NON_APPLICABILE, IN_VALUTAZIONE.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'TipoEsitoValutazioneRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:ValutazioneRequisito;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Punteggio numerico assegnato alla valutazione, per programmi con sistemi di scoring. Nullable per valutazioni pass/fail senza punteggio.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'Punteggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataValutazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete). Filtrare con WHERE DataCancellazione IS NULL per i record attivi.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:ValutazioneRequisito;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataValutazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ValutazioneRequisito","column":"Peso","data_type":"decimal","max_length":9,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'Peso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ValutazioneRequisito","column":"Punteggio","data_type":"decimal","max_length":9,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'Punteggio';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ValutazioneRequisito","column":"CreatoDa","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ValutazioneRequisito","column":"RichiedeAzioneCorrettiva","data_type":"bit","max_length":1,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'RichiedeAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'ProgrammaRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ValutazioneRequisito","column":"DataCreazione","data_type":"datetime2","max_length":8,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogate.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'ValutazioneRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ValutazioneRequisito","column":"TipoEsitoValutazioneRequisitoId","data_type":"int","max_length":4,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Certificazione.TipoEsitoValutazioneRequisito.TipoEsitoValutazioneRequisitoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'TipoEsitoValutazioneRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ValutazioneRequisito","column":"TaskId","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ValutazioneRequisito","column":"DataValutazione","data_type":"datetime2","max_length":8,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataValutazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato l ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:ValutazioneRequisito;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'Peso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'Punteggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'TipoEsitoValutazioneRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:ValutazioneRequisito;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'ValutazioneRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Certificazione.Certificazione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'RichiedeAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ValutazioneRequisito","column":"CommentoValutazione","data_type":"nvarchar","max_length":-1,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CommentoValutazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ValutazioneRequisito","column":"WorkflowIstanzaId","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'RichiedeAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Valutazione di un requisito di programma nel contesto di un certificato specifico e di una istanza workflow. Ogni record registra l esito della valutazione (CONFORME, NON_CONFORME, NON_APPLICABILE), punteggio, peso, commento e riferimento alla delibera. È il livello atomico del processo valutativo: da qui nascono le NonConformita. Temporal table.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:ValutazioneRequisito;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'Punteggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CommentoValutazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ValutazioneRequisito","column":"DataCancellazione","data_type":"datetime2","max_length":8,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:ValutazioneRequisito;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:ValutazioneRequisito;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataValutazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CommentoValutazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'TaskId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ValutazioneRequisito","column":"DataModifica","data_type":"datetime2","max_length":8,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'DataValutazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ValutazioneRequisito","column":"ProgrammaRequisitoId","data_type":"int","max_length":4,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Certificazione.ProgrammaRequisito.ProgrammaRequisitoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'ProgrammaRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'Peso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'TipoEsitoValutazioneRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record (GUID). Usato per tracciamento tecnico e integrazioni API.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ValutazioneRequisito","column":"ModificatoDa","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ValutazioneRequisito', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

