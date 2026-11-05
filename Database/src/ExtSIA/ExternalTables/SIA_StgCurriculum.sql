CREATE EXTERNAL TABLE [ExtSIA].[SIA_StgCurriculum] (
    [StgCurriculumId] BIGINT NOT NULL,
    [RunId] UNIQUEIDENTIFIER NOT NULL,
    [SourceDatabase] NVARCHAR (128) NOT NULL,
    [LayoutName] NVARCHAR (255) NOT NULL,
    [FileMakerRecordId] NVARCHAR (100) NOT NULL,
    [NormalizationStatus] NVARCHAR (20) NOT NULL,
    [CodiceReferente] NVARCHAR (50) NULL,
    [Tipo] NVARCHAR (300) NULL,
    [Titolo] NVARCHAR (500) NULL,
    [Ruolo] NVARCHAR (300) NULL,
    [Decorrenza] NVARCHAR (30) NULL,
    [Scadenza] NVARCHAR (30) NULL,
    [Stato] NVARCHAR (100) NULL,
    [Votazione] NVARCHAR (50) NULL,
    [CategoriaDerivata] NVARCHAR (30) NULL,
    [PersonaId] INT NULL,
    [SourceJson] NVARCHAR (MAX) NULL,
    [DataCreazione] DATETIME2 (7) NOT NULL,
    [DataModifica] DATETIME2 (7) NULL,
    [DataCancellazione] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingSIA],
    SCHEMA_NAME = N'SIA',
    OBJECT_NAME = N'StgCurriculum'
    );


GO

