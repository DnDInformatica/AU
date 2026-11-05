CREATE TABLE [Standard].[ClassificazioneSchemaAccreditamento] (
    [ClassificazioneSchemaAccreditamentoId] INT                                         IDENTITY (1, 1) NOT NULL,
    [ClassificazioneId]                     INT                                         NOT NULL,
    [SchemaAccreditamentoId]                INT                                         NOT NULL,
    [RuoloApplicabilita]                    NVARCHAR (40)                               NOT NULL,
    [RiferimentoDocumentaleId]              INT                                         NOT NULL,
    [Note]                                  NVARCHAR (2000)                             NULL,
    [Attivo]                                BIT                                         CONSTRAINT [DF_ClassSchemaAccreditamento_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                         DATETIME2 (7)                               CONSTRAINT [DF_ClassSchemaAccreditamento_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                              INT                                         NULL,
    [DataModifica]                          DATETIME2 (7)                               NULL,
    [ModificatoDa]                          INT                                         NULL,
    [DataCancellazione]                     DATETIME2 (7)                               NULL,
    [CancellatoDa]                          INT                                         NULL,
    [UniqueRowId]                           UNIQUEIDENTIFIER                            CONSTRAINT [DF_ClassSchemaAccreditamento_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                    DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]                      DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_ClassificazioneSchemaAccreditamento] PRIMARY KEY CLUSTERED ([ClassificazioneSchemaAccreditamentoId] ASC),
    CONSTRAINT [CK_ClassSchemaAccreditamento_Ruolo] CHECK ([RuoloApplicabilita]=N'RACCORDO_STATISTICO' OR [RuoloApplicabilita]=N'TIPOLOGIA' OR [RuoloApplicabilita]=N'CATEGORIZZAZIONE_TECNICA' OR [RuoloApplicabilita]=N'DEFINIZIONE_SCOPE'),
    CONSTRAINT [FK_ClassSchemaAccreditamento_Classificazione] FOREIGN KEY ([ClassificazioneId]) REFERENCES [Standard].[Classificazione] ([ClassificazioneId]),
    CONSTRAINT [FK_ClassSchemaAccreditamento_Riferimento] FOREIGN KEY ([RiferimentoDocumentaleId]) REFERENCES [Standard].[RiferimentoDocumentale] ([RiferimentoDocumentaleId]),
    CONSTRAINT [FK_ClassSchemaAccreditamento_Schema] FOREIGN KEY ([SchemaAccreditamentoId]) REFERENCES [Standard].[SchemaAccreditamento] ([SchemaAccreditamentoId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[ClassificazioneSchemaAccreditamentoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ClassSchemaAccreditamento_Relazione]
    ON [Standard].[ClassificazioneSchemaAccreditamento]([ClassificazioneId] ASC, [SchemaAccreditamentoId] ASC, [RuoloApplicabilita] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ClassSchemaAccreditamento_Schema]
    ON [Standard].[ClassificazioneSchemaAccreditamento]([SchemaAccreditamentoId] ASC, [ClassificazioneId] ASC)
    INCLUDE([RuoloApplicabilita], [Attivo]) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine del periodo di system-versioning gestito da Azure SQL.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo interno della relazione di applicabilita.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'ClassificazioneSchemaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK obbligatoria al documento che giustifica l applicabilita.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'RiferimentoDocumentaleId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio del periodo di system-versioning gestito da Azure SQL.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Relazione N:M temporal e documentata che dichiara dove una classificazione e utilizzata nel catalogo degli schemi di accreditamento.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneSchemaAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica; NULL per la relazione corrente.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ruolo tecnico della classificazione nello schema; non esprime obbligatorieta normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'RuoloApplicabilita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK allo schema o famiglia di accreditamento che utilizza la classificazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'SchemaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente che ha effettuato l ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di attivazione della relazione di applicabilita.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK alla classificazione applicabile.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'ClassificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore GUID stabile della riga.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note curate sul perimetro e sul livello del binding.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell ultima modifica applicativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

