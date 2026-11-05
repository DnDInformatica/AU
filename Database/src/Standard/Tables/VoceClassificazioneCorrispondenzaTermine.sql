CREATE TABLE [Standard].[VoceClassificazioneCorrispondenzaTermine] (
    [VoceClassificazioneCorrispondenzaTermineId] INT                                         IDENTITY (1, 1) NOT NULL,
    [VoceClassificazioneCorrispondenzaId]        INT                                         NOT NULL,
    [ClassificazioneVersioneDestinazioneId]      INT                                         NOT NULL,
    [ClassificazioneDestinazioneId]              INT                                         NOT NULL,
    [VoceDestinazioneId]                         INT                                         NOT NULL,
    [Operatore]                                  NVARCHAR (10)                               NOT NULL,
    [EstensioneDestinazione]                     NVARCHAR (30)                               NOT NULL,
    [Ordine]                                     INT                                         NOT NULL,
    [Note]                                       NVARCHAR (2000)                             NULL,
    [Attivo]                                     BIT                                         CONSTRAINT [DF_VoceClassCorrTermine_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                              DATETIME2 (7)                               CONSTRAINT [DF_VoceClassCorrTermine_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                                   INT                                         NULL,
    [DataModifica]                               DATETIME2 (7)                               NULL,
    [ModificatoDa]                               INT                                         NULL,
    [DataCancellazione]                          DATETIME2 (7)                               NULL,
    [CancellatoDa]                               INT                                         NULL,
    [UniqueRowId]                                UNIQUEIDENTIFIER                            CONSTRAINT [DF_VoceClassCorrTermine_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                         DATETIME2 (7) GENERATED ALWAYS AS ROW START CONSTRAINT [DF_VoceClassCorrTermine_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]                           DATETIME2 (7) GENERATED ALWAYS AS ROW END   CONSTRAINT [DF_VoceClassCorrTermine_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_VoceClassificazioneCorrispondenzaTermine] PRIMARY KEY CLUSTERED ([VoceClassificazioneCorrispondenzaTermineId] ASC),
    CONSTRAINT [CK_VoceClassCorrTermine_Estensione] CHECK ([EstensioneDestinazione]=N'VOCE_E_DISCENDENTI' OR [EstensioneDestinazione]=N'SOLO_VOCE'),
    CONSTRAINT [CK_VoceClassCorrTermine_Operatore] CHECK ([Operatore]=N'EXCLUDE' OR [Operatore]=N'INCLUDE'),
    CONSTRAINT [CK_VoceClassCorrTermine_Ordine] CHECK ([Ordine]>=(0)),
    CONSTRAINT [FK_VoceClassCorrTermine_Regola] FOREIGN KEY ([VoceClassificazioneCorrispondenzaId], [ClassificazioneVersioneDestinazioneId], [ClassificazioneDestinazioneId]) REFERENCES [Standard].[VoceClassificazioneCorrispondenza] ([VoceClassificazioneCorrispondenzaId], [ClassificazioneVersioneDestinazioneId], [ClassificazioneDestinazioneId]),
    CONSTRAINT [FK_VoceClassCorrTermine_VoceDestinazione] FOREIGN KEY ([VoceDestinazioneId], [ClassificazioneVersioneDestinazioneId], [ClassificazioneDestinazioneId]) REFERENCES [Standard].[VoceClassificazione] ([VoceClassificazioneId], [ClassificazioneVersioneId], [ClassificazioneId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[VoceClassificazioneCorrispondenzaTermineStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_VoceClassCorrTermine_Destinazione]
    ON [Standard].[VoceClassificazioneCorrispondenzaTermine]([ClassificazioneVersioneDestinazioneId] ASC, [VoceDestinazioneId] ASC)
    INCLUDE([VoceClassificazioneCorrispondenzaId], [Operatore], [EstensioneDestinazione], [Attivo]) WHERE ([DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_VoceClassCorrTermine_RegolaDestinazione]
    ON [Standard].[VoceClassificazioneCorrispondenzaTermine]([VoceClassificazioneCorrispondenzaId] ASC, [VoceDestinazioneId] ASC) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine UTC del periodo di validita di sistema gestito da Azure SQL temporal.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazioneCorrispondenzaTermine', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Limita il termine alla sola voce o lo estende alla voce e ai suoi discendenti.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazioneCorrispondenzaTermine', @level2type = N'COLUMN', @level2name = N'EstensioneDestinazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio UTC del periodo di validita di sistema gestito da Azure SQL temporal.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazioneCorrispondenzaTermine', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Termine INCLUDE o EXCLUDE verso una voce destinazione, eventualmente esteso al sottoalbero.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazioneCorrispondenzaTermine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Operatore insiemistico INCLUDE o EXCLUDE.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazioneCorrispondenzaTermine', @level2type = N'COLUMN', @level2name = N'Operatore';


GO

