CREATE TABLE [Certificazione].[CertificazioneVoltura] (
    [CertificazioneVolturaId]     INT                                                IDENTITY (1, 1) NOT NULL,
    [CertificazioneId]            INT                                                NOT NULL,
    [OrganizzazioneCedenteId]     INT                                                NOT NULL,
    [OrganizzazioneSubentranteId] INT                                                NOT NULL,
    [EventoSocietarioId]          INT                                                NULL,
    [WorkflowIstanzaId]           INT                                                NULL,
    [DeliberaId]                  INT                                                NULL,
    [TipoProcessoCertificativoId] INT                                                NOT NULL,
    [DataRichiesta]               DATE                                               NOT NULL,
    [DataEfficacia]               DATE                                               NULL,
    [Motivo]                      NVARCHAR (500)                                     NULL,
    [NuovoNumeroCertificato]      NVARCHAR (100)                                     NULL,
    [MantieneNumeroCertificato]   BIT                                                DEFAULT ((0)) NOT NULL,
    [Approvata]                   BIT                                                NULL,
    [DataCreazione]               DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                    INT                                                NULL,
    [DataModifica]                DATETIME2 (7)                                      NULL,
    [ModificatoDa]                INT                                                NULL,
    [DataCancellazione]           DATETIME2 (7)                                      NULL,
    [CancellatoDa]                INT                                                NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]          DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]            DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_CertificazioneVoltura] PRIMARY KEY CLUSTERED ([CertificazioneVolturaId] ASC),
    CONSTRAINT [FK_CertificazioneVoltura_Certificazione] FOREIGN KEY ([CertificazioneId]) REFERENCES [Certificazione].[Certificazione] ([CertificazioneId]),
    CONSTRAINT [FK_CertificazioneVoltura_OrganizzazioneCedente] FOREIGN KEY ([OrganizzazioneCedenteId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId]),
    CONSTRAINT [FK_CertificazioneVoltura_OrganizzazioneSubentrante] FOREIGN KEY ([OrganizzazioneSubentranteId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId]),
    CONSTRAINT [FK_CertificazioneVoltura_TipoProcessoCertificativo] FOREIGN KEY ([TipoProcessoCertificativoId]) REFERENCES [Certificazione].[TipoProcessoCertificativo] ([TipoProcessoCertificativoId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Certificazione].[CertificazioneVolturaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'Approvata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se dopo la voltura il certificato mantiene il numero originale. Default 0 (nuovo numero).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'MantieneNumeroCertificato';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso il workflow di approvazione della voltura. Nullable se la voltura è stata gestita fuori dal motore workflow.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'MantieneNumeroCertificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"OrganizzazioneCedenteId","data_type":"int","max_length":4,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Organizzazioni.Organizzazione.OrganizzazioneId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'OrganizzazioneCedenteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso la delibera che ha approvato la voltura.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero assegnato al certificato dopo la voltura, se diverso dal precedente.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'NuovoNumeroCertificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"DataModifica","data_type":"datetime2","max_length":8,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'NuovoNumeroCertificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'TipoProcessoCertificativoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Certificazione.TipoProcessoCertificativo. Tipo di processo (tipicamente VOLTURA).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'TipoProcessoCertificativoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Motivazione della voltura (es. acquisizione, fusione per incorporazione).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'Motivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record (GUID). Usato per tracciamento tecnico e integrazioni API.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'Motivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CertificazioneVolturaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Organizzazioni.Organizzazione. OdC che subentra nella titolarità del certificato.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'OrganizzazioneSubentranteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'EventoSocietarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"CertificazioneId","data_type":"int","max_length":4,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Certificazione.Certificazione.CertificazioneId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se la voltura è stata approvata (1), rifiutata (0) o è in corso di valutazione (NULL).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'Approvata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","temporal":true,"temporal_type":2,"history_table":"Certificazione.CertificazioneVolturaStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso l evento societario (fusione, scissione, ecc.) che ha originato la voltura. Nullable.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'EventoSocietarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"ModificatoDa","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'OrganizzazioneCedenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'NuovoNumeroCertificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'TipoProcessoCertificativoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'NuovoNumeroCertificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'TipoProcessoCertificativoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'Motivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'Motivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataEfficacia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataEfficacia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Organizzazioni.Organizzazione. OdC che cede il certificato.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'OrganizzazioneCedenteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"CertificazioneVolturaId","data_type":"int","max_length":4,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CertificazioneVolturaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'OrganizzazioneSubentranteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"DataCancellazione","data_type":"datetime2","max_length":8,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'Approvata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'Approvata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Certificazione.Certificazione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"CancellatoDa","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'MantieneNumeroCertificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'MantieneNumeroCertificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CertificazioneVolturaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'OrganizzazioneSubentranteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato l ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'EventoSocietarioId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogate.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CertificazioneVolturaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'EventoSocietarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'MantieneNumeroCertificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"DeliberaId","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'OrganizzazioneCedenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"MantieneNumeroCertificato","data_type":"bit","max_length":1,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'MantieneNumeroCertificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'NuovoNumeroCertificato';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete). Filtrare con WHERE DataCancellazione IS NULL per i record attivi.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"TipoProcessoCertificativoId","data_type":"int","max_length":4,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Certificazione.TipoProcessoCertificativo.TipoProcessoCertificativoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'TipoProcessoCertificativoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'TipoProcessoCertificativoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'OrganizzazioneCedenteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Trasferimento di un certificato da un OdC cedente a un OdC subentrante, tipicamente a seguito di fusione, acquisizione, cessione di ramo d azienda o cambio di denominazione. Ogni record traccia il trasferimento con le organizzazioni coinvolte, l evento societario, la data di efficacia e l eventuale cambio del numero certificato. Temporal table.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"NuovoNumeroCertificato","data_type":"nvarchar","max_length":100,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'NuovoNumeroCertificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'Motivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"Motivo","data_type":"nvarchar","max_length":500,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'Motivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"DataRichiesta","data_type":"date","max_length":3,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataEfficacia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"DataEfficacia","data_type":"date","max_length":3,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataEfficacia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'OrganizzazioneSubentranteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"EventoSocietarioId","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'EventoSocietarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"DataCreazione","data_type":"datetime2","max_length":8,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'EventoSocietarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'Approvata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"WorkflowIstanzaId","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"Approvata","data_type":"bit","max_length":1,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'Approvata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;Nullable', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'WorkflowIstanzaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di efficacia della voltura: da questa data il certificato risulta intestato all OdC subentrante.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataEfficacia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data in cui è stata ricevuta la richiesta di voltura.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CertificazioneVolturaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'OrganizzazioneCedenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataEfficacia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"OrganizzazioneSubentranteId","data_type":"int","max_length":4,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Organizzazioni.Organizzazione.OrganizzazioneId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'OrganizzazioneSubentranteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CertificazioneVolturaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"CertificazioneVoltura","column":"CreatoDa","data_type":"int","max_length":4,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'OrganizzazioneSubentranteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;Table:CertificazioneVoltura;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazioneVoltura', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

