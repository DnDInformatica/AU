CREATE TABLE [Standard].[SchemaCertificazioneProprietario] (
    [SchemaCertificazioneProprietarioId] INT                                                IDENTITY (1, 1) NOT NULL,
    [Codice]                             NVARCHAR (100)                                     NOT NULL,
    [Denominazione]                      NVARCHAR (600)                                     NOT NULL,
    [Nazione]                            NVARCHAR (100)                                     NULL,
    [SitoWeb]                            NVARCHAR (1000)                                    NULL,
    [Note]                               NVARCHAR (4000)                                    NULL,
    [Attivo]                             BIT                                                CONSTRAINT [DF_SchCertProprietario_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                      DATETIME2 (7)                                      CONSTRAINT [DF_SchCertProprietario_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                           INT                                                NULL,
    [DataModifica]                       DATETIME2 (7)                                      NULL,
    [ModificatoDa]                       INT                                                NULL,
    [DataCancellazione]                  DATETIME2 (7)                                      NULL,
    [CancellatoDa]                       INT                                                NULL,
    [UniqueRowId]                        UNIQUEIDENTIFIER                                   CONSTRAINT [DF_SchCertProprietario_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                 DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]                   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [TipoProprietarioId]                 INT                                                NOT NULL,
    CONSTRAINT [PK_SchemaCertificazioneProprietario] PRIMARY KEY CLUSTERED ([SchemaCertificazioneProprietarioId] ASC),
    CONSTRAINT [FK_SchCertProprietario_TipoProprietario] FOREIGN KEY ([TipoProprietarioId]) REFERENCES [Standard].[TipoProprietario] ([TipoProprietarioId]),
    CONSTRAINT [UQ_SchCertProprietario_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    CONSTRAINT [UQ_SchCertProprietario_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[SchemaCertificazioneProprietarioStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_SchCertProprietario_TipoProprietarioId]
    ON [Standard].[SchemaCertificazioneProprietario]([TipoProprietarioId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.TipoProprietario: tipologia normalizzata del proprietario (AUTORITA_PUBBLICA/TERZA_PARTE/ODC). Sostituisce il precedente TipoProprietario varchar con CHECK inline.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneProprietario', @level2type = N'COLUMN', @level2name = N'TipoProprietarioId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Denominazione ufficiale del proprietario dello schema.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneProprietario', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo tecnico del proprietario dello schema di certificazione. Chiave primaria surrogate.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneProprietario', @level2type = N'COLUMN', @level2name = N'SchemaCertificazioneProprietarioId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice sintetico univoco del proprietario dello schema (es. FSSC-FOUNDATION, CERTIPASS, AUTORITA-FGAS-IT).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneProprietario', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Scheme owner: organizzazione responsabile dello sviluppo e mantenimento di uno schema di certificazione (ISO/IEC 17024 Cl.8; ISO/IEC 17067 par.6.3.3: legal entity). Puo'' essere un OdC, un''autorita'' pubblica o una terza parte. Normalizza la colonna testuale SchemeOwner del Modello A.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneProprietario';


GO

