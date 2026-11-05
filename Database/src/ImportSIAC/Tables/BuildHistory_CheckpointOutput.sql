CREATE TABLE [ImportSIAC].[BuildHistory_CheckpointOutput] (
    [StepCode]       NVARCHAR (50)  NOT NULL,
    [OutputTable]    NVARCHAR (200) NOT NULL,
    [RowCountAtSave] BIGINT         NOT NULL,
    [Ordinal]        SMALLINT       NOT NULL,
    [IsRequired]     BIT            CONSTRAINT [DF_BuildHistoryCheckpointOutput_IsRequired] DEFAULT ((1)) NOT NULL,
    [CompletedAt]    DATETIME2 (7)  NOT NULL,
    [ValidationMode] VARCHAR (10)   CONSTRAINT [DF_BuildHistoryCheckpointOutput_ValidationMode] DEFAULT ('FULL') NOT NULL,
    CONSTRAINT [PK_BuildHistory_CheckpointOutput] PRIMARY KEY CLUSTERED ([StepCode] ASC, [OutputTable] ASC),
    CONSTRAINT [CK_BuildHistoryCheckpointOutput_ValidationMode] CHECK ([ValidationMode]='METADATA' OR [ValidationMode]='FULL'),
    CONSTRAINT [FK_BuildHistoryCheckpointOutput_Checkpoint] FOREIGN KEY ([StepCode]) REFERENCES [ImportSIAC].[BuildHistory_Checkpoint] ([StepCode]),
    CONSTRAINT [UQ_BuildHistory_CheckpointOutput_Ordinal] UNIQUE NONCLUSTERED ([StepCode] ASC, [Ordinal] ASC)
);


GO

