CREATE TABLE [Accreditamento].[DocumentoEventoStorico] (
    [DocumentoEventoId]          INT              NOT NULL,
    [EventoRegolatorioId]        INT              NULL,
    [ProvvedimentoRegolatorioId] INT              NULL,
    [TipoDocumento]              NVARCHAR (50)    NOT NULL,
    [NomeFile]                   NVARCHAR (255)   NOT NULL,
    [Descrizione]                NVARCHAR (500)   NULL,
    [PercorsoFile]               NVARCHAR (500)   NULL,
    [HashFile]                   NVARCHAR (64)    NULL,
    [DimensioneBytes]            BIGINT           NULL,
    [DataDocumento]              DATE             NOT NULL,
    [DataCaricamento]            DATETIME2 (7)    NOT NULL,
    [DataCreazione]              DATETIME2 (7)    NOT NULL,
    [CreatoDa]                   INT              NULL,
    [DataModifica]               DATETIME2 (7)    NULL,
    [ModificatoDa]               INT              NULL,
    [DataCancellazione]          DATETIME2 (7)    NULL,
    [CancellatoDa]               INT              NULL,
    [UniqueRowId]                UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]         DATETIME2 (7)    NOT NULL,
    [DataFineValidita]           DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_DocumentoEventoStorico]
    ON [Accreditamento].[DocumentoEventoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

