CREATE EXTERNAL TABLE [ExtSIA].[SIA_StgIncompatibilita] (
    [StgIncompatibilitaId] BIGINT NOT NULL,
    [RunId] UNIQUEIDENTIFIER NOT NULL,
    [SourceDatabase] NVARCHAR (128) NOT NULL,
    [LayoutName] NVARCHAR (255) NOT NULL,
    [FileMakerRecordId] NVARCHAR (100) NOT NULL,
    [NormalizationStatus] NVARCHAR (20) NOT NULL,
    [PersonaId_SIA] NVARCHAR (50) NULL,
    [CodiceEnte] NVARCHAR (50) NULL,
    [Ente] NVARCHAR (500) NULL,
    [TipologiaIncompatibilita] NVARCHAR (200) NULL,
    [DataInizio] NVARCHAR (30) NULL,
    [DataFine] NVARCHAR (30) NULL,
    [Fonte] NVARCHAR (100) NULL,
    [Dipartimento] NVARCHAR (200) NULL,
    [Chiave] NVARCHAR (200) NULL,
    [Note] NVARCHAR (MAX) NULL,
    [PersonaId] INT NULL,
    [SourceJson] NVARCHAR (MAX) NULL,
    [DataCreazione] DATETIME2 (7) NOT NULL,
    [DataModifica] DATETIME2 (7) NULL,
    [DataCancellazione] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingSIA],
    SCHEMA_NAME = N'SIA',
    OBJECT_NAME = N'StgIncompatibilita'
    );


GO

