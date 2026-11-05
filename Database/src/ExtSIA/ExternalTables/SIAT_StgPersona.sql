CREATE EXTERNAL TABLE [ExtSIA].[SIAT_StgPersona] (
    [StgPersonaId] BIGINT NOT NULL,
    [RunId] UNIQUEIDENTIFIER NOT NULL,
    [LayoutName] NVARCHAR (255) NOT NULL,
    [FileMakerRecordId] NVARCHAR (100) NOT NULL,
    [NormalizationStatus] NVARCHAR (20) NOT NULL,
    [PersonaSIAT] NVARCHAR (50) NULL,
    [Nome] NVARCHAR (200) NULL,
    [Cognome] NVARCHAR (200) NULL,
    [CodiceFiscale] NVARCHAR (50) NULL,
    [CodiceGamma] NVARCHAR (50) NULL,
    [EmailPrincipale] NVARCHAR (200) NULL,
    [PersonaId] INT NULL,
    [SourceJson] NVARCHAR (MAX) NULL,
    [DataCreazione] DATETIME2 (7) NOT NULL,
    [DataCancellazione] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingSIA],
    SCHEMA_NAME = N'SIAT',
    OBJECT_NAME = N'StgPersona'
    );


GO

