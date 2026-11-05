CREATE TABLE [Documentale].[DocumentoVersioneStorico] (
    [DocumentoVersioneId]      INT              NOT NULL,
    [DocumentoId]              INT              NOT NULL,
    [NumeroVersione]           INT              NOT NULL,
    [NomeFile]                 NVARCHAR (500)   NOT NULL,
    [StorageKey]               NVARCHAR (1000)  NOT NULL,
    [ContentType]              NVARCHAR (200)   NOT NULL,
    [HashSha256]               NVARCHAR (128)   NULL,
    [DimensioneBytes]          BIGINT           NOT NULL,
    [NoteVersione]             NVARCHAR (1000)  NULL,
    [IsVersioneCorrente]       BIT              NOT NULL,
    [DataCreazione]            DATETIME2 (7)    NOT NULL,
    [CreatoDa]                 INT              NULL,
    [DataModifica]             DATETIME2 (7)    NULL,
    [ModificatoDa]             INT              NULL,
    [DataCancellazione]        DATETIME2 (7)    NULL,
    [CancellatoDa]             INT              NULL,
    [UniqueRowId]              UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]       DATETIME2 (7)    NOT NULL,
    [DataFineValidita]         DATETIME2 (7)    NOT NULL,
    [StatoVersioneDocumentoId] INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_DocumentoVersioneStorico]
    ON [Documentale].[DocumentoVersioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

