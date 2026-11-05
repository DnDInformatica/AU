CREATE TABLE [Tipologica].[SettoreAccredia] (
    [SettoreAccrediaId]      INT                                                IDENTITY (1, 1) NOT NULL,
    [DipartimentoAccrediaId] INT                                                NOT NULL,
    [Codice]                 NVARCHAR (50)                                      NOT NULL,
    [Descrizione]            NVARCHAR (200)                                     NOT NULL,
    [DescrizioneEstesa]      NVARCHAR (500)                                     NULL,
    [Ordine]                 INT                                                DEFAULT ((0)) NOT NULL,
    [Attivo]                 BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]          DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]               INT                                                NULL,
    [DataModifica]           DATETIME2 (7)                                      NULL,
    [ModificatoDa]           INT                                                NULL,
    [DataCancellazione]      DATETIME2 (7)                                      NULL,
    [CancellatoDa]           INT                                                NULL,
    [UniqueRowId]            UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]     DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [ClassificazioneId]      INT                                                NULL,
    CONSTRAINT [PK_SettoreAccredia] PRIMARY KEY CLUSTERED ([SettoreAccrediaId] ASC),
    CONSTRAINT [CK_SettoreAccredia_Codice] CHECK (len(ltrim(rtrim([Codice])))>(0)),
    CONSTRAINT [CK_SettoreAccredia_Descrizione] CHECK (len(ltrim(rtrim([Descrizione])))>(0)),
    CONSTRAINT [FK_SettoreAccredia_Classificazione] FOREIGN KEY ([ClassificazioneId]) REFERENCES [Standard].[Classificazione] ([ClassificazioneId]),
    CONSTRAINT [FK_SettoreAccredia_DipartimentoAccredia] FOREIGN KEY ([DipartimentoAccrediaId]) REFERENCES [Tipologica].[DipartimentoAccredia] ([DipartimentoAccrediaId]),
    CONSTRAINT [UQ_SettoreAccredia_Dipartimento_Codice] UNIQUE NONCLUSTERED ([DipartimentoAccrediaId] ASC, [Codice] ASC),
    CONSTRAINT [UQ_SettoreAccredia_Dipartimento_Descrizione] UNIQUE NONCLUSTERED ([DipartimentoAccrediaId] ASC, [Descrizione] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Tipologica].[SettoreAccrediaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_SettoreAccredia_Classificazione_Codice]
    ON [Tipologica].[SettoreAccredia]([ClassificazioneId] ASC, [Codice] ASC) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'SettoreAccredia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ordinamento del settore nel contesto del dipartimento.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'SettoreAccredia', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice univoco del settore nel contesto del dipartimento.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'SettoreAccredia', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione breve del settore Accredia.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'SettoreAccredia', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo univoco globale del settore Accredia.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'SettoreAccredia', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogata del settore Accredia.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'SettoreAccredia', @level2type = N'COLUMN', @level2name = N'SettoreAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dipartimento Accredia a cui appartiene il settore.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'SettoreAccredia', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se il settore Accredia è attivo.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'SettoreAccredia', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'SettoreAccredia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data UTC di creazione del settore Accredia.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'SettoreAccredia', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipologica dei settori Accredia normalizzati per dipartimento.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'SettoreAccredia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'SettoreAccredia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione estesa del settore Accredia.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'SettoreAccredia', @level2type = N'COLUMN', @level2name = N'DescrizioneEstesa';


GO

