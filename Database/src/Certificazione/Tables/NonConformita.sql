CREATE TABLE [Certificazione].[NonConformita] (
    [NonConformitaId]         INT                                                IDENTITY (1, 1) NOT NULL,
    [ValutazioneRequisitoId]  INT                                                NOT NULL,
    [TipoNonConformitaId]     INT                                                NOT NULL,
    [StatoNonConformitaId]    INT                                                NOT NULL,
    [CodiceNonConformita]     NVARCHAR (50)                                      NOT NULL,
    [Titolo]                  NVARCHAR (255)                                     NOT NULL,
    [Descrizione]             NVARCHAR (MAX)                                     NOT NULL,
    [DataRilevazione]         DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [RilevataDa]              INT                                                NULL,
    [DataScadenzaTrattamento] DATE                                               NULL,
    [DataChiusura]            DATETIME2 (7)                                      NULL,
    [ChiusaDa]                INT                                                NULL,
    [CausaRadice]             NVARCHAR (MAX)                                     NULL,
    [TrattamentoImmediato]    NVARCHAR (MAX)                                     NULL,
    [VerificaEfficacia]       NVARCHAR (MAX)                                     NULL,
    [Attivo]                  BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]           DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                INT                                                NULL,
    [DataModifica]            DATETIME2 (7)                                      NULL,
    [ModificatoDa]            INT                                                NULL,
    [DataCancellazione]       DATETIME2 (7)                                      NULL,
    [CancellatoDa]            INT                                                NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]      DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]        DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_NonConformita] PRIMARY KEY CLUSTERED ([NonConformitaId] ASC),
    CONSTRAINT [FK_NonConformita_StatoNonConformita] FOREIGN KEY ([StatoNonConformitaId]) REFERENCES [Certificazione].[StatoNonConformita] ([StatoNonConformitaId]),
    CONSTRAINT [FK_NonConformita_TipoNonConformita] FOREIGN KEY ([TipoNonConformitaId]) REFERENCES [Certificazione].[TipoNonConformita] ([TipoNonConformitaId]),
    CONSTRAINT [FK_NonConformita_ValutazioneRequisito] FOREIGN KEY ([ValutazioneRequisitoId]) REFERENCES [Certificazione].[ValutazioneRequisito] ([ValutazioneRequisitoId]),
    CONSTRAINT [UQ_NonConformita_Codice] UNIQUE NONCLUSTERED ([CodiceNonConformita] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Certificazione].[NonConformitaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"NonConformita","temporal":true,"temporal_type":2,"history_table":"Certificazione.NonConformitaStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:NonConformita;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'RilevataDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:NonConformita;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"NonConformita","column":"DataCancellazione","data_type":"datetime2","max_length":8,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:NonConformita;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'ValutazioneRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"NonConformita","column":"DataRilevazione","data_type":"date","max_length":3,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataRilevazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di attivita: 1 = NC attiva, 0 = NC chiusa o annullata.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"NonConformita","column":"StatoNonConformitaId","data_type":"int","max_length":4,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Certificazione.StatoNonConformita.StatoNonConformitaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'StatoNonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'NonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:NonConformita;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'TipoNonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'RilevataDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"NonConformita","column":"Attivo","data_type":"bit","max_length":1,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'ValutazioneRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:NonConformita;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato l ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"NonConformita","column":"NonConformitaId","data_type":"int","max_length":4,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'NonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione estesa della non conformita: evidenza rilevata, clausola violata, impatto.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Certificazione.TipoNonConformita. Classifica la NC (MAGGIORE, MINORE, OSSERVAZIONE).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'TipoNonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:NonConformita;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataRilevazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"NonConformita","column":"TipoNonConformitaId","data_type":"int","max_length":4,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Certificazione.TipoNonConformita.TipoNonConformitaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'TipoNonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataChiusura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"NonConformita","column":"Descrizione","data_type":"nvarchar","max_length":-1,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:NonConformita;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'StatoNonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:NonConformita;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'ValutazioneRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:NonConformita;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'RilevataDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"NonConformita","column":"ModificatoDa","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data effettiva di chiusura della non conformita, valorizzata quando StatoNonConformitaId = CHIUSA.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataChiusura';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Non conformita rilevate durante la valutazione di un certificato (audit, sorveglianza, rinnovo). Ogni record lega la NC a una ValutazioneRequisito specifica, classificandola per tipo e stato. Le NC non chiuse bloccano il rilascio o rinnovo del certificato. Temporal table.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Certificazione.ValutazioneRequisito. Identifica il requisito del programma per cui è stata rilevata la NC.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'ValutazioneRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:NonConformita;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataRilevazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"NonConformita","column":"DataModifica","data_type":"datetime2","max_length":8,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'StatoNonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"NonConformita","column":"DataChiusura","data_type":"date","max_length":3,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataChiusura';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Titolo sintetico della non conformita, usato nelle liste e nei report.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:NonConformita;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'NonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'ValutazioneRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataRilevazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'StatoNonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'NonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:NonConformita;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo della persona ACCREDIA che ha rilevato la non conformita.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'RilevataDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"NonConformita","column":"ValutazioneRequisitoId","data_type":"int","max_length":4,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Certificazione.ValutazioneRequisito.ValutazioneRequisitoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'ValutazioneRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"NonConformita","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"NonConformita","column":"RilevataDa","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'RilevataDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'NonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"NonConformita","column":"CreatoDa","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:NonConformita;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'TipoNonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:NonConformita;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:NonConformita;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"NonConformita","column":"Titolo","data_type":"nvarchar","max_length":255,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record (GUID).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'RilevataDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogate.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'NonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:NonConformita;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data in cui è stata rilevata la non conformita durante la valutazione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataRilevazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:NonConformita;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataChiusura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'TipoNonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Certificazione.StatoNonConformita. Stato corrente della NC (APERTA, IN_VERIFICA, CHIUSA, SCADUTA).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'StatoNonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataChiusura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete). Filtrare con WHERE DataCancellazione IS NULL per i record attivi.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'TipoNonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"NonConformita","column":"DataCreazione","data_type":"datetime2","max_length":8,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataRilevazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"NonConformita","column":"CancellatoDa","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'DataChiusura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'NonConformita', @level2type = N'COLUMN', @level2name = N'StatoNonConformitaId';


GO

