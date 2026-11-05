CREATE EXTERNAL TABLE [ExtGIDAS].[StgOrganizzazione] (
    [StgOrganizzazioneId] BIGINT NOT NULL,
    [RunId] UNIQUEIDENTIFIER NOT NULL,
    [LayoutName] NVARCHAR (255) NOT NULL,
    [FileMakerRecordId] NVARCHAR (100) NOT NULL,
    [FileMakerModId] NVARCHAR (100) NULL,
    [SourceModifiedAt] DATETIME2 (7) NULL,
    [SourceHash] VARBINARY (32) NULL,
    [RecordBusinessKey] NVARCHAR (500) NULL,
    [NormalizationStatus] NVARCHAR (20) NOT NULL,
    [NormalizationNotes] NVARCHAR (1000) NULL,
    [CodiceEnte] NVARCHAR (100) NULL,
    [NumeroAccreditamento] NVARCHAR (100) NULL,
    [Denominazione] NVARCHAR (500) NULL,
    [RagioneSociale] NVARCHAR (500) NULL,
    [Acronimo] NVARCHAR (200) NULL,
    [CodiceFiscale] NVARCHAR (50) NULL,
    [PartitaIva] NVARCHAR (50) NULL,
    [CodiceGamma] NVARCHAR (100) NULL,
    [CodiceUnivoco] NVARCHAR (100) NULL,
    [EnteTitolareFlag] BIT NULL,
    [AccreditamentoSedeFlag] BIT NOT NULL,
    [Attivo] NVARCHAR (5) NULL,
    [OrganizzazioneId] INT NULL,
    [SourceJson] NVARCHAR (MAX) NULL,
    [DataCreazione] DATETIME2 (7) NOT NULL,
    [DataModifica] DATETIME2 (7) NULL,
    [DataCancellazione] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingGIDAS],
    SCHEMA_NAME = N'GIDAS',
    OBJECT_NAME = N'StgOrganizzazione'
    );


GO

