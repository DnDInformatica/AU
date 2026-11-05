CREATE EXTERNAL TABLE [ImportSIAC].[Ext_FPC_NormLookupRaw] (
    [Code] NVARCHAR (50) NOT NULL,
    [DescriptionIt] NVARCHAR (1000) NULL,
    [DescriptionEn] NVARCHAR (1000) NULL,
    [LawRegulationItJson] NVARCHAR (MAX) NULL,
    [LawRegulationEnJson] NVARCHAR (MAX) NULL,
    [SectorJson] NVARCHAR (MAX) NULL,
    [LoadedAtUtc] DATETIME2 (3) NOT NULL
)
    WITH (
    DATA_SOURCE = [StagingSIACDataSource],
    SCHEMA_NAME = N'FPC',
    OBJECT_NAME = N'NormLookupRaw'
    );


GO

