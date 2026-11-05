CREATE TABLE [ImportSIAC].[wrk_Populate_Checkpoint] (
    [Dominio]       NVARCHAR (3)  NOT NULL,
    [SnapshotYear]  SMALLINT      NOT NULL,
    [SnapshotMonth] TINYINT       NOT NULL,
    [RowsInserted]  BIGINT        NOT NULL,
    [LoadedAtUtc]   DATETIME2 (0) CONSTRAINT [DF_wrk_Populate_Checkpoint_LoadedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_wrk_Populate_Checkpoint] PRIMARY KEY CLUSTERED ([Dominio] ASC, [SnapshotYear] ASC, [SnapshotMonth] ASC)
);


GO

