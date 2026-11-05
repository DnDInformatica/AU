CREATE EXTERNAL TABLE [ExtSIA].[SIA_StgPersona] (
    [StgPersonaId] BIGINT NOT NULL,
    [RunId] UNIQUEIDENTIFIER NOT NULL,
    [SourceDatabase] NVARCHAR (128) NOT NULL,
    [LayoutName] NVARCHAR (255) NOT NULL,
    [FileMakerRecordId] NVARCHAR (100) NOT NULL,
    [FileMakerModId] NVARCHAR (100) NULL,
    [SourceHash] VARBINARY (32) NULL,
    [RecordBusinessKey] NVARCHAR (500) NULL,
    [NormalizationStatus] NVARCHAR (20) NOT NULL,
    [NormalizationNotes] NVARCHAR (1000) NULL,
    [PersonaSIA] NVARCHAR (50) NULL,
    [Nome] NVARCHAR (200) NULL,
    [Cognome] NVARCHAR (200) NULL,
    [FormulaDiSaluto] NVARCHAR (100) NULL,
    [CodiceFiscale] NVARCHAR (50) NULL,
    [DataNascita] NVARCHAR (30) NULL,
    [LuogoNascita] NVARCHAR (200) NULL,
    [ProvinciaNascita] NVARCHAR (100) NULL,
    [NomeAzienda] NVARCHAR (300) NULL,
    [CodiceGamma] NVARCHAR (50) NULL,
    [Matricola] NVARCHAR (50) NULL,
    [IdZucchetti] NVARCHAR (50) NULL,
    [EmailPrincipale] NVARCHAR (200) NULL,
    [Cellulare] NVARCHAR (100) NULL,
    [TelefonoCasa] NVARCHAR (100) NULL,
    [TelefonoSecondario] NVARCHAR (100) NULL,
    [EmailSecondaria] NVARCHAR (200) NULL,
    [CodiceEnte] NVARCHAR (50) NULL,
    [CodiceSede] NVARCHAR (50) NULL,
    [Dipartimento] NVARCHAR (200) NULL,
    [EntiCollegati] NVARCHAR (500) NULL,
    [CodOmonimie] NVARCHAR (50) NULL,
    [NotePersona] NVARCHAR (MAX) NULL,
    [PersonaId] INT NULL,
    [SourceJson] NVARCHAR (MAX) NULL,
    [DataCreazione] DATETIME2 (7) NOT NULL,
    [DataModifica] DATETIME2 (7) NULL,
    [DataCancellazione] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingSIA],
    SCHEMA_NAME = N'SIA',
    OBJECT_NAME = N'StgPersona'
    );


GO

