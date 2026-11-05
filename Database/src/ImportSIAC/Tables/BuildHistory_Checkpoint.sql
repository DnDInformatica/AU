CREATE TABLE [ImportSIAC].[BuildHistory_Checkpoint] (
    [StepCode]        NVARCHAR (50)   NOT NULL,
    [Status]          VARCHAR (10)    NOT NULL,
    [OutputTable]     NVARCHAR (200)  NULL,
    [RowCountAtSave]  BIGINT          NULL,
    [SourceSignature] NVARCHAR (200)  NULL,
    [CompletedAt]     DATETIME2 (7)   NULL,
    [Notes]           NVARCHAR (500)  NULL,
    [MetricsJson]     NVARCHAR (2000) NULL,
    PRIMARY KEY CLUSTERED ([StepCode] ASC),
    CONSTRAINT [CK_BuildHistoryCheckpoint_MetricsJson] CHECK ([MetricsJson] IS NULL OR isjson([MetricsJson])=(1))
);


GO

