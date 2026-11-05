CREATE EXTERNAL TABLE [ImportSIAC].[Ext_FPC_NormLookupLogRaw] (
    [IdLog] INT NOT NULL,
    [DateLog] DATETIME2 (6) NULL,
    [Code] NVARCHAR (50) NULL,
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
    OBJECT_NAME = N'NormLookupLogRaw'
    );


GO

