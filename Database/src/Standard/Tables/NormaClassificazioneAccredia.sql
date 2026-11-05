CREATE TABLE [Standard].[NormaClassificazioneAccredia] (
    [NormaClassificazioneAccrediaId] INT                                                IDENTITY (1, 1) NOT NULL,
    [NormaEdizioneId]                INT                                                NOT NULL,
    [RiferimentoEA]                  NVARCHAR (100)                                     NULL,
    [RiferimentoIAF]                 NVARCHAR (100)                                     NULL,
    [RiferimentoILAC]                NVARCHAR (100)                                     NULL,
    [CodiceIAF]                      NVARCHAR (50)                                      NULL,
    [CodiceEA]                       NVARCHAR (50)                                      NULL,
    [Note]                           NVARCHAR (1000)                                    NULL,
    [Attivo]                         BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]                  DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                       INT                                                NULL,
    [DataModifica]                   DATETIME2 (7)                                      NULL,
    [ModificatoDa]                   INT                                                NULL,
    [DataCancellazione]              DATETIME2 (7)                                      NULL,
    [CancellatoDa]                   INT                                                NULL,
    [UniqueRowId]                    UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DipartimentoAccrediaId]         INT                                                NULL,
    [SettoreAccrediaId]              INT                                                NOT NULL,
    [DataInizioValidita]             DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]               DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_NormaClassificazioneAccredia] PRIMARY KEY CLUSTERED ([NormaClassificazioneAccrediaId] ASC),
    CONSTRAINT [FK_NormaClassificazioneAccredia_DipartimentoAccredia] FOREIGN KEY ([DipartimentoAccrediaId]) REFERENCES [Tipologica].[DipartimentoAccredia] ([DipartimentoAccrediaId]),
    CONSTRAINT [FK_NormaClassificazioneAccredia_Edizione] FOREIGN KEY ([NormaEdizioneId]) REFERENCES [Standard].[NormaEdizione] ([NormaEdizioneId]),
    CONSTRAINT [FK_NormaClassificazioneAccredia_SettoreAccredia] FOREIGN KEY ([SettoreAccrediaId]) REFERENCES [Tipologica].[SettoreAccredia] ([SettoreAccrediaId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[NormaClassificazioneAccrediaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata del mapping fra edizione normativa e classificazioni ACCREDIA/EA/IAF/ILAC o settore interno.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaClassificazioneAccredia', @level2type = N'COLUMN', @level2name = N'NormaClassificazioneAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Settore Accredia associato alla specifica edizione normativa. Da usare per controlli strutturati al posto di descrizioni testuali non vincolate.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaClassificazioneAccredia', @level2type = N'COLUMN', @level2name = N'SettoreAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.NormaEdizione. Collega classificazioni e riferimenti esterni alla specifica edizione normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaClassificazioneAccredia', @level2type = N'COLUMN', @level2name = N'NormaEdizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaClassificazioneAccredia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice EA collegato all''edizione, quando applicabile. Campo di mapping, non sostituisce una tassonomia versionata se disponibile.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaClassificazioneAccredia', @level2type = N'COLUMN', @level2name = N'CodiceEA';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Classificazione Accredia, EA, IAF e ILAC associata alla specifica edizione normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaClassificazioneAccredia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dipartimento ACCREDIA competente o prevalente per la classificazione della specifica edizione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaClassificazioneAccredia', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaClassificazioneAccredia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaClassificazioneAccredia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice IAF collegato all''edizione, quando applicabile. Campo di mapping, non sostituisce una tassonomia versionata se disponibile.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaClassificazioneAccredia', @level2type = N'COLUMN', @level2name = N'CodiceIAF';


GO

