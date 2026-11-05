CREATE TABLE [Standard].[VoceClassificazioneGerarchiaStorico] (
    [VoceClassificazioneGerarchiaId] INT              NOT NULL,
    [ClassificazioneVersioneId]      INT              NOT NULL,
    [ClassificazioneId]              INT              NOT NULL,
    [VocePadreId]                    INT              NOT NULL,
    [VoceFiglioId]                   INT              NOT NULL,
    [GerarchiaRichiesta]             BIT              NOT NULL,
    [ConsentePiuPadri]               BIT              NOT NULL,
    [Note]                           NVARCHAR (2000)  NULL,
    [Attivo]                         BIT              NOT NULL,
    [DataCreazione]                  DATETIME2 (7)    NOT NULL,
    [CreatoDa]                       INT              NULL,
    [DataModifica]                   DATETIME2 (7)    NULL,
    [ModificatoDa]                   INT              NULL,
    [DataCancellazione]              DATETIME2 (7)    NULL,
    [CancellatoDa]                   INT              NULL,
    [UniqueRowId]                    UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]             DATETIME2 (7)    NOT NULL,
    [DataFineValidita]               DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_VoceClassificazioneGerarchiaStorico]
    ON [Standard].[VoceClassificazioneGerarchiaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

