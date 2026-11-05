CREATE TABLE [Standard].[SchemaCertificazioneDocumentoStorico] (
    [SchemaCertificazioneDocumentoId] INT              NOT NULL,
    [SchemaCertificazioneVersioneId]  INT              NOT NULL,
    [CodiceDocumento]                 NVARCHAR (200)   NOT NULL,
    [Titolo]                          NVARCHAR (1000)  NOT NULL,
    [UrlDocumento]                    NVARCHAR (2000)  NULL,
    [Note]                            NVARCHAR (4000)  NULL,
    [Attivo]                          BIT              NOT NULL,
    [DataCreazione]                   DATETIME2 (7)    NOT NULL,
    [CreatoDa]                        INT              NULL,
    [DataModifica]                    DATETIME2 (7)    NULL,
    [ModificatoDa]                    INT              NULL,
    [DataCancellazione]               DATETIME2 (7)    NULL,
    [CancellatoDa]                    INT              NULL,
    [UniqueRowId]                     UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]              DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                DATETIME2 (7)    NOT NULL,
    [TipoDocumentoId]                 INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_SchemaCertificazioneDocumentoStorico]
    ON [Standard].[SchemaCertificazioneDocumentoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

