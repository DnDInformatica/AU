CREATE EXTERNAL TABLE [ExtGIDAS].[StgPersona] (
    [StgPersonaId] BIGINT NOT NULL,
    [RunId] UNIQUEIDENTIFIER NOT NULL,
    [LayoutName] NVARCHAR (255) NOT NULL,
    [FileMakerRecordId] NVARCHAR (100) NOT NULL,
    [FileMakerModId] NVARCHAR (100) NULL,
    [SourceModifiedAt] DATETIME2 (7) NULL,
    [SourceHash] VARBINARY (32) NULL,
    [RecordBusinessKey] NVARCHAR (500) NULL,
    [NormalizationStatus] NVARCHAR (20) NOT NULL,
    [NormalizationNotes] NVARCHAR (1000) NULL,
    [CodicePersona] NVARCHAR (100) NOT NULL,
    [Nome] NVARCHAR (200) NULL,
    [Cognome] NVARCHAR (200) NULL,
    [CodiceFiscale] NVARCHAR (50) NULL,
    [DataNascita] DATE NULL,
    [LuogoNascita] NVARCHAR (200) NULL,
    [ProvinciaNascita] NVARCHAR (100) NULL,
    [Qualifica] NVARCHAR (200) NULL,
    [Titolo] NVARCHAR (200) NULL,
    [EmailPrincipale] NVARCHAR (200) NULL,
    [Cellulare] NVARCHAR (100) NULL,
    [Telefono] NVARCHAR (100) NULL,
    [PersonaId] INT NULL,
    [SourceJson] NVARCHAR (MAX) NULL,
    [DataCreazione] DATETIME2 (7) NOT NULL,
    [DataModifica] DATETIME2 (7) NULL,
    [DataCancellazione] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingGIDAS],
    SCHEMA_NAME = N'GIDAS',
    OBJECT_NAME = N'StgPersona'
    );


GO

