CREATE TABLE [Standard].[RiferimentoDocumentaleRelazione] (
    [RiferimentoDocumentaleRelazioneId] INT                                         IDENTITY (1, 1) NOT NULL,
    [RiferimentoOrigineId]              INT                                         NOT NULL,
    [RiferimentoDestinazioneId]         INT                                         NOT NULL,
    [TipoRelazione]                     NVARCHAR (40)                               NOT NULL,
    [DataDecorrenza]                    DATE                                        NULL,
    [Note]                              NVARCHAR (1000)                             NULL,
    [Attivo]                            BIT                                         CONSTRAINT [DF_RifDocRel_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                     DATETIME2 (7)                               CONSTRAINT [DF_RifDocRel_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                          INT                                         NULL,
    [DataModifica]                      DATETIME2 (7)                               NULL,
    [ModificatoDa]                      INT                                         NULL,
    [DataCancellazione]                 DATETIME2 (7)                               NULL,
    [CancellatoDa]                      INT                                         NULL,
    [UniqueRowId]                       UNIQUEIDENTIFIER                            CONSTRAINT [DF_RifDocRel_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]                  DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_RifDocRelazione] PRIMARY KEY CLUSTERED ([RiferimentoDocumentaleRelazioneId] ASC),
    CONSTRAINT [CK_RifDocRel_NoAutoRelazione] CHECK ([RiferimentoOrigineId]<>[RiferimentoDestinazioneId]),
    CONSTRAINT [CK_RifDocRel_TipoRelazione] CHECK ([TipoRelazione]=N'Rinomina' OR [TipoRelazione]=N'Separa' OR [TipoRelazione]=N'Consolida' OR [TipoRelazione]=N'Archivia' OR [TipoRelazione]=N'Recepisce' OR [TipoRelazione]=N'Adotta' OR [TipoRelazione]=N'Sostituisce'),
    CONSTRAINT [FK_RifDocRel_Destinazione] FOREIGN KEY ([RiferimentoDestinazioneId]) REFERENCES [Standard].[RiferimentoDocumentale] ([RiferimentoDocumentaleId]),
    CONSTRAINT [FK_RifDocRel_Origine] FOREIGN KEY ([RiferimentoOrigineId]) REFERENCES [Standard].[RiferimentoDocumentale] ([RiferimentoDocumentaleId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[RiferimentoDocumentaleRelazioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_RifDocRel_Origine_Dest_Tipo]
    ON [Standard].[RiferimentoDocumentaleRelazione]([RiferimentoOrigineId] ASC, [RiferimentoDestinazioneId] ASC, [TipoRelazione] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_RifDocRel_DataCancellazione]
    ON [Standard].[RiferimentoDocumentaleRelazione]([DataCancellazione] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_RifDocRel_Origine]
    ON [Standard].[RiferimentoDocumentaleRelazione]([RiferimentoOrigineId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_RifDocRel_Destinazione]
    ON [Standard].[RiferimentoDocumentaleRelazione]([RiferimentoDestinazioneId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_RifDocRel_CreatoDa]
    ON [Standard].[RiferimentoDocumentaleRelazione]([CreatoDa] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'TipoRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK al documento origine (soggetto della relazione, es. documento nuovo/adottante).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'RiferimentoOrigineId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di decorrenza della relazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataDecorrenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'RiferimentoDocumentaleRelazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente della cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di attivazione del record (1 = attivo).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'RiferimentoDestinazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo relazione: Sostituisce | Adotta | Recepisce | Archivia | Consolida | Separa | Rinomina. Verso: Origine -> [Tipo] -> Destinazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'TipoRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'RiferimentoDocumentaleRelazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'TipoRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'RiferimentoDestinazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio periodo di system-versioning (ROW START).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'RiferimentoDocumentaleRelazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente creatore.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'RiferimentoDestinazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo univoco di riga (GUID) stabile nel tempo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete); NULL se non cancellato.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataDecorrenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'RiferimentoOrigineId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ASSOCIAZIONE', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente dell''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'TipoRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'RiferimentoOrigineId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataDecorrenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'RiferimentoDocumentaleRelazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK al documento destinazione (oggetto della relazione, es. documento sostituito/adottato).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'RiferimentoDestinazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'RiferimentoOrigineId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataDecorrenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Relazioni tra documenti (successione, adozione, recepimento, archiviazione, consolidamento, separazione, rinomina): gestisce split/merge e rebrand oltre la sostituzione 1:1.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note libere sulla relazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine periodo di system-versioning (ROW END).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'RiferimentoDocumentaleRelazione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

