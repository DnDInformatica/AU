CREATE TABLE [Standard].[VoceClassificazioneStorico] (
    [VoceClassificazioneId]     INT              NOT NULL,
    [ClassificazioneVersioneId] INT              NOT NULL,
    [ClassificazioneId]         INT              NOT NULL,
    [Codice]                    NVARCHAR (100)   NOT NULL,
    [Denominazione]             NVARCHAR (1000)  NOT NULL,
    [DescrizioneEstesa]         NVARCHAR (2000)  NULL,
    [TipoVoce]                  NVARCHAR (30)    NOT NULL,
    [Livello]                   SMALLINT         NOT NULL,
    [Ordine]                    INT              NOT NULL,
    [IdentificatoreEsterno]     NVARCHAR (200)   NULL,
    [UriIdentificatore]         NVARCHAR (1000)  NULL,
    [Note]                      NVARCHAR (2000)  NULL,
    [VoceTecnicaRichiesta]      BIT              NULL,
    [Attivo]                    BIT              NOT NULL,
    [DataCreazione]             DATETIME2 (7)    NOT NULL,
    [CreatoDa]                  INT              NULL,
    [DataModifica]              DATETIME2 (7)    NULL,
    [ModificatoDa]              INT              NULL,
    [DataCancellazione]         DATETIME2 (7)    NULL,
    [CancellatoDa]              INT              NULL,
    [UniqueRowId]               UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]        DATETIME2 (7)    NOT NULL,
    [DataFineValidita]          DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_VoceClassificazioneStorico]
    ON [Standard].[VoceClassificazioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

