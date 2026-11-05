CREATE TABLE [Standard].[ClassificazioneVersioneRisorsaStorico] (
    [ClassificazioneVersioneRisorsaId] INT              NOT NULL,
    [ClassificazioneVersioneId]        INT              NOT NULL,
    [ClassificazioneId]                INT              NOT NULL,
    [SoggettoFonteId]                  INT              NOT NULL,
    [TipoRisorsa]                      NVARCHAR (40)    NOT NULL,
    [VersioneRisorsa]                  NVARCHAR (50)    NULL,
    [Formato]                          NVARCHAR (100)   NOT NULL,
    [Lingua]                           NVARCHAR (10)    NULL,
    [UriRisorsa]                       NVARCHAR (1000)  NOT NULL,
    [UrlAccesso]                       NVARCHAR (1000)  NOT NULL,
    [EndpointAccesso]                  NVARCHAR (1000)  NULL,
    [RepositoryFonte]                  NVARCHAR (200)   NULL,
    [DataAcquisizione]                 DATETIME2 (7)    NOT NULL,
    [HashSHA256]                       CHAR (64)        NOT NULL,
    [NumeroVoci]                       INT              NOT NULL,
    [Note]                             NVARCHAR (2000)  NULL,
    [Attivo]                           BIT              NOT NULL,
    [DataCreazione]                    DATETIME2 (7)    NOT NULL,
    [CreatoDa]                         INT              NULL,
    [DataModifica]                     DATETIME2 (7)    NULL,
    [ModificatoDa]                     INT              NULL,
    [DataCancellazione]                DATETIME2 (7)    NULL,
    [CancellatoDa]                     INT              NULL,
    [UniqueRowId]                      UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]               DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                 DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ClassificazioneVersioneRisorsaStorico]
    ON [Standard].[ClassificazioneVersioneRisorsaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

