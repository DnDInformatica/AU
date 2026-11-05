CREATE TABLE [Persone].[DataBreachStorico] (
    [DataBreachId]                      INT              NOT NULL,
    [Codice]                            NVARCHAR (30)    NOT NULL,
    [Titolo]                            NVARCHAR (200)   NOT NULL,
    [Descrizione]                       NVARCHAR (MAX)   NOT NULL,
    [DataScoperta]                      DATETIME2 (7)    NOT NULL,
    [DataInizioViolazione]              DATETIME2 (7)    NULL,
    [DataFineViolazione]                DATETIME2 (7)    NULL,
    [TipoViolazione]                    NVARCHAR (50)    NOT NULL,
    [CausaViolazione]                   NVARCHAR (500)   NOT NULL,
    [CategorieDatiCoinvolti]            NVARCHAR (500)   NOT NULL,
    [DatiParticolariCoinvolti]          BIT              NOT NULL,
    [NumeroInteressatiStimato]          INT              NULL,
    [CategorieInteressati]              NVARCHAR (500)   NOT NULL,
    [RischioPerInteressati]             NVARCHAR (20)    NOT NULL,
    [DescrizioneRischio]                NVARCHAR (MAX)   NULL,
    [NotificaGaranteRichiesta]          BIT              NOT NULL,
    [DataNotificaGarante]               DATETIME2 (7)    NULL,
    [ProtocolloGarante]                 NVARCHAR (50)    NULL,
    [TermineNotificaGarante]            DATETIME2 (7)    NULL,
    [ComunicazioneInteressatiRichiesta] BIT              NOT NULL,
    [DataComunicazioneInteressati]      DATETIME2 (7)    NULL,
    [ModalitaComunicazione]             NVARCHAR (200)   NULL,
    [MisureContenimento]                NVARCHAR (MAX)   NULL,
    [MisurePrevenzione]                 NVARCHAR (MAX)   NULL,
    [ResponsabileGestioneId]            INT              NULL,
    [DPOCoinvolto]                      BIT              NOT NULL,
    [Stato]                             NVARCHAR (30)    NOT NULL,
    [DataChiusura]                      DATE             NULL,
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

CREATE CLUSTERED INDEX [ix_DataBreachStorico]
    ON [Persone].[DataBreachStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

