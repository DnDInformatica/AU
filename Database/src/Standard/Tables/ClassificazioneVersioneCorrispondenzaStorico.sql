CREATE TABLE [Standard].[ClassificazioneVersioneCorrispondenzaStorico] (
    [ClassificazioneVersioneCorrispondenzaId] INT              NOT NULL,
    [Codice]                                  NVARCHAR (150)   NOT NULL,
    [ClassificazioneVersioneOrigineId]        INT              NOT NULL,
    [ClassificazioneOrigineId]                INT              NOT NULL,
    [ClassificazioneVersioneDestinazioneId]   INT              NOT NULL,
    [ClassificazioneDestinazioneId]           INT              NOT NULL,
    [RiferimentoDocumentaleId]                INT              NOT NULL,
    [TipoCorrispondenza]                      NVARCHAR (40)    NOT NULL,
    [DataDecorrenza]                          DATE             NULL,
    [RiferimentoPuntuale]                     NVARCHAR (300)   NULL,
    [Descrizione]                             NVARCHAR (1000)  NULL,
    [ConsenteSovrapposizioni]                 BIT              NOT NULL,
    [NumeroRegoleAtteso]                      INT              NULL,
    [NumeroTerminiAtteso]                     INT              NULL,
    [NumeroAssociazioniEffettiveAtteso]       INT              NULL,
    [HashRegoleSHA256]                        CHAR (64)        NULL,
    [HashAssociazioniEffettiveSHA256]         CHAR (64)        NULL,
    [CorrispondenzeOrigineRichieste]          BIT              NOT NULL,
    [CorrispondenzeDestinazioneRichieste]     BIT              NOT NULL,
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

CREATE CLUSTERED INDEX [ix_ClassificazioneVersioneCorrispondenzaStorico]
    ON [Standard].[ClassificazioneVersioneCorrispondenzaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

