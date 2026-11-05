CREATE TABLE [Standard].[ClassificazioneVersioneCorrispondenzaEccezioneCoperturaStorico] (
    [ClassificazioneVersioneCorrispondenzaEccezioneCoperturaId] INT              NOT NULL,
    [ClassificazioneVersioneCorrispondenzaId]                   INT              NOT NULL,
    [Lato]                                                      NVARCHAR (20)    NOT NULL,
    [VoceClassificazioneId]                                     INT              NOT NULL,
    [ClassificazioneVersioneId]                                 INT              NOT NULL,
    [ClassificazioneId]                                         INT              NOT NULL,
    [MotivoCodice]                                              NVARCHAR (80)    NOT NULL,
    [RiferimentoDocumentaleId]                                  INT              NOT NULL,
    [RiferimentoPuntuale]                                       NVARCHAR (600)   NULL,
    [Motivazione]                                               NVARCHAR (2000)  NOT NULL,
    [Attivo]                                                    BIT              NOT NULL,
    [DataCreazione]                                             DATETIME2 (7)    NOT NULL,
    [CreatoDa]                                                  INT              NULL,
    [DataModifica]                                              DATETIME2 (7)    NULL,
    [ModificatoDa]                                              INT              NULL,
    [DataCancellazione]                                         DATETIME2 (7)    NULL,
    [CancellatoDa]                                              INT              NULL,
    [UniqueRowId]                                               UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                                        DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                                          DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ClassificazioneVersioneCorrispondenzaEccezioneCoperturaStorico]
    ON [Standard].[ClassificazioneVersioneCorrispondenzaEccezioneCoperturaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

