CREATE TABLE [Persone].[PersonaDocumentoStorico] (
    [DocumentoId]        INT              NOT NULL,
    [PersonaId]          INT              NOT NULL,
    [NomeFile]           NVARCHAR (260)   NOT NULL,
    [ContentType]        NVARCHAR (200)   NULL,
    [DimensioneBytes]    BIGINT           NOT NULL,
    [HashSha256]         NVARCHAR (64)    NULL,
    [Note]               NVARCHAR (1000)  NULL,
    [StorageKey]         NVARCHAR (400)   NOT NULL,
    [DataCreazione]      DATETIME2 (7)    NOT NULL,
    [CreatoDa]           INT              NOT NULL,
    [DataModifica]       DATETIME2 (7)    NOT NULL,
    [ModificatoDa]       INT              NOT NULL,
    [DataCancellazione]  DATETIME2 (7)    NULL,
    [CancellatoDa]       INT              NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita] DATETIME2 (7)    NOT NULL,
    [DataFineValidita]   DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_PersonaDocumentoStorico]
    ON [Persone].[PersonaDocumentoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

