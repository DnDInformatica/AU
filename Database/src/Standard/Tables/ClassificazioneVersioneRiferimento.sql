CREATE TABLE [Standard].[ClassificazioneVersioneRiferimento] (
    [ClassificazioneVersioneRiferimentoId] INT                                         IDENTITY (1, 1) NOT NULL,
    [ClassificazioneVersioneId]            INT                                         NOT NULL,
    [RiferimentoDocumentaleId]             INT                                         NOT NULL,
    [RuoloRiferimento]                     NVARCHAR (30)                               NOT NULL,
    [PrimarioFlag]                         BIT                                         CONSTRAINT [DF_ClassVersRif_Primario] DEFAULT ((0)) NOT NULL,
    [Attivo]                               BIT                                         CONSTRAINT [DF_ClassVersRif_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                        DATETIME2 (7)                               CONSTRAINT [DF_ClassVersRif_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                             INT                                         NULL,
    [DataModifica]                         DATETIME2 (7)                               NULL,
    [ModificatoDa]                         INT                                         NULL,
    [DataCancellazione]                    DATETIME2 (7)                               NULL,
    [CancellatoDa]                         INT                                         NULL,
    [UniqueRowId]                          UNIQUEIDENTIFIER                            CONSTRAINT [DF_ClassVersRif_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                   DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]                     DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_ClassVersRif] PRIMARY KEY CLUSTERED ([ClassificazioneVersioneRiferimentoId] ASC),
    CONSTRAINT [CK_ClassVersRif_Ruolo] CHECK ([RuoloRiferimento]=N'Ritira' OR [RuoloRiferimento]=N'Corrispondenza' OR [RuoloRiferimento]=N'Descrive' OR [RuoloRiferimento]=N'Modifica' OR [RuoloRiferimento]=N'Istituisce'),
    CONSTRAINT [FK_ClassVersRif_Documento] FOREIGN KEY ([RiferimentoDocumentaleId]) REFERENCES [Standard].[RiferimentoDocumentale] ([RiferimentoDocumentaleId]),
    CONSTRAINT [FK_ClassVersRif_Versione] FOREIGN KEY ([ClassificazioneVersioneId]) REFERENCES [Standard].[ClassificazioneVersione] ([ClassificazioneVersioneId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[ClassificazioneVersioneRiferimentoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ClassVersRif_Vers_Doc_Ruolo]
    ON [Standard].[ClassificazioneVersioneRiferimento]([ClassificazioneVersioneId] ASC, [RiferimentoDocumentaleId] ASC, [RuoloRiferimento] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ClassVersRif_CreatoDa]
    ON [Standard].[ClassificazioneVersioneRiferimento]([CreatoDa] ASC);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ClassVersRif_UnSoloPrimario]
    ON [Standard].[ClassificazioneVersioneRiferimento]([ClassificazioneVersioneId] ASC) WHERE ([PrimarioFlag]=(1) AND [DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ClassVersRif_DataCancellazione]
    ON [Standard].[ClassificazioneVersioneRiferimento]([DataCancellazione] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ClassVersRif_Documento]
    ON [Standard].[ClassificazioneVersioneRiferimento]([RiferimentoDocumentaleId] ASC)
    INCLUDE([ClassificazioneVersioneId], [RuoloRiferimento], [PrimarioFlag]) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio del periodo di system-versioning gestito da Azure SQL.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRiferimento', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ruolo del documento rispetto alla versione: Istituisce, Modifica, Descrive, Corrispondenza o Ritira.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRiferimento', @level2type = N'COLUMN', @level2name = N'RuoloRiferimento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica della relazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRiferimento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria tecnica della relazione versione-documento.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRiferimento', @level2type = N'COLUMN', @level2name = N'ClassificazioneVersioneRiferimentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK al documento ufficiale associato alla versione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRiferimento', @level2type = N'COLUMN', @level2name = N'RiferimentoDocumentaleId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore GUID stabile della relazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRiferimento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente che ha effettuato l ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRiferimento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Relazione N:M temporale tra una versione di classificazione e i documenti che la istituiscono, modificano, descrivono, raccordano o ritirano.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRiferimento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione della relazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRiferimento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK alla versione della classificazione documentata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRiferimento', @level2type = N'COLUMN', @level2name = N'ClassificazioneVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell ultima modifica applicativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRiferimento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di attivazione della relazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRiferimento', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente che ha creato la relazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRiferimento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine del periodo di system-versioning gestito da Azure SQL.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRiferimento', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica il riferimento primario esposto anche dalla scorciatoia ClassificazioneVersione.RiferimentoDocumentaleId.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRiferimento', @level2type = N'COLUMN', @level2name = N'PrimarioFlag';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente che ha cancellato logicamente la relazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRiferimento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

