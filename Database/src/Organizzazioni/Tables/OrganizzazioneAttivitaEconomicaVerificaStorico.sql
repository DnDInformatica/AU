CREATE TABLE [Organizzazioni].[OrganizzazioneAttivitaEconomicaVerificaStorico] (
    [OrganizzazioneAttivitaEconomicaVerificaId] INT              NOT NULL,
    [OrganizzazioneId]                          INT              NOT NULL,
    [OrganizzazioneAttivitaEconomicaId]         INT              NOT NULL,
    [VisuraSnapshotId]                          INT              NOT NULL,
    [DataVerifica]                              DATETIME2 (0)    NOT NULL,
    [ModalitaVerifica]                          NVARCHAR (20)    NOT NULL,
    [CodiceRilevato]                            NVARCHAR (100)   NULL,
    [VoceClassificazioneRilevataId]             INT              NULL,
    [ClassificazioneVersioneRilevataId]         INT              NULL,
    [ClassificazioneRilevataId]                 INT              NULL,
    [Confidenza]                                DECIMAL (5, 4)   NULL,
    [VerificatoDaPersonaId]                     INT              NULL,
    [Note]                                      NVARCHAR (2000)  NULL,
    [Attivo]                                    BIT              NOT NULL,
    [DataCreazione]                             DATETIME2 (7)    NOT NULL,
    [CreatoDa]                                  INT              NULL,
    [DataModifica]                              DATETIME2 (7)    NULL,
    [ModificatoDa]                              INT              NULL,
    [DataCancellazione]                         DATETIME2 (7)    NULL,
    [CancellatoDa]                              INT              NULL,
    [UniqueRowId]                               UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                        DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                          DATETIME2 (7)    NOT NULL,
    [EsitoVerificaAttivitaEconomicaId]          INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_OrganizzazioneAttivitaEconomicaVerificaStorico]
    ON [Organizzazioni].[OrganizzazioneAttivitaEconomicaVerificaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

