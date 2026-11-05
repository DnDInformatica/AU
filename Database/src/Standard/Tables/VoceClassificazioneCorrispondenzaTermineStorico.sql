CREATE TABLE [Standard].[VoceClassificazioneCorrispondenzaTermineStorico] (
    [VoceClassificazioneCorrispondenzaTermineId] INT              NOT NULL,
    [VoceClassificazioneCorrispondenzaId]        INT              NOT NULL,
    [ClassificazioneVersioneDestinazioneId]      INT              NOT NULL,
    [ClassificazioneDestinazioneId]              INT              NOT NULL,
    [VoceDestinazioneId]                         INT              NOT NULL,
    [Operatore]                                  NVARCHAR (10)    NOT NULL,
    [EstensioneDestinazione]                     NVARCHAR (30)    NOT NULL,
    [Ordine]                                     INT              NOT NULL,
    [Note]                                       NVARCHAR (2000)  NULL,
    [Attivo]                                     BIT              NOT NULL,
    [DataCreazione]                              DATETIME2 (7)    NOT NULL,
    [CreatoDa]                                   INT              NULL,
    [DataModifica]                               DATETIME2 (7)    NULL,
    [ModificatoDa]                               INT              NULL,
    [DataCancellazione]                          DATETIME2 (7)    NULL,
    [CancellatoDa]                               INT              NULL,
    [UniqueRowId]                                UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                         DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                           DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_VoceClassificazioneCorrispondenzaTermineStorico]
    ON [Standard].[VoceClassificazioneCorrispondenzaTermineStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

