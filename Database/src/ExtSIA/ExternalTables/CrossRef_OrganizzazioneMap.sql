CREATE EXTERNAL TABLE [ExtSIA].[CrossRef_OrganizzazioneMap] (
    [CrossRefOrganizzazioneMapId] BIGINT NOT NULL,
    [CodiceFiscale] NVARCHAR (50) NULL,
    [PartitaIva] NVARCHAR (50) NULL,
    [CodiceGamma] NVARCHAR (50) NULL,
    [CodiceSIA] NVARCHAR (50) NULL,
    [CodiceSIAT] NVARCHAR (50) NULL,
    [MatchMethod] NVARCHAR (30) NOT NULL,
    [MatchConfidence] NVARCHAR (20) NOT NULL,
    [OrganizzazioneId] INT NULL,
    [Status] NVARCHAR (20) NOT NULL,
    [Notes] NVARCHAR (1000) NULL,
    [DataCreazione] DATETIME2 (7) NOT NULL,
    [DataModifica] DATETIME2 (7) NULL,
    [DataCancellazione] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingSIA],
    SCHEMA_NAME = N'CrossRef',
    OBJECT_NAME = N'OrganizzazioneMap'
    );


GO

