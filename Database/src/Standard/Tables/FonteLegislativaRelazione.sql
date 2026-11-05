CREATE TABLE [Standard].[FonteLegislativaRelazione] (
    [FonteLegislativaRelazioneId]    INT                                                IDENTITY (1, 1) NOT NULL,
    [FonteLegislativaIdOrigine]      INT                                                NOT NULL,
    [FonteLegislativaIdDestinazione] INT                                                NOT NULL,
    [TipoRelazioneFonteId]           INT                                                NOT NULL,
    [Note]                           NVARCHAR (1000)                                    NULL,
    [DataCreazione]                  DATETIME2 (7)                                      CONSTRAINT [DF_FonteLegislativaRelazione_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                       INT                                                NULL,
    [DataModifica]                   DATETIME2 (7)                                      NULL,
    [ModificatoDa]                   INT                                                NULL,
    [DataCancellazione]              DATETIME2 (7)                                      NULL,
    [CancellatoDa]                   INT                                                NULL,
    [UniqueRowId]                    UNIQUEIDENTIFIER                                   CONSTRAINT [DF_FonteLegislativaRelazione_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita]             DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_FonteLegislativaRelazione_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]               DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_FonteLegislativaRelazione_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_FonteLegislativaRelazione] PRIMARY KEY CLUSTERED ([FonteLegislativaRelazioneId] ASC),
    CONSTRAINT [CK_FonteLegislativaRelazione_Cancellazione] CHECK ([DataCancellazione] IS NULL AND [CancellatoDa] IS NULL OR [DataCancellazione] IS NOT NULL),
    CONSTRAINT [CK_FonteLegislativaRelazione_NoSelf] CHECK ([FonteLegislativaIdOrigine]<>[FonteLegislativaIdDestinazione]),
    CONSTRAINT [FK_FonteLegislativaRelazione_Destinazione] FOREIGN KEY ([FonteLegislativaIdDestinazione]) REFERENCES [Standard].[FonteLegislativa] ([FonteLegislativaId]),
    CONSTRAINT [FK_FonteLegislativaRelazione_Origine] FOREIGN KEY ([FonteLegislativaIdOrigine]) REFERENCES [Standard].[FonteLegislativa] ([FonteLegislativaId]),
    CONSTRAINT [FK_FonteLegislativaRelazione_TipoRelazioneFonte] FOREIGN KEY ([TipoRelazioneFonteId]) REFERENCES [Standard].[TipoRelazioneFonte] ([TipoRelazioneFonteId]),
    CONSTRAINT [UQ_FonteLegislativaRelazione] UNIQUE NONCLUSTERED ([FonteLegislativaIdOrigine] ASC, [FonteLegislativaIdDestinazione] ASC, [TipoRelazioneFonteId] ASC),
    CONSTRAINT [UQ_FonteLegislativaRelazione_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[FonteLegislativaRelazioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante tecnico iniziale della versione della riga, gestito automaticamente da SQL Server.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaRelazione', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note libere sulla relazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaRelazione', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC dell''ultima modifica applicativa del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaRelazione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Relazioni dirette tra fonti legislative: un atto modifica, abroga, integra o sostituisce un altro.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaRelazione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC della cancellazione logica del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaRelazione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.FonteLegislativa. Atto che esercita la relazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaRelazione', @level2type = N'COLUMN', @level2name = N'FonteLegislativaIdOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaRelazione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata della relazione tra fonti.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaRelazione', @level2type = N'COLUMN', @level2name = N'FonteLegislativaRelazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo globale univoco e stabile della riga, utilizzabile per integrazioni e sincronizzazioni.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaRelazione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.TipoRelazioneFonte. Natura della relazione (modifica, abroga, integra...).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaRelazione', @level2type = N'COLUMN', @level2name = N'TipoRelazioneFonteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaRelazione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.FonteLegislativa. Atto interessato dalla relazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaRelazione', @level2type = N'COLUMN', @level2name = N'FonteLegislativaIdDestinazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante tecnico finale della versione della riga, gestito automaticamente da SQL Server.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaRelazione', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC di creazione del record applicativo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaRelazione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

