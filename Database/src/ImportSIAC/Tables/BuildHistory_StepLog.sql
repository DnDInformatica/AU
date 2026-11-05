CREATE TABLE [ImportSIAC].[BuildHistory_StepLog] (
    [BuildHistoryStepLogId] BIGINT          IDENTITY (1, 1) NOT NULL,
    [BuildHistoryLogId]     INT             NOT NULL,
    [StepNo]                INT             NOT NULL,
    [StepCode]              NVARCHAR (80)   NOT NULL,
    [StepName]              NVARCHAR (300)  NOT NULL,
    [StartedAt]             DATETIME2 (7)   NOT NULL,
    [FinishedAt]            DATETIME2 (7)   NULL,
    [DurationMs]            BIGINT          NULL,
    [Status]                NVARCHAR (30)   NOT NULL,
    [RowsAffected]          BIGINT          NULL,
    [ExtraInfo]             NVARCHAR (1000) NULL,
    [ErrorMessage]          NVARCHAR (4000) NULL,
    [SessionId]             SMALLINT        CONSTRAINT [DF_BHSL_SessionId] DEFAULT (@@spid) NOT NULL,
    [HostName]              NVARCHAR (128)  CONSTRAINT [DF_BHSL_HostName] DEFAULT (host_name()) NULL,
    [AppName]               NVARCHAR (128)  CONSTRAINT [DF_BHSL_AppName] DEFAULT (app_name()) NULL,
    CONSTRAINT [PK_BuildHistory_StepLog] PRIMARY KEY CLUSTERED ([BuildHistoryStepLogId] ASC)
);


GO

