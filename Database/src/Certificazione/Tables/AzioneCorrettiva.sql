CREATE TABLE [Certificazione].[AzioneCorrettiva] (
    [AzioneCorrettivaId]           INT                                                IDENTITY (1, 1) NOT NULL,
    [NonConformitaId]              INT                                                NOT NULL,
    [StatoAzioneCorrettivaId]      INT                                                NOT NULL,
    [CodiceAzioneCorrettiva]       NVARCHAR (50)                                      NOT NULL,
    [Descrizione]                  NVARCHAR (MAX)                                     NOT NULL,
    [ResponsabileAzione]           NVARCHAR (255)                                     NULL,
    [DataProposta]                 DATE                                               NULL,
    [DataScadenza]                 DATE                                               NULL,
    [DataCompletamento]            DATE                                               NULL,
    [DataVerificaEfficacia]        DATE                                               NULL,
    [VerificataDa]                 INT                                                NULL,
    [Attivo]                       BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]                DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                     INT                                                NULL,
    [DataModifica]                 DATETIME2 (7)                                      NULL,
    [ModificatoDa]                 INT                                                NULL,
    [DataCancellazione]            DATETIME2 (7)                                      NULL,
    [CancellatoDa]                 INT                                                NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [TipoEsitoVerificaEfficaciaId] INT                                                NULL,
    [ResponsabilePersonaId]        INT                                                NULL,
    [ResponsabileOrganizzazioneId] INT                                                NULL,
    [NoteVerificaEfficacia]        NVARCHAR (MAX)                                     NULL,
    [DataAccettazione]             DATE                                               NULL,
    [DataInizioValidita]           DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]             DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_AzioneCorrettiva] PRIMARY KEY CLUSTERED ([AzioneCorrettivaId] ASC),
    CONSTRAINT [FK_AzioneCorrettiva_NonConformita] FOREIGN KEY ([NonConformitaId]) REFERENCES [Certificazione].[NonConformita] ([NonConformitaId]),
    CONSTRAINT [FK_AzioneCorrettiva_ResponsabileOrganizzazione] FOREIGN KEY ([ResponsabileOrganizzazioneId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId]),
    CONSTRAINT [FK_AzioneCorrettiva_ResponsabilePersona] FOREIGN KEY ([ResponsabilePersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [FK_AzioneCorrettiva_StatoAzioneCorrettiva] FOREIGN KEY ([StatoAzioneCorrettivaId]) REFERENCES [Certificazione].[StatoAzioneCorrettiva] ([StatoAzioneCorrettivaId]),
    CONSTRAINT [FK_AzioneCorrettiva_TipoEsitoVerificaEfficacia] FOREIGN KEY ([TipoEsitoVerificaEfficaciaId]) REFERENCES [Certificazione].[TipoEsitoVerificaEfficacia] ([TipoEsitoVerificaEfficaciaId]),
    CONSTRAINT [FK_AzioneCorrettiva_VerificataDa] FOREIGN KEY ([VerificataDa]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [UQ_AzioneCorrettiva_Codice] UNIQUE NONCLUSTERED ([CodiceAzioneCorrettiva] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Certificazione].[AzioneCorrettivaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"ResponsabilePersonaId","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ResponsabilePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataAccettazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"ModificatoDa","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete). Filtrare con WHERE DataCancellazione IS NULL per i record attivi.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'TipoEsitoVerificaEfficaciaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataVerificaEfficacia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'VerificataDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ResponsabileAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'StatoAzioneCorrettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note del valutatore sull esito della verifica di efficacia.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'NoteVerificaEfficacia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Certificazione.NonConformita. NC a cui l azione correttiva risponde.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'NonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data in cui l OdC ha proposto l azione correttiva.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataProposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"NonConformitaId","data_type":"int","max_length":4,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Certificazione.NonConformita.NonConformitaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'NonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'NoteVerificaEfficacia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataProposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'AzioneCorrettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"DataCompletamento","data_type":"date","max_length":3,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice identificativo dell azione correttiva all interno del processo. Univoco per NC.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'CodiceAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","temporal":true,"temporal_type":2,"history_table":"Certificazione.AzioneCorrettivaStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"Attivo","data_type":"bit","max_length":1,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Organizzazioni.Organizzazione. Organizzazione responsabile dell AC (tipicamente l OdC).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ResponsabileOrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataVerificaEfficacia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ResponsabileOrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"CodiceAzioneCorrettiva","data_type":"nvarchar","max_length":50,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'CodiceAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataProposta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di attivita: 1 = AC attiva, 0 = AC ritirata o sostituita.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ResponsabileOrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"DataModifica","data_type":"datetime2","max_length":8,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"ResponsabileAzione","data_type":"nvarchar","max_length":255,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ResponsabileAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Persone.Persona. Referimento al responsabile AC nel sistema anagrafico, se disponibile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ResponsabilePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'StatoAzioneCorrettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di effettivo completamento dell azione correttiva da parte dell OdC.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato l ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'NonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ResponsabilePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'VerificataDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataAccettazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'NonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"TipoEsitoVerificaEfficaciaId","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Certificazione.TipoEsitoVerificaEfficacia.TipoEsitoVerificaEfficaciaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'TipoEsitoVerificaEfficaciaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'TipoEsitoVerificaEfficaciaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataAccettazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Certificazione.TipoEsitoVerificaEfficacia. Esito della verifica di efficacia dell AC (EFFICACE, NON_EFFICACE, PARZIALMENTE_EFFICACE). Nullable finche la verifica non è completata.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'TipoEsitoVerificaEfficaciaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"AzioneCorrettivaId","data_type":"int","max_length":4,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'AzioneCorrettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataProposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataVerificaEfficacia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'NoteVerificaEfficacia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'CodiceAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'CodiceAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nome o ruolo del responsabile dell OdC incaricato dell esecuzione dell azione correttiva.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ResponsabileAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'NoteVerificaEfficacia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Certificazione.StatoAzioneCorrettiva. Stato corrente (PROPOSTA, APPROVATA, IN_ESECUZIONE, COMPLETATA, VERIFICATA, RESPINTA).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'StatoAzioneCorrettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ResponsabileAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"StatoAzioneCorrettivaId","data_type":"int","max_length":4,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Certificazione.StatoAzioneCorrettiva.StatoAzioneCorrettivaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'StatoAzioneCorrettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'NonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ResponsabileAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"DataScadenza","data_type":"date","max_length":3,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ResponsabileOrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogate.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'AzioneCorrettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ResponsabilePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"VerificataDa","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'VerificataDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'AzioneCorrettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ResponsabileOrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'VerificataDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataProposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ResponsabilePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"Descrizione","data_type":"nvarchar","max_length":-1,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'CodiceAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"DataAccettazione","data_type":"date","max_length":3,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataAccettazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record (GUID). Usato per tracciamento tecnico e integrazioni API.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"CancellatoDa","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'TipoEsitoVerificaEfficaciaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataVerificaEfficacia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"CreatoDa","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Persone.Persona. Valutatore ACCREDIA che ha effettuato la verifica di efficacia.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'VerificataDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data entro cui l azione correttiva deve essere completata, come concordata con ACCREDIA.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ResponsabileAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"DataVerificaEfficacia","data_type":"date","max_length":3,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataVerificaEfficacia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataAccettazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'StatoAzioneCorrettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'VerificataDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"NoteVerificaEfficacia","data_type":"nvarchar","max_length":-1,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'NoteVerificaEfficacia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'StatoAzioneCorrettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:AzioneCorrettiva;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'AzioneCorrettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'NonConformitaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione dell azione correttiva proposta dall OdC, incluse le cause radice identificate e le misure preventive adottate.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataCompletamento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Azioni correttive proposte dall OdC in risposta a non conformita rilevate. Ogni AC include descrizione, responsabile, date di proposta, scadenza, completamento e verifica di efficacia. La chiusura delle AC è prerequisito per la chiusura delle NC e per il rilascio/rinnovo del certificato. Temporal table.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'NoteVerificaEfficacia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'AzioneCorrettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"ResponsabileOrganizzazioneId","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Organizzazioni.Organizzazione.OrganizzazioneId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ResponsabileOrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data in cui ACCREDIA ha condotto la verifica di efficacia dell azione correttiva.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataVerificaEfficacia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"DataCreazione","data_type":"datetime2","max_length":8,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data in cui ACCREDIA ha accettato formalmente la proposta di azione correttiva.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataAccettazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"DataProposta","data_type":"date","max_length":3,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataProposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'TipoEsitoVerificaEfficaciaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"AzioneCorrettiva","column":"DataCancellazione","data_type":"datetime2","max_length":8,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'ResponsabilePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'AzioneCorrettiva', @level2type = N'COLUMN', @level2name = N'CodiceAzioneCorrettiva';


GO

