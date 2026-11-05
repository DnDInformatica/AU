CREATE TABLE [Standard].[SchemaCertificazioneVersione] (
    [SchemaCertificazioneVersioneId] INT                                                IDENTITY (1, 1) NOT NULL,
    [SchemaCertificazioneId]         INT                                                NOT NULL,
    [CodiceVersione]                 NVARCHAR (100)                                     NOT NULL,
    [Denominazione]                  NVARCHAR (600)                                     NULL,
    [StatoNormaId]                   INT                                                NOT NULL,
    [DataPubblicazione]              DATE                                               NULL,
    [DataEntrataInVigore]            DATE                                               NULL,
    [DataRitiro]                     DATE                                               NULL,
    [DataFineTransizione]            DATE                                               NULL,
    [Note]                           NVARCHAR (4000)                                    NULL,
    [Attivo]                         BIT                                                CONSTRAINT [DF_SchCertVersione_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                  DATETIME2 (7)                                      CONSTRAINT [DF_SchCertVersione_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                       INT                                                NULL,
    [DataModifica]                   DATETIME2 (7)                                      NULL,
    [ModificatoDa]                   INT                                                NULL,
    [DataCancellazione]              DATETIME2 (7)                                      NULL,
    [CancellatoDa]                   INT                                                NULL,
    [UniqueRowId]                    UNIQUEIDENTIFIER                                   CONSTRAINT [DF_SchCertVersione_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]             DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]               DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_SchemaCertificazioneVersione] PRIMARY KEY CLUSTERED ([SchemaCertificazioneVersioneId] ASC),
    CONSTRAINT [FK_SchCertVersione_Schema] FOREIGN KEY ([SchemaCertificazioneId]) REFERENCES [Standard].[SchemaCertificazione] ([SchemaCertificazioneId]),
    CONSTRAINT [FK_SchCertVersione_StatoNorma] FOREIGN KEY ([StatoNormaId]) REFERENCES [Standard].[StatoNorma] ([StatoNormaId]),
    CONSTRAINT [UQ_SchCertVersione_Schema_Codice] UNIQUE NONCLUSTERED ([SchemaCertificazioneId] ASC, [CodiceVersione] ASC),
    CONSTRAINT [UQ_SchCertVersione_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[SchemaCertificazioneVersioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_SchCertVersione_Stato]
    ON [Standard].[SchemaCertificazioneVersione]([StatoNormaId] ASC)
    INCLUDE([SchemaCertificazioneId], [CodiceVersione]);


GO

CREATE NONCLUSTERED INDEX [IX_SchCertVersione_Schema]
    ON [Standard].[SchemaCertificazioneVersione]([SchemaCertificazioneId] ASC)
    INCLUDE([CodiceVersione], [StatoNormaId], [Attivo]);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso l''identita'' autorevole dello schema.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'SchemaCertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Versione/revisione ufficiale dello schema di certificazione (riesame e validazione sistematici ex ISO/IEC 17024 Cl.8). Es.: FSSC 22000 v5.1/v6; EASI rev.3/rev.4; Schema Fgas Persona ediz. DPR 43/2012 (ritirata) e DPR 146/2018 (vigente). Stato tramite riuso pragmatico di Standard.StatoNorma come stato di vigenza/versione: il riuso non implica che lo schema certificativo sia una norma tecnica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneVersione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo tecnico della versione/revisione ufficiale dello schema di certificazione. Chiave primaria surrogate.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'SchemaCertificazioneVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stato della versione (riuso pragmatico di Standard.StatoNorma: Vigente/InTransizione/Ritirata). Non classifica lo schema come norma tecnica; rappresenta solo il ciclo di vita della versione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'StatoNormaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice della versione/revisione (es. 6, rev.4, DPR 146/2018). Univoco per schema.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'CodiceVersione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Denominazione o titolo della specifica versione/revisione dello schema, quando diversa o piu'' specifica rispetto alla denominazione stabile dello schema.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di ritiro/abrogazione della versione (storicizzazione time-aware).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'DataRitiro';


GO

