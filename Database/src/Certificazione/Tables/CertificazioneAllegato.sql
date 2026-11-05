CREATE TABLE [Certificazione].[CertificazioneAllegato] (
    [CertificazioneAllegatoId] INT                                                IDENTITY (1, 1) NOT NULL,
    [CertificazioneId]         INT                                                NOT NULL,
    [CertificazioneSedeId]     INT                                                NULL,
    [NomeFile]                 NVARCHAR (500)                                     NOT NULL,
    [PathFile]                 NVARCHAR (1000)                                    NULL,
    [DataScadenzaAllegato]     DATE                                               NULL,
    [Revisione]                NVARCHAR (20)                                      NULL,
    [DataRevisione]            DATE                                               NULL,
    [Note]                     NVARCHAR (500)                                     NULL,
    [DataCreazione]            DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                 INT                                                NULL,
    [DataModifica]             DATETIME2 (7)                                      NULL,
    [ModificatoDa]             INT                                                NULL,
    [DataCancellazione]        DATETIME2 (7)                                      NULL,
    [CancellatoDa]             INT                                                NULL,
    [UniqueRowId]              UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [TipoAllegatoId]           INT                                                NOT NULL,
    [DataInizioValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]         DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_CertificazioneAllegato] PRIMARY KEY CLUSTERED ([CertificazioneAllegatoId] ASC),
    CONSTRAINT [FK_CertAllegato_TipoAllegato] FOREIGN KEY ([TipoAllegatoId]) REFERENCES [Certificazione].[TipoAllegato] ([TipoAllegatoId]),
    CONSTRAINT [FK_CertificazioneAllegato_Certificazione] FOREIGN KEY ([CertificazioneId]) REFERENCES [Certificazione].[Certificazione] ([CertificazioneId]),
    CONSTRAINT [FK_CertificazioneAllegato_Sede] FOREIGN KEY ([CertificazioneSedeId]) REFERENCES [Certificazione].[CertificazioneSede] ([CertificazioneSedeId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Certificazione].[CertificazioneAllegatoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneAllegato;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneAllegato","column":"PathFile","data_type":"nvarchar","max_length":1000,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'PathFile';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Certificazione.CertificazioneSede. Se valorizzata, l allegato è specifico per una sede. NULL se è un allegato generale del certificato.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CertificazioneSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataScadenzaAllegato';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CertificazioneAllegatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataRevisione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'TipoAllegatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneAllegato","column":"DataCancellazione","data_type":"datetime2","max_length":8,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneAllegato;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataScadenzaAllegato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneAllegato;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneAllegato;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'PathFile';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneAllegato","column":"CertificazioneAllegatoId","data_type":"int","max_length":4,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CertificazioneAllegatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataScadenzaAllegato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneAllegato;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CertificazioneSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneAllegato","column":"DataModifica","data_type":"datetime2","max_length":8,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneAllegato","column":"TipoAllegatoId","data_type":"int","max_length":4,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Certificazione.TipoAllegato.TipoAllegatoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'TipoAllegatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneAllegato","column":"Note","data_type":"nvarchar","max_length":500,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato l ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero o codice di revisione del documento (es. 01, rev2, 2025-03). Consente il versioning degli allegati.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'Revisione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneAllegato","temporal":true,"temporal_type":2,"history_table":"Certificazione.CertificazioneAllegatoStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'TipoAllegatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CertificazioneAllegatoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nome del file allegato come visibile all utente (es. certificato_IT01_2025.pdf).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'NomeFile';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneAllegato","column":"DataScadenzaAllegato","data_type":"date","max_length":3,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataScadenzaAllegato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'TipoAllegatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneAllegato;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'Revisione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneAllegato;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneAllegato;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'NomeFile';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data della revisione del documento.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataRevisione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Allegati documentali associati a un certificato o a una sede certificata. Gestisce il ciclo di vita dei documenti allegati (copia certificato, appendici, planimetrie, dichiarazioni) con tipo, nome file, path, revisione e scadenza. Temporal table.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataScadenzaAllegato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneAllegato","column":"CertificazioneId","data_type":"int","max_length":4,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Certificazione.Certificazione.CertificazioneId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record (GUID). Usato per tracciamento tecnico e integrazioni API.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CertificazioneSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'Revisione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneAllegato","column":"CancellatoDa","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'NomeFile';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete). Filtrare con WHERE DataCancellazione IS NULL per i record attivi.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Percorso completo del file nel repository documentale (es. /documenti/certificazioni/2025/IT01/). NULL per allegati referenziati ma non ancora caricati.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'PathFile';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneAllegato","column":"ModificatoDa","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneAllegato;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneAllegato;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataRevisione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneAllegato","column":"DataCreazione","data_type":"datetime2","max_length":8,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CertificazioneSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneAllegato;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'Revisione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'NomeFile';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneAllegato;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'PathFile';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneAllegato;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataRevisione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogate.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CertificazioneAllegatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneAllegato","column":"CertificazioneSedeId","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Certificazione.CertificazioneSede.CertificazioneSedeId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CertificazioneSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneAllegato","column":"Revisione","data_type":"nvarchar","max_length":20,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'Revisione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'PathFile';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Certificazione.TipoAllegato. Classifica il tipo di allegato (es. COPIA_CERT, APPENDICE, PLANIMETRIA, DICHIARAZIONE).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'TipoAllegatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneAllegato","column":"NomeFile","data_type":"nvarchar","max_length":500,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'NomeFile';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataRevisione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneAllegato;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CertificazioneAllegatoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note libere sull allegato.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneAllegato","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CertificazioneSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'Revisione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'PathFile';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'NomeFile';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CertificazioneAllegatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneAllegato;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'TipoAllegatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneAllegato;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneAllegato","column":"DataRevisione","data_type":"date","max_length":3,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataRevisione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di scadenza del documento allegato (es. dichiarazione con validita annuale). NULL se il documento non ha scadenza.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataScadenzaAllegato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Certificazione.Certificazione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneAllegato;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneAllegato","column":"CreatoDa","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneAllegato', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

