CREATE TABLE [Standard].[SoggettoFonte] (
    [SoggettoFonteId]                    INT                                         IDENTITY (1, 1) NOT NULL,
    [Codice]                             NVARCHAR (50)                               NOT NULL,
    [Denominazione]                      NVARCHAR (400)                              NOT NULL,
    [TipoSoggetto]                       NVARCHAR (40)                               NOT NULL,
    [OrganismoDiNormazioneId]            INT                                         NULL,
    [SchemaCertificazioneProprietarioId] INT                                         NULL,
    [EnteAccreditamentoId]               INT                                         NULL,
    [RegolatoreId]                       INT                                         NULL,
    [CooperazioneAccreditamentoId]       INT                                         NULL,
    [Attivo]                             BIT                                         CONSTRAINT [DF_SoggettoFonte_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                      DATETIME2 (7)                               CONSTRAINT [DF_SoggettoFonte_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                           INT                                         NULL,
    [DataModifica]                       DATETIME2 (7)                               NULL,
    [ModificatoDa]                       INT                                         NULL,
    [DataCancellazione]                  DATETIME2 (7)                               NULL,
    [CancellatoDa]                       INT                                         NULL,
    [UniqueRowId]                        UNIQUEIDENTIFIER                            CONSTRAINT [DF_SoggettoFonte_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                 DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]                   DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    [OrganizzazioneId]                   INT                                         NULL,
    CONSTRAINT [PK_SoggettoFonte] PRIMARY KEY CLUSTERED ([SoggettoFonteId] ASC),
    CONSTRAINT [CK_SoggettoFonte_CoerenzaTipoFK] CHECK ([TipoSoggetto]=N'OrganismoDiNormazione' AND [OrganismoDiNormazioneId] IS NOT NULL AND [SchemaCertificazioneProprietarioId] IS NULL AND [EnteAccreditamentoId] IS NULL AND [RegolatoreId] IS NULL AND [CooperazioneAccreditamentoId] IS NULL AND [OrganizzazioneId] IS NULL OR [TipoSoggetto]=N'SchemeOwner' AND [SchemaCertificazioneProprietarioId] IS NOT NULL AND [OrganismoDiNormazioneId] IS NULL AND [EnteAccreditamentoId] IS NULL AND [RegolatoreId] IS NULL AND [CooperazioneAccreditamentoId] IS NULL AND [OrganizzazioneId] IS NULL OR [TipoSoggetto]=N'EnteAccreditamento' AND [EnteAccreditamentoId] IS NOT NULL AND [OrganismoDiNormazioneId] IS NULL AND [SchemaCertificazioneProprietarioId] IS NULL AND [RegolatoreId] IS NULL AND [CooperazioneAccreditamentoId] IS NULL AND [OrganizzazioneId] IS NULL OR [TipoSoggetto]=N'Regolatore' AND [RegolatoreId] IS NOT NULL AND [OrganismoDiNormazioneId] IS NULL AND [SchemaCertificazioneProprietarioId] IS NULL AND [EnteAccreditamentoId] IS NULL AND [CooperazioneAccreditamentoId] IS NULL AND [OrganizzazioneId] IS NULL OR [TipoSoggetto]=N'CooperazioneAccreditamento' AND [CooperazioneAccreditamentoId] IS NOT NULL AND [OrganismoDiNormazioneId] IS NULL AND [SchemaCertificazioneProprietarioId] IS NULL AND [EnteAccreditamentoId] IS NULL AND [RegolatoreId] IS NULL AND [OrganizzazioneId] IS NULL OR [TipoSoggetto]=N'OrganizzazioneFonte' AND [OrganizzazioneId] IS NOT NULL AND [OrganismoDiNormazioneId] IS NULL AND [SchemaCertificazioneProprietarioId] IS NULL AND [EnteAccreditamentoId] IS NULL AND [RegolatoreId] IS NULL AND [CooperazioneAccreditamentoId] IS NULL),
    CONSTRAINT [CK_SoggettoFonte_TipoSoggetto] CHECK ([TipoSoggetto]=N'OrganizzazioneFonte' OR [TipoSoggetto]=N'Regolatore' OR [TipoSoggetto]=N'CooperazioneAccreditamento' OR [TipoSoggetto]=N'EnteAccreditamento' OR [TipoSoggetto]=N'SchemeOwner' OR [TipoSoggetto]=N'OrganismoDiNormazione'),
    CONSTRAINT [FK_SoggettoFonte_CooperazioneAccreditamento] FOREIGN KEY ([CooperazioneAccreditamentoId]) REFERENCES [Standard].[CooperazioneAccreditamento] ([CooperazioneAccreditamentoId]),
    CONSTRAINT [FK_SoggettoFonte_EnteAccreditamento] FOREIGN KEY ([EnteAccreditamentoId]) REFERENCES [Accreditamento].[EnteAccreditamento] ([EnteAccreditamentoId]),
    CONSTRAINT [FK_SoggettoFonte_OrganismoDiNormazione] FOREIGN KEY ([OrganismoDiNormazioneId]) REFERENCES [Standard].[OrganismoDiNormazione] ([OrganismoDiNormazioneId]),
    CONSTRAINT [FK_SoggettoFonte_Organizzazione] FOREIGN KEY ([OrganizzazioneId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId]),
    CONSTRAINT [FK_SoggettoFonte_Regolatore] FOREIGN KEY ([RegolatoreId]) REFERENCES [Standard].[Regolatore] ([RegolatoreId]),
    CONSTRAINT [FK_SoggettoFonte_SchemaCertProprietario] FOREIGN KEY ([SchemaCertificazioneProprietarioId]) REFERENCES [Standard].[SchemaCertificazioneProprietario] ([SchemaCertificazioneProprietarioId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[SoggettoFonteStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_SoggettoFonte_DataCancellazione]
    ON [Standard].[SoggettoFonte]([DataCancellazione] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_SoggettoFonte_SchemaCertProprietario]
    ON [Standard].[SoggettoFonte]([SchemaCertificazioneProprietarioId] ASC) WHERE ([SchemaCertificazioneProprietarioId] IS NOT NULL AND [DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_SoggettoFonte_CooperazioneAccreditamento]
    ON [Standard].[SoggettoFonte]([CooperazioneAccreditamentoId] ASC) WHERE ([CooperazioneAccreditamentoId] IS NOT NULL AND [DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_SoggettoFonte_CreatoDa]
    ON [Standard].[SoggettoFonte]([CreatoDa] ASC);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_SoggettoFonte_EnteAccreditamento]
    ON [Standard].[SoggettoFonte]([EnteAccreditamentoId] ASC) WHERE ([EnteAccreditamentoId] IS NOT NULL AND [DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_SoggettoFonte_Organizzazione]
    ON [Standard].[SoggettoFonte]([OrganizzazioneId] ASC) WHERE ([OrganizzazioneId] IS NOT NULL AND [DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_SoggettoFonte_Codice]
    ON [Standard].[SoggettoFonte]([Codice] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_SoggettoFonte_OrganismoDiNormazione]
    ON [Standard].[SoggettoFonte]([OrganismoDiNormazioneId] ASC) WHERE ([OrganismoDiNormazioneId] IS NOT NULL AND [DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_SoggettoFonte_Regolatore]
    ON [Standard].[SoggettoFonte]([RegolatoreId] ASC) WHERE ([RegolatoreId] IS NOT NULL AND [DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo univoco di riga (GUID) stabile nel tempo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di attivazione del record (1 = attivo).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio periodo di system-versioning (GENERATED ALWAYS AS ROW START).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ANAGRAFICA', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'RegolatoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK a Standard.Regolatore.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'RegolatoreId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente della cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'CooperazioneAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK a Accreditamento.EnteAccreditamento (AB: ACCREDIA e altri).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'RegolatoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'RegolatoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK a Standard.CooperazioneAccreditamento (EA, IAF, ILAC, Global ACI).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'CooperazioneAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'CooperazioneAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'CooperazioneAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente dell''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK a Standard.OrganismoDiNormazione (SDO: ISO, IEC, UNI, CEI, CEN, CENELEC).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'OrganismoDiNormazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'SchemaCertificazioneProprietarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'SchemaCertificazioneProprietarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'OrganismoDiNormazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'OrganismoDiNormazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'OrganismoDiNormazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete); NULL se non cancellato.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'SchemaCertificazioneProprietarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK a Standard.SchemaCertificazioneProprietario (scheme owner: FSSC, BRCGS, IFS, PEFC...).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'SchemaCertificazioneProprietarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'EnteAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine periodo di system-versioning (GENERATED ALWAYS AS ROW END).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice della fonte (es. EA, IAF, ILAC, GLOBALACI, ISO, UNI, UE, ACCREDIA).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Registro ponte dei soggetti-fonte (emittenti di documenti): unifica i ruoli esistenti tramite FK tipizzate, senza duplicare le anagrafiche.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'SoggettoFonteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'SoggettoFonteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'SoggettoFonteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'SoggettoFonteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente creatore.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'TipoSoggetto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'TipoSoggetto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'TipoSoggetto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo di soggetto-fonte; determina quale FK di ruolo e valorizzata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'TipoSoggetto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK a Organizzazioni.Organizzazione per soggetti istituzionali produttori o custodi di fonti che non ricadono nei ruoli specialistici gia modellati.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Denominazione della fonte.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SoggettoFonte', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

