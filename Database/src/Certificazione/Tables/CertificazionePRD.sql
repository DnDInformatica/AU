CREATE TABLE [Certificazione].[CertificazionePRD] (
    [CertificazionePRDId]         INT                                         IDENTITY (1, 1) NOT NULL,
    [CertificazioneId]            INT                                         NOT NULL,
    [OrganizzazioneClienteId]     INT                                         NULL,
    [AmbitoIta]                   NVARCHAR (MAX)                              NULL,
    [AmbitoEng]                   NVARCHAR (MAX)                              NULL,
    [ScopoCertificato]            NVARCHAR (MAX)                              NULL,
    [NomeProdotto]                NVARCHAR (MAX)                              NULL,
    [DataUltimoRinnovo]           DATE                                        NULL,
    [NumeroCertificatoPrecedente] NVARCHAR (100)                              NULL,
    [DataCreazione]               DATETIME2 (7)                               DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                    INT                                         NULL,
    [DataModifica]                DATETIME2 (7)                               NULL,
    [ModificatoDa]                INT                                         NULL,
    [DataCancellazione]           DATETIME2 (7)                               NULL,
    [CancellatoDa]                INT                                         NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER                            DEFAULT (newid()) NOT NULL,
    [SpecificaTecnica]            NVARCHAR (MAX)                              NULL,
    [DataInizioValidita]          DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]            DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_CertificazionePRD] PRIMARY KEY CLUSTERED ([CertificazionePRDId] ASC),
    CONSTRAINT [FK_CertificazionePRD_Certificazione] FOREIGN KEY ([CertificazioneId]) REFERENCES [Certificazione].[Certificazione] ([CertificazioneId]),
    CONSTRAINT [FK_CertificazionePRD_Cliente] FOREIGN KEY ([OrganizzazioneClienteId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId]),
    CONSTRAINT [UQ_CertificazionePRD_CertificazioneId] UNIQUE NONCLUSTERED ([CertificazioneId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Certificazione].[CertificazionePRDStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazionePRD","column":"AmbitoEng","data_type":"nvarchar","max_length":-1,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'AmbitoEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'NomeProdotto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazionePRD","column":"ModificatoDa","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazionePRD;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazionePRD","temporal":true,"temporal_type":2,"history_table":"Certificazione.CertificazionePRDStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'NumeroCertificatoPrecedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'AmbitoEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete). Filtrare con WHERE DataCancellazione IS NULL per i record attivi.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazionePRD","column":"CreatoDa","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazionePRD","column":"NomeProdotto","data_type":"nvarchar","max_length":500,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'NomeProdotto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazionePRD;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'NumeroCertificatoPrecedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'OrganizzazioneClienteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'AmbitoEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'NomeProdotto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'NumeroCertificatoPrecedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazionePRD;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Certificazione.Certificazione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'OrganizzazioneClienteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nome commerciale o tecnico del prodotto certificato, come dichiarato dall OdC.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'NomeProdotto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazionePRD;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'AmbitoEng';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero del certificato nel ciclo precedente, per tracciamento storico.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'NumeroCertificatoPrecedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazionePRD;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'AmbitoEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazionePRD","column":"OrganizzazioneClienteId","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Organizzazioni.Organizzazione.OrganizzazioneId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'OrganizzazioneClienteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazionePRD","column":"CancellatoDa","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazionePRD;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'NomeProdotto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record (GUID). Usato per tracciamento tecnico e integrazioni API.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazionePRD;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'OrganizzazioneClienteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'ScopoCertificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazionePRD","column":"DataCreazione","data_type":"datetime2","max_length":8,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato l ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CertificazionePRDId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'OrganizzazioneClienteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ambito di certificazione in inglese.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'AmbitoEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataUltimoRinnovo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dettaglio certificazione di prodotto (PRD). Estende Certificazione con ambito, scopo, nome del prodotto, profilo professionale ENEL2/TERNA e dati di rinnovo. Per i programmi ENEL2 e TERNA, ProfiloProfessionaleId identifica la figura tecnica abilitata dal certificato. Temporal table con audit, soft-delete e system-versioning.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazionePRD;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'AmbitoIta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataUltimoRinnovo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CertificazionePRDId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazionePRD","column":"ScopoCertificato","data_type":"nvarchar","max_length":2000,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'ScopoCertificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazionePRD;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Organizzazioni.Organizzazione. Azienda cliente titolare della certificazione di prodotto.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'OrganizzazioneClienteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazionePRD","column":"DataModifica","data_type":"datetime2","max_length":8,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazionePRD","column":"CertificazionePRDId","data_type":"int","max_length":4,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CertificazionePRDId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazionePRD","column":"DataUltimoRinnovo","data_type":"date","max_length":3,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataUltimoRinnovo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazionePRD;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataUltimoRinnovo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'ScopoCertificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazionePRD;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CertificazionePRDId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazionePRD","column":"AmbitoIta","data_type":"nvarchar","max_length":-1,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'AmbitoIta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazionePRD","column":"DataCancellazione","data_type":"datetime2","max_length":8,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataUltimoRinnovo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'ScopoCertificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CertificazionePRDId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Scopo esteso del certificato di prodotto, proveniente dal campo corrispondente in SIAC. Può contenere descrizioni tecniche dettagliate, limiti applicativi o condizioni d uso. Testo libero fino a 2000 caratteri.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'ScopoCertificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazionePRD","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazionePRD;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'AmbitoIta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data dell ultimo rinnovo del ciclo di certificazione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataUltimoRinnovo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazionePRD;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'ScopoCertificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogate.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CertificazionePRDId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazionePRD;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'AmbitoIta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazionePRD","column":"NumeroCertificatoPrecedente","data_type":"nvarchar","max_length":100,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'NumeroCertificatoPrecedente';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ambito di certificazione del prodotto in italiano, come riportato sul certificato.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'AmbitoIta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazionePRD;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'NomeProdotto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazionePRD;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'AmbitoIta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'NumeroCertificatoPrecedente';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazionePRD","column":"CertificazioneId","data_type":"int","max_length":4,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Certificazione.Certificazione.CertificazioneId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRD', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

