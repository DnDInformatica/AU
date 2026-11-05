CREATE EXTERNAL TABLE [ExtSIA].[SIA_FileMakerRaw] (
    [FileMakerRawId] BIGINT NOT NULL,
    [SourceDatabase] NVARCHAR (128) NOT NULL,
    [LayoutName] NVARCHAR (255) NOT NULL,
    [FileMakerRecordId] NVARCHAR (100) NOT NULL,
    [FileMakerModId] NVARCHAR (100) NULL,
    [SourceModifiedAt] DATETIME2 (7) NULL,
    [SourceCreatedAt] DATETIME2 (7) NULL,
    [ExtractedAtUtc] DATETIME2 (7) NOT NULL,
    [RunId] UNIQUEIDENTIFIER NOT NULL,
    [IsDeltaLoad] BIT NOT NULL,
    [ProcessingStatus] NVARCHAR (30) NOT NULL,
    [SourceHash] VARBINARY (32) NULL,
    [SourceJson] NVARCHAR (MAX) NOT NULL,
    [DataCreazione] DATETIME2 (7) NOT NULL,
    [DataModifica] DATETIME2 (7) NULL,
    [DataCancellazione] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingSIA],
    SCHEMA_NAME = N'SIA',
    OBJECT_NAME = N'FileMakerRaw'
    );


GO

