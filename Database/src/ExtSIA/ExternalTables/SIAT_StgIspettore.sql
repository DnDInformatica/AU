CREATE EXTERNAL TABLE [ExtSIA].[SIAT_StgIspettore] (
    [StgIspettoreId] BIGINT NOT NULL,
    [RunId] UNIQUEIDENTIFIER NOT NULL,
    [LayoutName] NVARCHAR (255) NOT NULL,
    [FileMakerRecordId] NVARCHAR (100) NOT NULL,
    [NormalizationStatus] NVARCHAR (20) NOT NULL,
    [CodicePersona] NVARCHAR (50) NULL,
    [CodiceIspettore] NVARCHAR (50) NULL,
    [Dipartimento] NVARCHAR (200) NULL,
    [Qualifica] NVARCHAR (300) NULL,
    [StatoQualifica] NVARCHAR (200) NULL,
    [DataInizio] NVARCHAR (30) NULL,
    [DataFine] NVARCHAR (30) NULL,
    [IspettoreId] INT NULL,
    [PersonaId] INT NULL,
    [SourceJson] NVARCHAR (MAX) NULL,
    [DataCreazione] DATETIME2 (7) NOT NULL,
    [DataCancellazione] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingSIA],
    SCHEMA_NAME = N'SIAT',
    OBJECT_NAME = N'StgIspettore'
    );


GO

