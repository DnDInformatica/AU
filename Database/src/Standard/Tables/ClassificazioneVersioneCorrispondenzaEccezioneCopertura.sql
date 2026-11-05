CREATE TABLE [Standard].[ClassificazioneVersioneCorrispondenzaEccezioneCopertura] (
    [ClassificazioneVersioneCorrispondenzaEccezioneCoperturaId] INT                                         IDENTITY (1, 1) NOT NULL,
    [ClassificazioneVersioneCorrispondenzaId]                   INT                                         NOT NULL,
    [Lato]                                                      NVARCHAR (20)                               NOT NULL,
    [VoceClassificazioneId]                                     INT                                         NOT NULL,
    [ClassificazioneVersioneId]                                 INT                                         NOT NULL,
    [ClassificazioneId]                                         INT                                         NOT NULL,
    [MotivoCodice]                                              NVARCHAR (80)                               NOT NULL,
    [RiferimentoDocumentaleId]                                  INT                                         NOT NULL,
    [RiferimentoPuntuale]                                       NVARCHAR (600)                              NULL,
    [Motivazione]                                               NVARCHAR (2000)                             NOT NULL,
    [Attivo]                                                    BIT                                         CONSTRAINT [DF_ClassVersCorrEccezioneCopertura_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                                             DATETIME2 (7)                               CONSTRAINT [DF_ClassVersCorrEccezioneCopertura_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                                                  INT                                         NULL,
    [DataModifica]                                              DATETIME2 (7)                               NULL,
    [ModificatoDa]                                              INT                                         NULL,
    [DataCancellazione]                                         DATETIME2 (7)                               NULL,
    [CancellatoDa]                                              INT                                         NULL,
    [UniqueRowId]                                               UNIQUEIDENTIFIER                            CONSTRAINT [DF_ClassVersCorrEccezioneCopertura_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                                        DATETIME2 (7) GENERATED ALWAYS AS ROW START CONSTRAINT [DF_ClassVersCorrEccezioneCopertura_DataInizio] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]                                          DATETIME2 (7) GENERATED ALWAYS AS ROW END   CONSTRAINT [DF_ClassVersCorrEccezioneCopertura_DataFine] DEFAULT (CONVERT([datetime2],'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_ClassVersCorrEccezioneCopertura] PRIMARY KEY CLUSTERED ([ClassificazioneVersioneCorrispondenzaEccezioneCoperturaId] ASC),
    CONSTRAINT [CK_ClassVersCorrEccezioneCopertura_Lato] CHECK ([Lato]=N'DESTINAZIONE' OR [Lato]=N'ORIGINE'),
    CONSTRAINT [CK_ClassVersCorrEccezioneCopertura_Motivazione] CHECK (len(ltrim(rtrim([Motivazione])))>(0)),
    CONSTRAINT [CK_ClassVersCorrEccezioneCopertura_Motivo] CHECK ([MotivoCodice]=N'ASSENZA_RACCORDO_UFFICIALE'),
    CONSTRAINT [FK_ClassVersCorrEccezioneCopertura_Politica] FOREIGN KEY ([ClassificazioneVersioneCorrispondenzaId]) REFERENCES [Standard].[ClassificazioneVersioneCorrispondenzaCopertura] ([ClassificazioneVersioneCorrispondenzaId]),
    CONSTRAINT [FK_ClassVersCorrEccezioneCopertura_Riferimento] FOREIGN KEY ([RiferimentoDocumentaleId]) REFERENCES [Standard].[RiferimentoDocumentale] ([RiferimentoDocumentaleId]),
    CONSTRAINT [FK_ClassVersCorrEccezioneCopertura_Voce] FOREIGN KEY ([VoceClassificazioneId], [ClassificazioneVersioneId], [ClassificazioneId]) REFERENCES [Standard].[VoceClassificazione] ([VoceClassificazioneId], [ClassificazioneVersioneId], [ClassificazioneId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[ClassificazioneVersioneCorrispondenzaEccezioneCoperturaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ClassVersCorrEccezioneCopertura_Voce]
    ON [Standard].[ClassificazioneVersioneCorrispondenzaEccezioneCopertura]([ClassificazioneVersioneCorrispondenzaId] ASC, [Lato] ASC, [VoceClassificazioneId] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ClassVersCorrEccezioneCopertura_Riferimento]
    ON [Standard].[ClassificazioneVersioneCorrispondenzaEccezioneCopertura]([RiferimentoDocumentaleId] ASC)
    INCLUDE([ClassificazioneVersioneCorrispondenzaId], [Lato], [VoceClassificazioneId], [MotivoCodice], [Attivo]) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Eccezioni temporal, puntuali e documentate ai gate di copertura delle corrispondenze. Non autorizza raccordi inferiti o manuali.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneCorrispondenzaEccezioneCopertura';


GO

