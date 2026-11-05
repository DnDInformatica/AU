CREATE TABLE [Organizzazioni].[OrganizzazioneAttivitaEconomicaStorico] (
    [OrganizzazioneAttivitaEconomicaId] INT              NOT NULL,
    [OrganizzazioneId]                  INT              NOT NULL,
    [ClassificazioneVersioneId]         INT              NOT NULL,
    [ClassificazioneId]                 INT              NOT NULL,
    [VoceClassificazioneId]             INT              NOT NULL,
    [FlagPrincipale]                    BIT              NOT NULL,
    [DataInizioAttribuzione]            DATE             NULL,
    [DataFineAttribuzione]              DATE             NULL,
    [Note]                              NVARCHAR (2000)  NULL,
    [Attivo]                            BIT              NOT NULL,
    [DataCreazione]                     DATETIME2 (7)    NOT NULL,
    [CreatoDa]                          INT              NULL,
    [DataModifica]                      DATETIME2 (7)    NULL,
    [ModificatoDa]                      INT              NULL,
    [DataCancellazione]                 DATETIME2 (7)    NULL,
    [CancellatoDa]                      INT              NULL,
    [UniqueRowId]                       UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                  DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_OrganizzazioneAttivitaEconomicaStorico]
    ON [Organizzazioni].[OrganizzazioneAttivitaEconomicaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

