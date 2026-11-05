CREATE TABLE [ImportSIAC].[PipelinePlanBaseline] (
    [BaselineId]           BIGINT          IDENTITY (1, 1) NOT NULL,
    [BuildHistoryLogId]    INT             NOT NULL,
    [CapturedAt]           DATETIME2 (7)   CONSTRAINT [DF_PPB_CapturedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    [ServiceObjective]     NVARCHAR (50)   NULL,
    [StepNo]               INT             NOT NULL,
    [StepCode]             NVARCHAR (100)  NOT NULL,
    [StepName]             NVARCHAR (200)  NULL,
    [Status]               NVARCHAR (40)   NULL,
    [StartedAt]            DATETIME2 (7)   NULL,
    [FinishedAt]           DATETIME2 (7)   NULL,
    [DurationSec]          AS              (CONVERT([decimal](18,2),[DurationMs])/(1000.0)) PERSISTED,
    [DurationMs]           BIGINT          NULL,
    [RowsAffected]         BIGINT          NULL,
    [ExtraInfo]            NVARCHAR (4000) NULL,
    [QS_QueryCount]        INT             NULL,
    [QS_TotCpuSec]         DECIMAL (18, 2) NULL,
    [QS_TotDurationSec]    DECIMAL (18, 2) NULL,
    [QS_TotLogicalReads]   BIGINT          NULL,
    [QS_TotLogicalWrites]  BIGINT          NULL,
    [QS_MaxTempdbMB]       DECIMAL (18, 2) NULL,
    [QS_MaxQueryMemMB]     DECIMAL (18, 2) NULL,
    [QS_AnyRowgoalOrSpill] BIT             NULL,
    PRIMARY KEY CLUSTERED ([BaselineId] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_PPB_Log]
    ON [ImportSIAC].[PipelinePlanBaseline]([BuildHistoryLogId] ASC, [StepNo] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_PPB_StepCode]
    ON [ImportSIAC].[PipelinePlanBaseline]([StepCode] ASC, [CapturedAt] ASC);


GO

