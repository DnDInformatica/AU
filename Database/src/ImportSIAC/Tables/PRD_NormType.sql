CREATE TABLE [ImportSIAC].[PRD_NormType] (
    [Code]             NVARCHAR (100)  NOT NULL,
    [Description]      NVARCHAR (1000) NOT NULL,
    [DescriptionEn]    NVARCHAR (1000) NOT NULL,
    [MandatoryPurpose] BIT             NOT NULL,
    [MandatoryProfile] BIT             NOT NULL,
    [DataCaricamento]  DATETIME2 (7)   CONSTRAINT [DF_PRDNormType_Data] DEFAULT (sysutcdatetime()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Code] ASC)
);


GO

