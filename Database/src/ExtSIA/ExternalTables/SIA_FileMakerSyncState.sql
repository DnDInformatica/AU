CREATE EXTERNAL TABLE [ExtSIA].[SIA_FileMakerSyncState] (
    [FileMakerSyncStateId] BIGINT NOT NULL,
    [SourceDatabase] NVARCHAR (128) NOT NULL,
    [LayoutName] NVARCHAR (255) NOT NULL,
    [LoadMode] NVARCHAR (20) NOT NULL,
    [LastSuccessfulRunUtc] DATETIME2 (7) NULL,
    [LastStatus] NVARCHAR (30) NOT NULL,
    [LastRunId] UNIQUEIDENTIFIER NULL,
    [TotalRawRecords] BIGINT NULL,
    [Notes] NVARCHAR (1000) NULL,
    [DataCreazione] DATETIME2 (7) NOT NULL,
    [DataModifica] DATETIME2 (7) NULL,
    [DataCancellazione] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingSIA],
    SCHEMA_NAME = N'SIA',
    OBJECT_NAME = N'FileMakerSyncState'
    );


GO

