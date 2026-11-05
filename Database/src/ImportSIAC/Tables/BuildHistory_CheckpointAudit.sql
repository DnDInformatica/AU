CREATE TABLE [ImportSIAC].[BuildHistory_CheckpointAudit] (
    [CheckpointAuditId] BIGINT         IDENTITY (1, 1) NOT NULL,
    [CheckedAt]         DATETIME2 (7)  CONSTRAINT [DF_BuildHistoryCheckpointAudit_CheckedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    [StepCode]          NVARCHAR (50)  NOT NULL,
    [OutputTable]       NVARCHAR (200) NULL,
    [ExpectedRows]      BIGINT         NULL,
    [ActualRows]        BIGINT         NULL,
    [IsValid]           BIT            NOT NULL,
    [Reason]            NVARCHAR (500) NOT NULL,
    [SessionId]         SMALLINT       CONSTRAINT [DF_BuildHistoryCheckpointAudit_SessionId] DEFAULT (@@spid) NOT NULL,
    CONSTRAINT [PK_BuildHistory_CheckpointAudit] PRIMARY KEY CLUSTERED ([CheckpointAuditId] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_BuildHistoryCheckpointAudit_StepChecked]
    ON [ImportSIAC].[BuildHistory_CheckpointAudit]([StepCode] ASC, [CheckedAt] DESC);


GO

