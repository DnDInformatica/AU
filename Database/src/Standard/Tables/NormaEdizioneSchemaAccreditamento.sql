CREATE TABLE [Standard].[NormaEdizioneSchemaAccreditamento] (
    [NormaEdizioneSchemaAccreditamentoId] INT                                                IDENTITY (1, 1) NOT NULL,
    [NormaEdizioneId]                     INT                                                NOT NULL,
    [SchemaAccreditamentoId]              INT                                                NOT NULL,
    [RegimeAccreditamentoId]              TINYINT                                            NOT NULL,
    [ApplicaSenzaSettore]                 BIT                                                DEFAULT ((0)) NOT NULL,
    [DataInizioApplicazione]              DATE                                               NULL,
    [DataFineApplicazione]                DATE                                               NULL,
    [NoteApplicazione]                    NVARCHAR (500)                                     NULL,
    [DataCreazione]                       DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                            INT                                                NULL,
    [DataModifica]                        DATETIME2 (7)                                      NULL,
    [ModificatoDa]                        INT                                                NULL,
    [DataCancellazione]                   DATETIME2 (7)                                      NULL,
    [CancellatoDa]                        INT                                                NULL,
    [UniqueRowId]                         UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                  DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]                    DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_NormaEdizioneSchemaAccreditamento] PRIMARY KEY CLUSTERED ([NormaEdizioneSchemaAccreditamentoId] ASC),
    CONSTRAINT [CK_NESA_DateApplicazione] CHECK ([DataInizioApplicazione] IS NULL OR [DataFineApplicazione] IS NULL OR [DataInizioApplicazione]<=[DataFineApplicazione]),
    CONSTRAINT [FK_NESA_NormaEdizione] FOREIGN KEY ([NormaEdizioneId]) REFERENCES [Standard].[NormaEdizione] ([NormaEdizioneId]),
    CONSTRAINT [FK_NESA_RegimeAccreditamento] FOREIGN KEY ([RegimeAccreditamentoId]) REFERENCES [Tipologica].[RegimeAccreditamento] ([RegimeAccreditamentoId]),
    CONSTRAINT [FK_NESA_SchemaAccreditamento] FOREIGN KEY ([SchemaAccreditamentoId]) REFERENCES [Standard].[SchemaAccreditamento] ([SchemaAccreditamentoId]),
    CONSTRAINT [UQ_NESA_Edizione_Schema] UNIQUE NONCLUSTERED ([NormaEdizioneId] ASC, [SchemaAccreditamentoId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[NormaEdizioneSchemaAccreditamentoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Condizioni specifiche di applicazione. Esempio: "Solo per OdC con scope ISMS", "Richiede anche ISO/IEC 27006", "Applicabile con Amd 1:2020".', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'NoteApplicazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se la norma si applica anche a OdC senza settori EA assegnati (es. norme orizzontali come ISO/IEC 17021-1). Default = 0.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'ApplicaSenzaSettore';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio validita business dell''associazione edizione-schema nel sistema. Non sostituisce le date normative dell''edizione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data da cui è valida l''associazione norma-schema. NULL = valida da sempre. Utile per tracciare quando una norma viene aggiunta a uno schema.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataInizioApplicazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.SchemaAccreditamento. Identifica lo schema di accreditamento a cui l''edizione normativa e associata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'SchemaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Associazione N:M tra NormaEdizione e SchemaAccreditamento nel Modello B. Equivalente di NormaAccreditamentoSchema (Modello A). Aggiunge: DataInizioApplicazione/DataFineApplicazione per validità temporale, NoteApplicazione per condizioni specifiche.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSchemaAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Tipologica.RegimeAccreditamento. Classifica il regime volontario, cogente o misto della coppia edizione-schema.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'RegimeAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata della coppia target edizione normativa-schema di accreditamento. Sostituisce progressivamente NormaAccreditamentoSchema del Modello A.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'NormaEdizioneSchemaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.NormaEdizione. Identifica l''edizione normativa applicabile allo schema di accreditamento. E la chiave target per programmi, scopi e controlli autorizzativi.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'NormaEdizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data fino a cui è valida l''associazione norma-schema. NULL = valida indefinitamente. Valorizzare quando una norma viene rimossa da uno schema senza essere ritirata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataFineApplicazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine validita business dell''associazione edizione-schema nel sistema.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSchemaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

