CREATE TABLE [Organizzazioni].[OrganizzazioneAttivitaEconomica] (
    [OrganizzazioneAttivitaEconomicaId] INT                                         IDENTITY (1, 1) NOT NULL,
    [OrganizzazioneId]                  INT                                         NOT NULL,
    [ClassificazioneVersioneId]         INT                                         NOT NULL,
    [ClassificazioneId]                 INT                                         NOT NULL,
    [VoceClassificazioneId]             INT                                         NOT NULL,
    [FlagPrincipale]                    BIT                                         CONSTRAINT [DF_OrganizzazioneAttivitaEconomica_Principale] DEFAULT ((0)) NOT NULL,
    [DataInizioAttribuzione]            DATE                                        NULL,
    [DataFineAttribuzione]              DATE                                        NULL,
    [Note]                              NVARCHAR (2000)                             NULL,
    [Attivo]                            BIT                                         CONSTRAINT [DF_OrganizzazioneAttivitaEconomica_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                     DATETIME2 (7)                               CONSTRAINT [DF_OrganizzazioneAttivitaEconomica_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                          INT                                         NULL,
    [DataModifica]                      DATETIME2 (7)                               NULL,
    [ModificatoDa]                      INT                                         NULL,
    [DataCancellazione]                 DATETIME2 (7)                               NULL,
    [CancellatoDa]                      INT                                         NULL,
    [UniqueRowId]                       UNIQUEIDENTIFIER                            CONSTRAINT [DF_OrganizzazioneAttivitaEconomica_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]                  DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_OrganizzazioneAttivitaEconomica] PRIMARY KEY CLUSTERED ([OrganizzazioneAttivitaEconomicaId] ASC),
    CONSTRAINT [CK_OrganizzazioneAttivitaEconomica_Intervallo] CHECK ([DataFineAttribuzione] IS NULL OR [DataInizioAttribuzione] IS NULL OR [DataFineAttribuzione]>=[DataInizioAttribuzione]),
    CONSTRAINT [FK_OrganizzazioneAttivitaEconomica_Applicabilita] FOREIGN KEY ([ClassificazioneId]) REFERENCES [Standard].[ClassificazioneApplicabilitaOrganizzazione] ([ClassificazioneId]),
    CONSTRAINT [FK_OrganizzazioneAttivitaEconomica_Organizzazione] FOREIGN KEY ([OrganizzazioneId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId]),
    CONSTRAINT [FK_OrganizzazioneAttivitaEconomica_Voce] FOREIGN KEY ([VoceClassificazioneId], [ClassificazioneVersioneId], [ClassificazioneId]) REFERENCES [Standard].[VoceClassificazione] ([VoceClassificazioneId], [ClassificazioneVersioneId], [ClassificazioneId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Organizzazioni].[OrganizzazioneAttivitaEconomicaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_OrgAttivitaEconomica_PrincipaleVersione]
    ON [Organizzazioni].[OrganizzazioneAttivitaEconomica]([OrganizzazioneId] ASC, [ClassificazioneVersioneId] ASC) WHERE ([FlagPrincipale]=(1) AND [Attivo]=(1) AND [DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_OrgAttivitaEconomica_Voce]
    ON [Organizzazioni].[OrganizzazioneAttivitaEconomica]([VoceClassificazioneId] ASC, [OrganizzazioneId] ASC)
    INCLUDE([ClassificazioneVersioneId], [FlagPrincipale], [DataInizioAttribuzione], [DataFineAttribuzione], [Attivo]) WHERE ([DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_OrgAttivitaEconomica_IdOrganizzazione]
    ON [Organizzazioni].[OrganizzazioneAttivitaEconomica]([OrganizzazioneAttivitaEconomicaId] ASC, [OrganizzazioneId] ASC);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_OrgAttivitaEconomica_Voce_Periodo]
    ON [Organizzazioni].[OrganizzazioneAttivitaEconomica]([OrganizzazioneId] ASC, [VoceClassificazioneId] ASC, [DataInizioAttribuzione] ASC) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Associazione temporal fra organizzazione e voce di una classificazione economica versionata. Per il popolamento iniziale e ammessa ATECO; NACE e IAF sono derivati.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneAttivitaEconomica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica l attivita principale dell organizzazione nella specifica versione classificatoria; l indice filtrato ne ammette al massimo una.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneAttivitaEconomica', @level2type = N'COLUMN', @level2name = N'FlagPrincipale';


GO

