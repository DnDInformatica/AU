CREATE TABLE [Standard].[ClassificazionePercorsoCorrispondenzaStorico] (
    [ClassificazionePercorsoCorrispondenzaId] INT              NOT NULL,
    [Codice]                                  NVARCHAR (150)   NOT NULL,
    [ClassificazioneVersioneOrigineId]        INT              NOT NULL,
    [ClassificazioneOrigineId]                INT              NOT NULL,
    [ClassificazioneVersioneDestinazioneId]   INT              NOT NULL,
    [ClassificazioneDestinazioneId]           INT              NOT NULL,
    [Finalita]                                NVARCHAR (500)   NOT NULL,
    [EsitoInformativoFlag]                    BIT              NOT NULL,
    [Note]                                    NVARCHAR (3000)  NULL,
    [Attivo]                                  BIT              NOT NULL,
    [DataCreazione]                           DATETIME2 (7)    NOT NULL,
    [CreatoDa]                                INT              NULL,
    [DataModifica]                            DATETIME2 (7)    NULL,
    [ModificatoDa]                            INT              NULL,
    [DataCancellazione]                       DATETIME2 (7)    NULL,
    [CancellatoDa]                            INT              NULL,
    [UniqueRowId]                             UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                      DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                        DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ClassificazionePercorsoCorrispondenzaStorico]
    ON [Standard].[ClassificazionePercorsoCorrispondenzaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

