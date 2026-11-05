CREATE TABLE [Documentale].[DocumentoStorico] (
    [DocumentoId]        INT              NOT NULL,
    [Codice]             NVARCHAR (200)   NULL,
    [Titolo]             NVARCHAR (600)   NOT NULL,
    [Descrizione]        NVARCHAR (MAX)   NULL,
    [Riservato]          BIT              NOT NULL,
    [OwnerPersonaId]     INT              NULL,
    [DataDocumento]      DATE             NULL,
    [DataPubblicazione]  DATE             NULL,
    [DataScadenza]       DATE             NULL,
    [DataCreazione]      DATETIME2 (7)    NOT NULL,
    [CreatoDa]           INT              NULL,
    [DataModifica]       DATETIME2 (7)    NULL,
    [ModificatoDa]       INT              NULL,
    [DataCancellazione]  DATETIME2 (7)    NULL,
    [CancellatoDa]       INT              NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita] DATETIME2 (7)    NOT NULL,
    [DataFineValidita]   DATETIME2 (7)    NOT NULL,
    [StatoDocumentoId]   INT              NOT NULL,
    [TipoDocumentoId]    INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_DocumentoStorico]
    ON [Documentale].[DocumentoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

