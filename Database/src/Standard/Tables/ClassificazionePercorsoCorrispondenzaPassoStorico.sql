CREATE TABLE [Standard].[ClassificazionePercorsoCorrispondenzaPassoStorico] (
    [ClassificazionePercorsoCorrispondenzaPassoId] INT              NOT NULL,
    [ClassificazionePercorsoCorrispondenzaId]      INT              NOT NULL,
    [OrdinePasso]                                  SMALLINT         NOT NULL,
    [ClassificazioneVersioneCorrispondenzaId]      INT              NOT NULL,
    [Direzione]                                    NVARCHAR (20)    NOT NULL,
    [Note]                                         NVARCHAR (2000)  NULL,
    [Attivo]                                       BIT              NOT NULL,
    [DataCreazione]                                DATETIME2 (7)    NOT NULL,
    [CreatoDa]                                     INT              NULL,
    [DataModifica]                                 DATETIME2 (7)    NULL,
    [ModificatoDa]                                 INT              NULL,
    [DataCancellazione]                            DATETIME2 (7)    NULL,
    [CancellatoDa]                                 INT              NULL,
    [UniqueRowId]                                  UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                           DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                             DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ClassificazionePercorsoCorrispondenzaPassoStorico]
    ON [Standard].[ClassificazionePercorsoCorrispondenzaPassoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

