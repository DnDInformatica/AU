CREATE TABLE [ImportSIAC].[BuildHistory_Log] (
    [BuildHistoryLogId]    INT             IDENTITY (1, 1) NOT NULL,
    [StartedAt]            DATETIME2 (7)   CONSTRAINT [DF_BHL_StartedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    [FinishedAt]           DATETIME2 (7)   NULL,
    [DurationMs]           INT             NULL,
    [Status]               NVARCHAR (20)   NOT NULL,
    [RigheLette_PP]        INT             NULL,
    [RigheLette_PRD]       INT             NULL,
    [RigheLette_FPC]       INT             NULL,
    [RigheDedup_PP]        INT             NULL,
    [RigheDedup_PRD]       INT             NULL,
    [RigheDedup_FPC]       INT             NULL,
    [ScartateODC_PP]       INT             NULL,
    [ScartateODC_PRD]      INT             NULL,
    [ScartateODC_FPC]      INT             NULL,
    [NormeFallback_PP]     INT             NULL,
    [NormeFallback_PRD]    INT             NULL,
    [NormeFallback_FPC]    INT             NULL,
    [ScartateCertNull_FPC] INT             NULL,
    [PersoneInserite]      INT             NULL,
    [Cert_Correnti]        INT             NULL,
    [Cert_Storici]         INT             NULL,
    [SG_Correnti]          INT             NULL,
    [SG_Storici]           INT             NULL,
    [PRD_Correnti]         INT             NULL,
    [PRD_Storici]          INT             NULL,
    [FPC_Correnti]         INT             NULL,
    [FPC_Storici]          INT             NULL,
    [TotaleRigheTarget]    INT             NULL,
    [ErrorMessage]         NVARCHAR (4000) NULL,
    CONSTRAINT [PK_BuildHistory_Log] PRIMARY KEY CLUSTERED ([BuildHistoryLogId] ASC)
);


GO

