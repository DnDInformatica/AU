CREATE TABLE [Standard].[SchemaCertificazioneStorico] (
    [SchemaCertificazioneId]             INT              NOT NULL,
    [Codice]                             NVARCHAR (100)   NOT NULL,
    [Denominazione]                      NVARCHAR (600)   NOT NULL,
    [DenominazioneEng]                   NVARCHAR (600)   NULL,
    [SchemaCertificazioneProprietarioId] INT              NOT NULL,
    [AmbitoCertificazione]               VARCHAR (30)     NOT NULL,
    [Descrizione]                        NVARCHAR (4000)  NULL,
    [Attivo]                             BIT              NOT NULL,
    [DataCreazione]                      DATETIME2 (7)    NOT NULL,
    [CreatoDa]                           INT              NULL,
    [DataModifica]                       DATETIME2 (7)    NULL,
    [ModificatoDa]                       INT              NULL,
    [DataCancellazione]                  DATETIME2 (7)    NULL,
    [CancellatoDa]                       INT              NULL,
    [UniqueRowId]                        UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                 DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                   DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_SchemaCertificazioneStorico]
    ON [Standard].[SchemaCertificazioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

