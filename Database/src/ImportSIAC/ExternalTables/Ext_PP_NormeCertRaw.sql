CREATE EXTERNAL TABLE [ImportSIAC].[Ext_PP_NormeCertRaw] (
    [IdRelease] INT NULL,
    [Norma] NVARCHAR (500) NULL,
    [SiglaSchema] NVARCHAR (50) NULL,
    [CodN] NVARCHAR (50) NULL,
    [CodG] NVARCHAR (50) NULL,
    [IndicePriorita] NVARCHAR (50) NULL,
    [TitoloIta] NVARCHAR (2000) NULL,
    [TitoloIng] NVARCHAR (2000) NULL,
    [FlagCaricaSenzaSettore] BIT NULL,
    [LoadedAtUtc] DATETIME2 (3) NOT NULL
)
    WITH (
    DATA_SOURCE = [StagingSIACDataSource],
    SCHEMA_NAME = N'PP',
    OBJECT_NAME = N'NormeCertRaw'
    );


GO

