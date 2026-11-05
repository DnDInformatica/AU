CREATE EXTERNAL TABLE [ExtGIDAS].[StgProcesso] (
    [StgProcessoId] BIGINT NOT NULL,
    [RunId] UNIQUEIDENTIFIER NOT NULL,
    [LayoutName] NVARCHAR (255) NOT NULL,
    [FileMakerRecordId] NVARCHAR (100) NOT NULL,
    [FileMakerModId] NVARCHAR (100) NULL,
    [SourceModifiedAt] DATETIME2 (7) NULL,
    [NormalizationStatus] NVARCHAR (20) NOT NULL,
    [NormalizationNotes] NVARCHAR (1000) NULL,
    [CodiceProcesso] NVARCHAR (100) NULL,
    [TipoProcesso] NVARCHAR (100) NULL,
    [Progressivo] NVARCHAR (50) NULL,
    [DataApertura] DATE NULL,
    [DataTermine] DATE NULL,
    [DataVisita] DATE NULL,
    [DataCalcolata] DATE NULL,
    [ScadenzaAccreditamento] DATE NULL,
    [GiudizioSintetico] NVARCHAR (200) NULL,
    [Rischio] NVARCHAR (200) NULL,
    [SourceJson] NVARCHAR (MAX) NULL,
    [DataCreazione] DATETIME2 (7) NOT NULL,
    [DataModifica] DATETIME2 (7) NULL,
    [DataCancellazione] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingGIDAS],
    SCHEMA_NAME = N'GIDAS',
    OBJECT_NAME = N'StgProcesso'
    );


GO

