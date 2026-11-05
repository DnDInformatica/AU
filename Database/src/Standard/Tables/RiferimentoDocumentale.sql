CREATE TABLE [Standard].[RiferimentoDocumentale] (
    [RiferimentoDocumentaleId] INT                                         IDENTITY (1, 1) NOT NULL,
    [SoggettoFonteId]          INT                                         NOT NULL,
    [TipoRiferimento]          NVARCHAR (40)                               NOT NULL,
    [CodiceDocumento]          NVARCHAR (100)                              NOT NULL,
    [Edizione]                 NVARCHAR (50)                               NULL,
    [Titolo]                   NVARCHAR (1000)                             NULL,
    [Stato]                    NVARCHAR (30)                               CONSTRAINT [DF_RifDoc_Stato] DEFAULT (N'Corrente') NOT NULL,
    [DataPubblicazione]        DATE                                        NULL,
    [DataCessazione]           DATE                                        NULL,
    [UrlUfficiale]             NVARCHAR (1000)                             NULL,
    [RepositoryFonte]          NVARCHAR (100)                              NULL,
    [Attivo]                   BIT                                         CONSTRAINT [DF_RifDoc_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]            DATETIME2 (7)                               CONSTRAINT [DF_RifDoc_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                 INT                                         NULL,
    [DataModifica]             DATETIME2 (7)                               NULL,
    [ModificatoDa]             INT                                         NULL,
    [DataCancellazione]        DATETIME2 (7)                               NULL,
    [CancellatoDa]             INT                                         NULL,
    [UniqueRowId]              UNIQUEIDENTIFIER                            CONSTRAINT [DF_RifDoc_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]         DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_RiferimentoDocumentale] PRIMARY KEY CLUSTERED ([RiferimentoDocumentaleId] ASC),
    CONSTRAINT [CK_RifDoc_IntervalloDate] CHECK ([DataPubblicazione] IS NULL OR [DataCessazione] IS NULL OR [DataCessazione]>=[DataPubblicazione]),
    CONSTRAINT [CK_RifDoc_Stato] CHECK ([Stato]=N'Archiviato' OR [Stato]=N'Sostituito' OR [Stato]=N'Corrente'),
    CONSTRAINT [CK_RifDoc_TipoRiferimento] CHECK ([TipoRiferimento]=N'Altro' OR [TipoRiferimento]=N'LineaGuida' OR [TipoRiferimento]=N'ElencoOperativo' OR [TipoRiferimento]=N'Delibera' OR [TipoRiferimento]=N'DocumentoSchema' OR [TipoRiferimento]=N'DocumentoAccreditamento' OR [TipoRiferimento]=N'Norma' OR [TipoRiferimento]=N'Decisione' OR [TipoRiferimento]=N'Direttiva' OR [TipoRiferimento]=N'Regolamento'),
    CONSTRAINT [FK_RifDoc_SoggettoFonte] FOREIGN KEY ([SoggettoFonteId]) REFERENCES [Standard].[SoggettoFonte] ([SoggettoFonteId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[RiferimentoDocumentaleStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_RifDoc_CreatoDa]
    ON [Standard].[RiferimentoDocumentale]([CreatoDa] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_RifDoc_DataCancellazione]
    ON [Standard].[RiferimentoDocumentale]([DataCancellazione] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_RifDoc_SoggettoFonte]
    ON [Standard].[RiferimentoDocumentale]([SoggettoFonteId] ASC);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_RifDoc_Fonte_Codice_Edizione]
    ON [Standard].[RiferimentoDocumentale]([SoggettoFonteId] ASC, [CodiceDocumento] ASC, [Edizione] ASC) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'RepositoryFonte';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'RiferimentoDocumentaleId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio periodo di system-versioning (GENERATED ALWAYS AS ROW START).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'RepositoryFonte';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'RiferimentoDocumentaleId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice/riferimento del documento (es. Reg. CE 765/2008, ISO/IEC 17011, IAF ID 1, EA-INF/01, Global ACI MRA-001).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'CodiceDocumento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataPubblicazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'TipoRiferimento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di cessazione di validita del documento.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete); NULL se non cancellato.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'SoggettoFonteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'RepositoryFonte';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di attivazione del record (1 = attivo).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK alla fonte emittente del documento.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'SoggettoFonteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'UrlUfficiale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'RiferimentoDocumentaleId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di pubblicazione/entrata in vigore (validita documentale, distinta dal periodo temporale di riga).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataPubblicazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo documentale: Regolamento | Direttiva | Decisione | Norma | DocumentoAccreditamento | DocumentoSchema | Delibera | ElencoOperativo | LineaGuida | Altro.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'TipoRiferimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'UrlUfficiale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'SoggettoFonteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente dell''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'Edizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'UrlUfficiale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'RiferimentoDocumentaleId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Titolo del documento.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'Edizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataPubblicazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'CodiceDocumento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'TipoRiferimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'Edizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stato documentale controllato: Corrente | Archiviato | Sostituito. Le transizioni terminali devono essere eseguite tramite Standard.usp_RegistraRelazioneDocumentale.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'CodiceDocumento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo univoco di riga (GUID) stabile nel tempo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Repository di reperimento (es. EUR-Lex, Gazzetta Ufficiale, sito Global ACI).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'RepositoryFonte';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ANAGRAFICA', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Edizione/anno del documento (es. 2017, 2023, 2:2024).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'Edizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'CodiceDocumento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataPubblicazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine periodo di system-versioning (GENERATED ALWAYS AS ROW END).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'TipoRiferimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente creatore.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente della cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'SoggettoFonteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'URL ufficiale del documento.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'UrlUfficiale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Registro dei documenti (regolamenti, direttive, norme, documenti di accreditamento/schema, delibere, elenchi) con fonte, tipo, stato e successione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentale', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

