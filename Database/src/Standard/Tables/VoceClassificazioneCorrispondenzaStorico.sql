CREATE TABLE [Standard].[VoceClassificazioneCorrispondenzaStorico] (
    [VoceClassificazioneCorrispondenzaId]     INT              NOT NULL,
    [ClassificazioneVersioneCorrispondenzaId] INT              NOT NULL,
    [ClassificazioneVersioneOrigineId]        INT              NOT NULL,
    [ClassificazioneOrigineId]                INT              NOT NULL,
    [ClassificazioneVersioneDestinazioneId]   INT              NOT NULL,
    [ClassificazioneDestinazioneId]           INT              NOT NULL,
    [VoceOrigineId]                           INT              NOT NULL,
    [EspressioneFonte]                        NVARCHAR (1000)  NULL,
    [Ordine]                                  INT              NOT NULL,
    [Note]                                    NVARCHAR (2000)  NULL,
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

CREATE CLUSTERED INDEX [ix_VoceClassificazioneCorrispondenzaStorico]
    ON [Standard].[VoceClassificazioneCorrispondenzaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

