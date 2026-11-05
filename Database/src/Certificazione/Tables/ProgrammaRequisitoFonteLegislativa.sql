CREATE TABLE [Certificazione].[ProgrammaRequisitoFonteLegislativa] (
    [ProgrammaRequisitoFonteLegislativaId] INT                                                IDENTITY (1, 1) NOT NULL,
    [ProgrammaRequisitoId]                 INT                                                NOT NULL,
    [FonteLegislativaPartizioneId]         INT                                                NOT NULL,
    [Note]                                 NVARCHAR (500)                                     NULL,
    [DataCreazione]                        DATETIME2 (7)                                      CONSTRAINT [DF_ProgrammaRequisitoFonteLegislativa_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                             INT                                                NULL,
    [DataModifica]                         DATETIME2 (7)                                      NULL,
    [ModificatoDa]                         INT                                                NULL,
    [DataCancellazione]                    DATETIME2 (7)                                      NULL,
    [CancellatoDa]                         INT                                                NULL,
    [UniqueRowId]                          UNIQUEIDENTIFIER                                   CONSTRAINT [DF_ProgrammaRequisitoFonteLegislativa_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita]                   DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_ProgrammaRequisitoFonteLegislativa_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]                     DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_ProgrammaRequisitoFonteLegislativa_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_ProgrammaRequisitoFonteLegislativa] PRIMARY KEY CLUSTERED ([ProgrammaRequisitoFonteLegislativaId] ASC),
    CONSTRAINT [CK_ProgrammaRequisitoFonteLegislativa_Cancellazione] CHECK ([DataCancellazione] IS NULL AND [CancellatoDa] IS NULL OR [DataCancellazione] IS NOT NULL),
    CONSTRAINT [FK_ProgrammaRequisitoFonteLegislativa_Partizione] FOREIGN KEY ([FonteLegislativaPartizioneId]) REFERENCES [Standard].[FonteLegislativaPartizione] ([FonteLegislativaPartizioneId]),
    CONSTRAINT [FK_ProgrammaRequisitoFonteLegislativa_ProgrammaRequisito] FOREIGN KEY ([ProgrammaRequisitoId]) REFERENCES [Certificazione].[ProgrammaRequisito] ([ProgrammaRequisitoId]),
    CONSTRAINT [UQ_ProgrammaRequisitoFonteLegislativa] UNIQUE NONCLUSTERED ([ProgrammaRequisitoId] ASC, [FonteLegislativaPartizioneId] ASC),
    CONSTRAINT [UQ_ProgrammaRequisitoFonteLegislativa_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Certificazione].[ProgrammaRequisitoFonteLegislativaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoFonteLegislativa', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC di creazione del record applicativo.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoFonteLegislativa', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante tecnico finale della versione della riga, gestito automaticamente da SQL Server.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoFonteLegislativa', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoFonteLegislativa', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.FonteLegislativaPartizione. Partizione (o intera fonte) richiamata dal requisito.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoFonteLegislativa', @level2type = N'COLUMN', @level2name = N'FonteLegislativaPartizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoFonteLegislativa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante tecnico iniziale della versione della riga, gestito automaticamente da SQL Server.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoFonteLegislativa', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC dell''ultima modifica applicativa del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoFonteLegislativa', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Certificazione.ProgrammaRequisito. Requisito di programma che richiama la fonte.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoFonteLegislativa', @level2type = N'COLUMN', @level2name = N'ProgrammaRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Associazione tra un requisito di programma di certificazione e la partizione di fonte legislativa che lo fonda. Il programma richiama la fonte, non la possiede.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoFonteLegislativa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note sul richiamo.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoFonteLegislativa', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoFonteLegislativa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoFonteLegislativa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC della cancellazione logica del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoFonteLegislativa', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo globale univoco e stabile della riga, utilizzabile per integrazioni e sincronizzazioni.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoFonteLegislativa', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoFonteLegislativa', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata del collegamento requisito-fonte.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoFonteLegislativa', @level2type = N'COLUMN', @level2name = N'ProgrammaRequisitoFonteLegislativaId';


GO

