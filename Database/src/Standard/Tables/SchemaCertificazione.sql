CREATE TABLE [Standard].[SchemaCertificazione] (
    [SchemaCertificazioneId]             INT                                                IDENTITY (1, 1) NOT NULL,
    [Codice]                             NVARCHAR (100)                                     NOT NULL,
    [Denominazione]                      NVARCHAR (600)                                     NOT NULL,
    [DenominazioneEng]                   NVARCHAR (600)                                     NULL,
    [SchemaCertificazioneProprietarioId] INT                                                NOT NULL,
    [AmbitoCertificazione]               VARCHAR (30)                                       NOT NULL,
    [Descrizione]                        NVARCHAR (4000)                                    NULL,
    [Attivo]                             BIT                                                CONSTRAINT [DF_SchemaCertificazione_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                      DATETIME2 (7)                                      CONSTRAINT [DF_SchemaCertificazione_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                           INT                                                NULL,
    [DataModifica]                       DATETIME2 (7)                                      NULL,
    [ModificatoDa]                       INT                                                NULL,
    [DataCancellazione]                  DATETIME2 (7)                                      NULL,
    [CancellatoDa]                       INT                                                NULL,
    [UniqueRowId]                        UNIQUEIDENTIFIER                                   CONSTRAINT [DF_SchemaCertificazione_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                 DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]                   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_SchemaCertificazione] PRIMARY KEY CLUSTERED ([SchemaCertificazioneId] ASC),
    CONSTRAINT [CK_SchemaCertificazione_Ambito] CHECK ([AmbitoCertificazione]='ALTRO' OR [AmbitoCertificazione]='ISPEZIONE' OR [AmbitoCertificazione]='SISTEMI' OR [AmbitoCertificazione]='PRODOTTI' OR [AmbitoCertificazione]='PERSONE'),
    CONSTRAINT [FK_SchemaCertificazione_Proprietario] FOREIGN KEY ([SchemaCertificazioneProprietarioId]) REFERENCES [Standard].[SchemaCertificazioneProprietario] ([SchemaCertificazioneProprietarioId]),
    CONSTRAINT [UQ_SchemaCertificazione_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    CONSTRAINT [UQ_SchemaCertificazione_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[SchemaCertificazioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_SchemaCertificazione_Proprietario]
    ON [Standard].[SchemaCertificazione]([SchemaCertificazioneProprietarioId] ASC)
    INCLUDE([Codice], [Denominazione], [Attivo]);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso il proprietario (scheme owner) responsabile dello schema.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazione', @level2type = N'COLUMN', @level2name = N'SchemaCertificazioneProprietarioId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice sintetico univoco dello schema (es. FSSC-22000, FGAS-PERSONA, PED-PERS-GIUNZIONI).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazione', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Denominazione autorevole dello schema di certificazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazione', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ambito di valutazione della conformita'': PERSONE, PRODOTTI, SISTEMI, ISPEZIONE, ALTRO.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazione', @level2type = N'COLUMN', @level2name = N'AmbitoCertificazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo tecnico dell''identita'' autorevole dello schema di certificazione. Chiave primaria surrogate.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazione', @level2type = N'COLUMN', @level2name = N'SchemaCertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identita'' autorevole generale di uno schema di certificazione (certification scheme ex ISO/IEC 17024 Cl.8 / ISO/IEC 17067). Distinto da: Standard.SchemaAccreditamento (schema di accreditamento ISP/PRS/MS), Standard.NormaFamiglia/NormaEdizione (norma tecnica), Certificazione.ProgrammaCertificazione (uso operativo). Esempi: FSSC 22000, FAMI-QS, EASI, EIPASS, Schema Fgas Persona, PED Approvazione personale giunzioni permanenti.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazione';


GO

