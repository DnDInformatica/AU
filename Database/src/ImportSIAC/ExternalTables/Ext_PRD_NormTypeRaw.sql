CREATE EXTERNAL TABLE [ImportSIAC].[Ext_PRD_NormTypeRaw] (
    [Code] NVARCHAR (100) NOT NULL,
    [Description] NVARCHAR (1000) NULL,
    [DescriptionEn] NVARCHAR (1000) NULL,
    [MandatoryPurpose] BIT NULL,
    [MandatoryProfile] BIT NULL,
    [LoadedAtUtc] DATETIME2 (3) NOT NULL
)
    WITH (
    DATA_SOURCE = [StagingSIACDataSource],
    SCHEMA_NAME = N'PRD',
    OBJECT_NAME = N'NormTypeRaw'
    );


GO

