CREATE EXTERNAL TABLE [ExtSIA].[CrossRef_PersonaMap] (
    [CrossRefPersonaMapId] BIGINT NOT NULL,
    [CodiceFiscale] NVARCHAR (50) NULL,
    [CodiceGamma] NVARCHAR (50) NULL,
    [PersonaSIA] NVARCHAR (50) NULL,
    [PersonaSIAT] NVARCHAR (50) NULL,
    [MatchMethod] NVARCHAR (30) NOT NULL,
    [MatchConfidence] NVARCHAR (20) NOT NULL,
    [PersonaId] INT NULL,
    [Status] NVARCHAR (20) NOT NULL,
    [Notes] NVARCHAR (1000) NULL,
    [DataCreazione] DATETIME2 (7) NOT NULL,
    [DataModifica] DATETIME2 (7) NULL,
    [DataCancellazione] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingSIA],
    SCHEMA_NAME = N'CrossRef',
    OBJECT_NAME = N'PersonaMap'
    );


GO

