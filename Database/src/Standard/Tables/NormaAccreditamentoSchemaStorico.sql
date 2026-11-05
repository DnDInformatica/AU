CREATE TABLE [Standard].[NormaAccreditamentoSchemaStorico] (
    [NormaAccreditamentoSchemaId]   INT              NOT NULL,
    [NormaAccreditamentoId]         INT              NOT NULL,
    [SchemaAccreditamentoId]        INT              NOT NULL,
    [ApplicaSenzaSettore]           BIT              NOT NULL,
    [IndiceOrdinamento]             INT              NULL,
    [RegolamentoTecnico]            NVARCHAR (20)    NULL,
    [Attivo]                        BIT              NOT NULL,
    [DataCreazione]                 DATETIME2 (7)    NOT NULL,
    [CreatoDa]                      INT              NULL,
    [DataModifica]                  DATETIME2 (7)    NULL,
    [ModificatoDa]                  INT              NULL,
    [DataCancellazione]             DATETIME2 (7)    NULL,
    [CancellatoDa]                  INT              NULL,
    [UniqueRowId]                   UNIQUEIDENTIFIER NOT NULL,
    [RegimeAccreditamentoId]        TINYINT          NULL,
    [DocumentoRegolamentoTecnicoId] INT              NULL,
    [DataInizioValidita]            DATETIME2 (7)    NOT NULL,
    [DataFineValidita]              DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_NormaAccreditamentoSchemaStorico]
    ON [Standard].[NormaAccreditamentoSchemaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

