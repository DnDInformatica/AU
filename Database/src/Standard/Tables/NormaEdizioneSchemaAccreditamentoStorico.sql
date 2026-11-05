CREATE TABLE [Standard].[NormaEdizioneSchemaAccreditamentoStorico] (
    [NormaEdizioneSchemaAccreditamentoId] INT              NOT NULL,
    [NormaEdizioneId]                     INT              NOT NULL,
    [SchemaAccreditamentoId]              INT              NOT NULL,
    [RegimeAccreditamentoId]              TINYINT          NOT NULL,
    [ApplicaSenzaSettore]                 BIT              NOT NULL,
    [DataInizioApplicazione]              DATE             NULL,
    [DataFineApplicazione]                DATE             NULL,
    [NoteApplicazione]                    NVARCHAR (500)   NULL,
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

CREATE CLUSTERED INDEX [ix_NormaEdizioneSchemaAccreditamentoStorico]
    ON [Standard].[NormaEdizioneSchemaAccreditamentoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

