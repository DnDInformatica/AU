CREATE EXTERNAL TABLE [ExtSIA].[SIA_StgRecapito] (
    [StgRecapitoId] BIGINT NOT NULL,
    [RunId] UNIQUEIDENTIFIER NOT NULL,
    [SourceDatabase] NVARCHAR (128) NOT NULL,
    [LayoutName] NVARCHAR (255) NOT NULL,
    [FileMakerRecordId] NVARCHAR (100) NOT NULL,
    [NormalizationStatus] NVARCHAR (20) NOT NULL,
    [IdRecapitoSIA] NVARCHAR (100) NULL,
    [EntepPersona] NVARCHAR (500) NULL,
    [TipoRecapito] NVARCHAR (200) NULL,
    [TipoSede] NVARCHAR (200) NULL,
    [DettagliRecapito] NVARCHAR (500) NULL,
    [Comune] NVARCHAR (200) NULL,
    [Provincia] NVARCHAR (100) NULL,
    [Cap] NVARCHAR (100) NULL,
    [Regione] NVARCHAR (100) NULL,
    [Nazione] NVARCHAR (100) NULL,
    [ComuneProvinciEstera] NVARCHAR (300) NULL,
    [CodiceEnte] NVARCHAR (50) NULL,
    [CodiceSede] NVARCHAR (50) NULL,
    [CodiceReferente] NVARCHAR (50) NULL,
    [NonAttivo] NVARCHAR (100) NULL,
    [CtrMail] NVARCHAR (500) NULL,
    [SourceJson] NVARCHAR (MAX) NULL,
    [DataCreazione] DATETIME2 (7) NOT NULL,
    [DataModifica] DATETIME2 (7) NULL,
    [DataCancellazione] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingSIA],
    SCHEMA_NAME = N'SIA',
    OBJECT_NAME = N'StgRecapito'
    );


GO

