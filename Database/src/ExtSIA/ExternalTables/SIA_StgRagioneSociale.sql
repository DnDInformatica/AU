CREATE EXTERNAL TABLE [ExtSIA].[SIA_StgRagioneSociale] (
    [StgRagioneSocialeId] BIGINT NOT NULL,
    [RunId] UNIQUEIDENTIFIER NOT NULL,
    [SourceDatabase] NVARCHAR (128) NOT NULL,
    [LayoutName] NVARCHAR (255) NOT NULL,
    [FileMakerRecordId] NVARCHAR (100) NOT NULL,
    [NormalizationStatus] NVARCHAR (20) NOT NULL,
    [Denominazione] NVARCHAR (500) NULL,
    [PartitaIva] NVARCHAR (50) NULL,
    [CodiceFiscale] NVARCHAR (50) NULL,
    [CodiceGamma] NVARCHAR (50) NULL,
    [CodiceSIA] NVARCHAR (50) NULL,
    [Attivo] NVARCHAR (1) NULL,
    [OrganizzazioneId] INT NULL,
    [SourceJson] NVARCHAR (MAX) NULL,
    [DataCreazione] DATETIME2 (7) NOT NULL,
    [DataCancellazione] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingSIA],
    SCHEMA_NAME = N'SIA',
    OBJECT_NAME = N'StgRagioneSociale'
    );


GO

