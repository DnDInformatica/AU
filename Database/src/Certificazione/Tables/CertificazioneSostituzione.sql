CREATE TABLE [Certificazione].[CertificazioneSostituzione] (
    [CertificazioneSostituzioneId] INT                                         IDENTITY (1, 1) NOT NULL,
    [CertificazioneId]             INT                                         NOT NULL,
    [CertificazioneSostituitaId]   INT                                         NULL,
    [NumeroCertificatoPrecedente]  NVARCHAR (200)                              NOT NULL,
    [TipoFonteLegameId]            INT                                         NOT NULL,
    [DataEfficacia]                DATE                                        NULL,
    [Note]                         NVARCHAR (1000)                             NULL,
    [DataCreazione]                DATETIME2 (7)                               CONSTRAINT [DF_CertSost_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                     INT                                         NULL,
    [DataModifica]                 DATETIME2 (7)                               NULL,
    [ModificatoDa]                 INT                                         NULL,
    [DataCancellazione]            DATETIME2 (7)                               NULL,
    [CancellatoDa]                 INT                                         NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER                            CONSTRAINT [DF_CertSost_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]           DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]             DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_CertificazioneSostituzione] PRIMARY KEY CLUSTERED ([CertificazioneSostituzioneId] ASC),
    CONSTRAINT [CK_CertSost_NoAutoRiferimento] CHECK ([CertificazioneSostituitaId] IS NULL OR [CertificazioneSostituitaId]<>[CertificazioneId]),
    CONSTRAINT [CK_CertSost_NumeroNonVuoto] CHECK (len(ltrim(rtrim([NumeroCertificatoPrecedente])))>(0)),
    CONSTRAINT [FK_CertSost_Certificazione] FOREIGN KEY ([CertificazioneId]) REFERENCES [Certificazione].[Certificazione] ([CertificazioneId]),
    CONSTRAINT [FK_CertSost_Sostituita] FOREIGN KEY ([CertificazioneSostituitaId]) REFERENCES [Certificazione].[Certificazione] ([CertificazioneId]),
    CONSTRAINT [FK_CertSost_TipoFonte] FOREIGN KEY ([TipoFonteLegameId]) REFERENCES [Certificazione].[TipoFonteLegame] ([TipoFonteLegameId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Certificazione].[CertificazioneSostituzioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_CertSost_Certificazione_Numero]
    ON [Certificazione].[CertificazioneSostituzione]([CertificazioneId] ASC, [NumeroCertificatoPrecedente] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_CertSost_Sostituita]
    ON [Certificazione].[CertificazioneSostituzione]([CertificazioneSostituitaId] ASC)
    INCLUDE([CertificazioneId], [TipoFonteLegameId]);


GO

