CREATE EXTERNAL TABLE [ExtSIA].[SIAT_StgDocumento] (
    [StgDocumentoId] BIGINT NOT NULL,
    [RunId] UNIQUEIDENTIFIER NOT NULL,
    [LayoutName] NVARCHAR (255) NOT NULL,
    [FileMakerRecordId] NVARCHAR (100) NOT NULL,
    [NormalizationStatus] NVARCHAR (20) NOT NULL,
    [PersonaId_SIAT] NVARCHAR (50) NULL,
    [DataDocumento] NVARCHAR (30) NULL,
    [DataRicezione] NVARCHAR (30) NULL,
    [Fonte] NVARCHAR (100) NULL,
    [SiglaDocumento] NVARCHAR (100) NULL,
    [NomeFile] NVARCHAR (500) NULL,
    [TipoDocumento] NVARCHAR (200) NULL,
    [Dipartimento] NVARCHAR (200) NULL,
    [Note] NVARCHAR (MAX) NULL,
    [SourceJson] NVARCHAR (MAX) NULL,
    [DataCreazione] DATETIME2 (7) NOT NULL,
    [DataCancellazione] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingSIA],
    SCHEMA_NAME = N'SIAT',
    OBJECT_NAME = N'StgDocumento'
    );


GO

