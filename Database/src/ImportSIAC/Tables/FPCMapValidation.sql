CREATE TABLE [ImportSIAC].[FPCMapValidation] (
    [FPCMapValidationId]    INT             IDENTITY (1, 1) NOT NULL,
    [CheckedAtUtc]          DATETIME2 (3)   CONSTRAINT [DF_FPCVal_At] DEFAULT (sysutcdatetime()) NOT NULL,
    [NormCodeSiac]          NVARCHAR (50)   NOT NULL,
    [NormaAccreditamentoId] INT             NULL,
    [Riferimento]           NVARCHAR (40)   NULL,
    [TitoloSidac]           NVARCHAR (2000) NULL,
    [DescrizioneSorgente]   NVARCHAR (2000) NULL,
    [FonteSorgente]         NVARCHAR (20)   NULL,
    [Esito]                 NVARCHAR (20)   NOT NULL,
    PRIMARY KEY CLUSTERED ([FPCMapValidationId] ASC)
);


GO

