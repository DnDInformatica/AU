CREATE TABLE [Standard].[SchemaCertificazioneVersioneNormaStorico] (
    [SchemaCertificazioneVersioneNormaId] INT              NOT NULL,
    [SchemaCertificazioneVersioneId]      INT              NOT NULL,
    [NormaEdizioneId]                     INT              NOT NULL,
    [TipoRelazione]                       VARCHAR (30)     NOT NULL,
    [Ordine]                              SMALLINT         NULL,
    [Note]                                NVARCHAR (2000)  NULL,
    [Attivo]                              BIT              NOT NULL,
    [DataCreazione]                       DATETIME2 (7)    NOT NULL,
    [CreatoDa]                            INT              NULL,
    [DataModifica]                        DATETIME2 (7)    NULL,
    [ModificatoDa]                        INT              NULL,
    [DataCancellazione]                   DATETIME2 (7)    NULL,
    [CancellatoDa]                        INT              NULL,
    [UniqueRowId]                         UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                  DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                    DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_SchemaCertificazioneVersioneNormaStorico]
    ON [Standard].[SchemaCertificazioneVersioneNormaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

