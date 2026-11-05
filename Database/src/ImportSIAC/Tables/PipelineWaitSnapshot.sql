CREATE TABLE [ImportSIAC].[PipelineWaitSnapshot] (
    [WaitSnapshotId]    BIGINT         IDENTITY (1, 1) NOT NULL,
    [BuildHistoryLogId] INT            NOT NULL,
    [Fase]              VARCHAR (10)   NOT NULL,
    [CapturedAt]        DATETIME2 (7)  CONSTRAINT [DF_PWS_At] DEFAULT (sysutcdatetime()) NOT NULL,
    [wait_type]         NVARCHAR (120) NOT NULL,
    [waiting_tasks]     BIGINT         NOT NULL,
    [wait_time_ms]      BIGINT         NOT NULL,
    [signal_wait_ms]    BIGINT         NOT NULL,
    [resource_wait_ms]  AS             ([wait_time_ms]-[signal_wait_ms]) PERSISTED,
    PRIMARY KEY CLUSTERED ([WaitSnapshotId] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_PWS_Log]
    ON [ImportSIAC].[PipelineWaitSnapshot]([BuildHistoryLogId] ASC, [Fase] ASC, [wait_type] ASC);


GO

