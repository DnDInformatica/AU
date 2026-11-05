CREATE EXTERNAL TABLE [ExtGIDAS].[LoadJobLog] (
    [LoadJobId] BIGINT NOT NULL,
    [RunId] NVARCHAR (50) NOT NULL,
    [ModuleCode] NVARCHAR (30) NOT NULL,
    [SourceSchema] NVARCHAR (128) NOT NULL,
    [SourceTable] NVARCHAR (255) NOT NULL,
    [SnapshotYear] SMALLINT NULL,
    [SnapshotMonth] TINYINT NULL,
    [Stage] NVARCHAR (30) NOT NULL,
    [Status] NVARCHAR (20) NOT NULL,
    [RowsLoaded] INT NULL,
    [StartedAt] DATETIME2 (7) NOT NULL,
    [FinishedAt] DATETIME2 (7) NULL,
    [DurationSec] INT NULL,
    [ErrorMessage] NVARCHAR (MAX) NULL,
    [HostName] NVARCHAR (128) NULL,
    [CreatedAt] DATETIME2 (7) NOT NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingGIDAS],
    SCHEMA_NAME = N'Load',
    OBJECT_NAME = N'LoadJobLog'
    );


GO

