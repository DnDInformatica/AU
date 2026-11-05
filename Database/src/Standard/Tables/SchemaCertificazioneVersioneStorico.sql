CREATE TABLE [Standard].[SchemaCertificazioneVersioneStorico] (
    [SchemaCertificazioneVersioneId] INT              NOT NULL,
    [SchemaCertificazioneId]         INT              NOT NULL,
    [CodiceVersione]                 NVARCHAR (100)   NOT NULL,
    [Denominazione]                  NVARCHAR (600)   NULL,
    [StatoNormaId]                   INT              NOT NULL,
    [DataPubblicazione]              DATE             NULL,
    [DataEntrataInVigore]            DATE             NULL,
    [DataRitiro]                     DATE             NULL,
    [DataFineTransizione]            DATE             NULL,
    [Note]                           NVARCHAR (4000)  NULL,
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

CREATE CLUSTERED INDEX [ix_SchemaCertificazioneVersioneStorico]
    ON [Standard].[SchemaCertificazioneVersioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

