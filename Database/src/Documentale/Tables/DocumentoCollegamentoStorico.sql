CREATE TABLE [Documentale].[DocumentoCollegamentoStorico] (
    [DocumentoCollegamentoId]      INT              NOT NULL,
    [DocumentoId]                  INT              NOT NULL,
    [OggettoId]                    INT              NOT NULL,
    [Ordinamento]                  INT              NULL,
    [DataCreazione]                DATETIME2 (7)    NOT NULL,
    [CreatoDa]                     INT              NULL,
    [DataModifica]                 DATETIME2 (7)    NULL,
    [ModificatoDa]                 INT              NULL,
    [DataCancellazione]            DATETIME2 (7)    NULL,
    [CancellatoDa]                 INT              NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]           DATETIME2 (7)    NOT NULL,
    [DataFineValidita]             DATETIME2 (7)    NOT NULL,
    [RuoloCollegamentoDocumentoId] INT              NOT NULL,
    [TipoOggettoDominioId]         INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_DocumentoCollegamentoStorico]
    ON [Documentale].[DocumentoCollegamentoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

