CREATE TABLE [Organizzazioni].[OrganizzazioneAttivitaEconomicaVerifica] (
    [OrganizzazioneAttivitaEconomicaVerificaId] INT                                         IDENTITY (1, 1) NOT NULL,
    [OrganizzazioneId]                          INT                                         NOT NULL,
    [OrganizzazioneAttivitaEconomicaId]         INT                                         NOT NULL,
    [VisuraSnapshotId]                          INT                                         NOT NULL,
    [DataVerifica]                              DATETIME2 (0)                               CONSTRAINT [DF_OrgAttEcoVerifica_DataVerifica] DEFAULT (sysutcdatetime()) NOT NULL,
    [ModalitaVerifica]                          NVARCHAR (20)                               NOT NULL,
    [CodiceRilevato]                            NVARCHAR (100)                              NULL,
    [VoceClassificazioneRilevataId]             INT                                         NULL,
    [ClassificazioneVersioneRilevataId]         INT                                         NULL,
    [ClassificazioneRilevataId]                 INT                                         NULL,
    [Confidenza]                                DECIMAL (5, 4)                              NULL,
    [VerificatoDaPersonaId]                     INT                                         NULL,
    [Note]                                      NVARCHAR (2000)                             NULL,
    [Attivo]                                    BIT                                         CONSTRAINT [DF_OrgAttEcoVerifica_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                             DATETIME2 (7)                               CONSTRAINT [DF_OrgAttEcoVerifica_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                                  INT                                         NULL,
    [DataModifica]                              DATETIME2 (7)                               NULL,
    [ModificatoDa]                              INT                                         NULL,
    [DataCancellazione]                         DATETIME2 (7)                               NULL,
    [CancellatoDa]                              INT                                         NULL,
    [UniqueRowId]                               UNIQUEIDENTIFIER                            CONSTRAINT [DF_OrgAttEcoVerifica_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]                          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    [EsitoVerificaAttivitaEconomicaId]          INT                                         NOT NULL,
    CONSTRAINT [PK_OrganizzazioneAttivitaEconomicaVerifica] PRIMARY KEY CLUSTERED ([OrganizzazioneAttivitaEconomicaVerificaId] ASC),
    CONSTRAINT [CK_OrgAttEcoVerifica_Confidenza] CHECK ([Confidenza] IS NULL OR [Confidenza]>=CONVERT([decimal](5,4),(0)) AND [Confidenza]<=CONVERT([decimal](5,4),(1))),
    CONSTRAINT [CK_OrgAttEcoVerifica_Modalita] CHECK ([ModalitaVerifica]=N'MANUALE' OR [ModalitaVerifica]=N'AUTOMATICA'),
    CONSTRAINT [CK_OrgAttEcoVerifica_SemanticaEsito] CHECK ([Organizzazioni].[fn_EsitoVerificaAttEcoCodice]([EsitoVerificaAttivitaEconomicaId])=N'CONFERMATA' AND [VoceClassificazioneRilevataId] IS NULL AND [ClassificazioneVersioneRilevataId] IS NULL AND [ClassificazioneRilevataId] IS NULL OR [Organizzazioni].[fn_EsitoVerificaAttEcoCodice]([EsitoVerificaAttivitaEconomicaId])=N'DIFFORME' AND [CodiceRilevato] IS NOT NULL OR [Organizzazioni].[fn_EsitoVerificaAttEcoCodice]([EsitoVerificaAttivitaEconomicaId])=N'NON_VERIFICABILE' AND [VoceClassificazioneRilevataId] IS NULL AND [ClassificazioneVersioneRilevataId] IS NULL AND [ClassificazioneRilevataId] IS NULL),
    CONSTRAINT [CK_OrgAttEcoVerifica_Verificatore] CHECK ([ModalitaVerifica]=N'AUTOMATICA' OR [VerificatoDaPersonaId] IS NOT NULL),
    CONSTRAINT [CK_OrgAttEcoVerifica_VoceRilevataCompleta] CHECK ([VoceClassificazioneRilevataId] IS NULL AND [ClassificazioneVersioneRilevataId] IS NULL AND [ClassificazioneRilevataId] IS NULL OR [VoceClassificazioneRilevataId] IS NOT NULL AND [ClassificazioneVersioneRilevataId] IS NOT NULL AND [ClassificazioneRilevataId] IS NOT NULL),
    CONSTRAINT [FK_OrgAttEcoVerifica_ApplicabilitaRilevata] FOREIGN KEY ([ClassificazioneRilevataId]) REFERENCES [Standard].[ClassificazioneApplicabilitaOrganizzazione] ([ClassificazioneId]),
    CONSTRAINT [FK_OrgAttEcoVerifica_AttivitaOrganizzazione] FOREIGN KEY ([OrganizzazioneAttivitaEconomicaId], [OrganizzazioneId]) REFERENCES [Organizzazioni].[OrganizzazioneAttivitaEconomica] ([OrganizzazioneAttivitaEconomicaId], [OrganizzazioneId]),
    CONSTRAINT [FK_OrgAttEcoVerifica_EsitoVerAttEco] FOREIGN KEY ([EsitoVerificaAttivitaEconomicaId]) REFERENCES [Tipologica].[EsitoVerificaAttivitaEconomica] ([EsitoVerificaAttivitaEconomicaId]),
    CONSTRAINT [FK_OrgAttEcoVerifica_Persona] FOREIGN KEY ([VerificatoDaPersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [FK_OrgAttEcoVerifica_VisuraOrganizzazione] FOREIGN KEY ([VisuraSnapshotId], [OrganizzazioneId]) REFERENCES [Organizzazioni].[VisuraSnapshot] ([VisuraSnapshotId], [OrganizzazioneId]),
    CONSTRAINT [FK_OrgAttEcoVerifica_VoceRilevata] FOREIGN KEY ([VoceClassificazioneRilevataId], [ClassificazioneVersioneRilevataId], [ClassificazioneRilevataId]) REFERENCES [Standard].[VoceClassificazione] ([VoceClassificazioneId], [ClassificazioneVersioneId], [ClassificazioneId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Organizzazioni].[OrganizzazioneAttivitaEconomicaVerificaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_OrgAttEcoVerifica_AttivitaData]
    ON [Organizzazioni].[OrganizzazioneAttivitaEconomicaVerifica]([OrganizzazioneAttivitaEconomicaId] ASC, [DataVerifica] ASC)
    INCLUDE([EsitoVerificaAttivitaEconomicaId], [VisuraSnapshotId], [ModalitaVerifica]) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_OrgAttEcoVerifica_DaValutare]
    ON [Organizzazioni].[OrganizzazioneAttivitaEconomicaVerifica]([EsitoVerificaAttivitaEconomicaId] ASC, [DataVerifica] ASC)
    INCLUDE([OrganizzazioneId], [OrganizzazioneAttivitaEconomicaId], [VisuraSnapshotId]) WHERE ([Attivo]=(1) AND [DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Verifica temporal dell attribuzione ATECO di un organizzazione tramite una visura. Registra conferma, difformita o non verificabilita; non modifica stati di accreditamento o certificazione.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneAttivitaEconomicaVerifica';


GO

