CREATE EXTERNAL TABLE [ExtGIDAS].[StgAccreditamento] (
    [StgAccreditamentoId] BIGINT NOT NULL,
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
    [CodiceAccreditamento] NVARCHAR (100) NULL,
    [NumeroAccreditamento] NVARCHAR (100) NULL,
    [ProgressivoAccreditamento] NVARCHAR (100) NULL,
    [CodiceLaboratorio] NVARCHAR (100) NULL,
    [SiglaLaboratorio] NVARCHAR (100) NULL,
    [FkEnteKey] NVARCHAR (100) NULL,
    [FkNorma] NVARCHAR (100) NULL,
    [FkDipartimento] NVARCHAR (100) NULL,
    [DataAccreditamento] DATE NULL,
    [DataScadenza] DATE NULL,
    [DaOnlineFlag] BIT NULL,
    [IlacFlag] BIT NULL,
    [IdLabAnthesi] NVARCHAR (100) NULL,
    [TargetNormaAccreditamentoId] INT NULL,
    [TargetSchemaAccreditamentoId] INT NULL,
    [TargetOrganizzazioneId] INT NULL,
    [SourceJson] NVARCHAR (MAX) NULL,
    [DataCreazione] DATETIME2 (7) NOT NULL,
    [DataModifica] DATETIME2 (7) NULL,
    [DataCancellazione] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingGIDAS],
    SCHEMA_NAME = N'GIDAS',
    OBJECT_NAME = N'StgAccreditamento'
    );


GO

