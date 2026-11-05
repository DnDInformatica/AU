CREATE EXTERNAL TABLE [ExtGIDAS].[StgIspettore] (
    [StgIspettoreId] BIGINT NOT NULL,
    [RunId] UNIQUEIDENTIFIER NOT NULL,
    [LayoutName] NVARCHAR (255) NOT NULL,
    [FileMakerRecordId] NVARCHAR (100) NOT NULL,
    [FileMakerModId] NVARCHAR (100) NULL,
    [SourceModifiedAt] DATETIME2 (7) NULL,
    [SourceCreatedAt] DATETIME2 (7) NULL,
    [SourceCreatedBy] NVARCHAR (128) NULL,
    [SourceModifiedBy] NVARCHAR (128) NULL,
    [SourceHash] VARBINARY (32) NULL,
    [RecordBusinessKey] NVARCHAR (500) NULL,
    [NormalizationStatus] NVARCHAR (20) NOT NULL,
    [NormalizationNotes] NVARCHAR (1000) NULL,
    [CodiceIspettore] NVARCHAR (100) NULL,
    [CodicePersona] NVARCHAR (100) NULL,
    [Qualifica] NVARCHAR (200) NULL,
    [StatoQualifica] NVARCHAR (200) NULL,
    [Dipartimento] NVARCHAR (200) NULL,
    [DataInizio] DATE NULL,
    [DataFine] DATE NULL,
    [DisponibilitaVisite] NVARCHAR (200) NULL,
    [AnniLaboratorio] INT NULL,
    [NoteQualifica] NVARCHAR (1000) NULL,
    [IspettoreId] INT NULL,
    [PersonaId] INT NULL,
    [SourceJson] NVARCHAR (MAX) NULL,
    [DataCreazione] DATETIME2 (7) NOT NULL,
    [DataModifica] DATETIME2 (7) NULL,
    [DataCancellazione] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingGIDAS],
    SCHEMA_NAME = N'GIDAS',
    OBJECT_NAME = N'StgIspettore'
    );


GO

