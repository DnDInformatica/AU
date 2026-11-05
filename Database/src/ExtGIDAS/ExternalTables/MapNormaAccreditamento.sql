CREATE EXTERNAL TABLE [ExtGIDAS].[MapNormaAccreditamento] (
    [MapNormaAccreditamentoId] BIGINT NOT NULL,
    [SourceValue] NVARCHAR (255) NOT NULL,
    [NormalizedValue] NVARCHAR (255) NULL,
    [TargetNormaAccreditamentoId] INT NULL,
    [IsApproved] BIT NOT NULL,
    [Notes] NVARCHAR (1000) NULL,
    [DataCreazione] DATETIME2 (7) NOT NULL,
    [DataModifica] DATETIME2 (7) NULL,
    [DataCancellazione] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingGIDAS],
    SCHEMA_NAME = N'GIDAS',
    OBJECT_NAME = N'MapNormaAccreditamento'
    );


GO

