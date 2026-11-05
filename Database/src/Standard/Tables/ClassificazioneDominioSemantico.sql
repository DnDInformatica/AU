CREATE TABLE [Standard].[ClassificazioneDominioSemantico] (
    [ClassificazioneDominioSemanticoId] INT                                         IDENTITY (1, 1) NOT NULL,
    [ClassificazioneId]                 INT                                         NOT NULL,
    [DominioSemanticoId]                INT                                         NOT NULL,
    [RuoloDominio]                      NVARCHAR (20)                               NOT NULL,
    [RiferimentoDocumentaleId]          INT                                         NULL,
    [Motivazione]                       NVARCHAR (2000)                             NULL,
    [Attivo]                            BIT                                         CONSTRAINT [DF_ClassDominioSemantico_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                     DATETIME2 (7)                               CONSTRAINT [DF_ClassDominioSemantico_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                          INT                                         NULL,
    [DataModifica]                      DATETIME2 (7)                               NULL,
    [ModificatoDa]                      INT                                         NULL,
    [DataCancellazione]                 DATETIME2 (7)                               NULL,
    [CancellatoDa]                      INT                                         NULL,
    [UniqueRowId]                       UNIQUEIDENTIFIER                            CONSTRAINT [DF_ClassDominioSemantico_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]                  DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_ClassificazioneDominioSemantico] PRIMARY KEY CLUSTERED ([ClassificazioneDominioSemanticoId] ASC),
    CONSTRAINT [CK_ClassDominioSemantico_Ruolo] CHECK ([RuoloDominio]=N'SECONDARIO' OR [RuoloDominio]=N'PRIMARIO'),
    CONSTRAINT [FK_ClassDominioSemantico_Classificazione] FOREIGN KEY ([ClassificazioneId]) REFERENCES [Standard].[Classificazione] ([ClassificazioneId]),
    CONSTRAINT [FK_ClassDominioSemantico_Dominio] FOREIGN KEY ([DominioSemanticoId]) REFERENCES [Standard].[DominioSemantico] ([DominioSemanticoId]),
    CONSTRAINT [FK_ClassDominioSemantico_Riferimento] FOREIGN KEY ([RiferimentoDocumentaleId]) REFERENCES [Standard].[RiferimentoDocumentale] ([RiferimentoDocumentaleId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[ClassificazioneDominioSemanticoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ClassDominioSemantico_Coppia]
    ON [Standard].[ClassificazioneDominioSemantico]([ClassificazioneId] ASC, [DominioSemanticoId] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ClassDominioSemantico_Primario]
    ON [Standard].[ClassificazioneDominioSemantico]([ClassificazioneId] ASC) WHERE ([RuoloDominio]=N'PRIMARIO' AND [DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ClassDominioSemantico_Dominio]
    ON [Standard].[ClassificazioneDominioSemantico]([DominioSemanticoId] ASC, [ClassificazioneId] ASC)
    INCLUDE([RuoloDominio], [Attivo]) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica; NULL per la relazione corrente.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneDominioSemantico', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine del periodo di system-versioning gestito da Azure SQL.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneDominioSemantico', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneDominioSemantico', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ruolo del dominio: PRIMARIO oppure SECONDARIO.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneDominioSemantico', @level2type = N'COLUMN', @level2name = N'RuoloDominio';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Relazione N:M temporal fra classificazioni e domini semantici, con un solo dominio primario corrente per classificazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneDominioSemantico';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio del periodo di system-versioning gestito da Azure SQL.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneDominioSemantico', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di attivazione della relazione semantica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneDominioSemantico', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente che ha effettuato l ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneDominioSemantico', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK al dominio semantico associato.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneDominioSemantico', @level2type = N'COLUMN', @level2name = N'DominioSemanticoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore GUID stabile della riga.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneDominioSemantico', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell ultima modifica applicativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneDominioSemantico', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK alla classificazione descritta.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneDominioSemantico', @level2type = N'COLUMN', @level2name = N'ClassificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Motivazione curata dell attribuzione del dominio.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneDominioSemantico', @level2type = N'COLUMN', @level2name = N'Motivazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneDominioSemantico', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneDominioSemantico', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento documentale facoltativo che supporta l attribuzione semantica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneDominioSemantico', @level2type = N'COLUMN', @level2name = N'RiferimentoDocumentaleId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo interno della relazione semantica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneDominioSemantico', @level2type = N'COLUMN', @level2name = N'ClassificazioneDominioSemanticoId';


GO

