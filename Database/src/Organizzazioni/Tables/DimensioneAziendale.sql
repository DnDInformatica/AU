CREATE TABLE [Organizzazioni].[DimensioneAziendale] (
    [DimensioneAziendaleId] INT                                                IDENTITY (1, 1) NOT NULL,
    [OrganizzazioneId]      INT                                                NOT NULL,
    [DataRiferimento]       DATE                                               NOT NULL,
    [NumeroAddetti]         INT                                                NULL,
    [FasciaDimensionale]    NVARCHAR (20)                                      NULL,
    [FonteDato]             NVARCHAR (100)                                     NULL,
    [DocumentoId]           INT                                                NULL,
    [Note]                  NVARCHAR (500)                                     NULL,
    [DataCreazione]         DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]              INT                                                NULL,
    [DataModifica]          DATETIME2 (7)                                      NULL,
    [ModificatoDa]          INT                                                NULL,
    [DataCancellazione]     DATETIME2 (7)                                      NULL,
    [CancellatoDa]          INT                                                NULL,
    [UniqueRowId]           UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]    DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]      DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_DimensioneAziendale] PRIMARY KEY CLUSTERED ([DimensioneAziendaleId] ASC),
    CONSTRAINT [FK_DimensioneAziendale_Organizzazione] FOREIGN KEY ([OrganizzazioneId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Organizzazioni].[DimensioneAziendaleStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:DimensioneAziendale;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DBA', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:DimensioneAziendale;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Serie storica del numero di addetti e della fascia dimensionale per ciascuna organizzazione. Il dato viene rilevato periodicamente (tipicamente su base annuale) da fonti quali InfoCamere, dichiarazioni dirette dell''OdC o sistemi legacy. La classificazione per fascia segue la Raccomandazione UE 2003/361/CE: Micro (<10 addetti), Piccola (<50), Media (<250), Grande (>=250). Tabella con SYSTEM_VERSIONING per traccia completa delle correzioni storiche.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DBA', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero di addetti (dipendenti e collaboratori) rilevato alla DataRiferimento. NULL se non disponibile.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'NumeroAddetti';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'FasciaDimensionale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DBA', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DataRiferimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DimensioneAziendaleId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento opzionale al documento che attesta il dato (es. visura, bilancio). Senza FK formale per evitare dipendenza cross-schema bloccante.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:DimensioneAziendale;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DataRiferimento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fascia dimensionale secondo Raccomandazione UE 2003/361/CE. Valori ammessi: MICRO (<10), PICCOLA (<50), MEDIA (<250), GRANDE (>=250). Derivabile da NumeroAddetti ma mantenuta separatamente per consentire classificazioni da fonte che fornisce solo la fascia senza il numero esatto.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'FasciaDimensionale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DBA', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DimensioneAziendaleId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco del record (PK, IDENTITY).', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DimensioneAziendaleId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DBA', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'NumeroAddetti';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'FonteDato';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note e annotazioni operative libere.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'NumeroAddetti';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:DimensioneAziendale;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'FonteDato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;TemporalCurrent;SoftDelete;Audit;DimensioneAziendale', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:DimensioneAziendale;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'NumeroAddetti';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DBA', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'FasciaDimensionale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Organizzazioni.Organizzazione.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:DimensioneAziendale;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:DimensioneAziendale;Nullable;SoftFK', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DBA', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DimensioneAziendaleId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DBA', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DBA', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DataRiferimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'FasciaDimensionale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:DimensioneAziendale;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DimensioneAziendaleId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:DimensioneAziendale;Nullable;Tipologica', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'FasciaDimensionale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DataRiferimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:DimensioneAziendale;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data della rilevazione del dato (es. 31/12/AAAA per rilevamento annuale da bilancio o Registro Imprese).', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DataRiferimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"DimensioneAziendale","temporal":true,"temporal_type":2,"history_table":"Organizzazioni.DimensioneAziendaleStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:DimensioneAziendale;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DBA', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'FonteDato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DBA', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'FonteDato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DBA', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fonte del rilevamento. Valori tipici: InfoCamere, Dichiarazione OdC, SIAC, Manuale.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'FonteDato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'DimensioneAziendale', @level2type = N'COLUMN', @level2name = N'NumeroAddetti';


GO

