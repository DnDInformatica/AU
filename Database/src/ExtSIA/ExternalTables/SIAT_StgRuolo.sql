CREATE EXTERNAL TABLE [ExtSIA].[SIAT_StgRuolo] (
    [StgRuoloId] BIGINT NOT NULL,
    [RunId] UNIQUEIDENTIFIER NOT NULL,
    [LayoutName] NVARCHAR (255) NOT NULL,
    [FileMakerRecordId] NVARCHAR (100) NOT NULL,
    [NormalizationStatus] NVARCHAR (20) NOT NULL,
    [PersonaId_SIAT] NVARCHAR (50) NULL,
    [CodiceEnte] NVARCHAR (50) NULL,
    [CodiceSede] NVARCHAR (50) NULL,
    [DipartimentoArea] NVARCHAR (200) NULL,
    [SedeLavoro] NVARCHAR (200) NULL,
    [RuoloAziendale] NVARCHAR (300) NULL,
    [RuoloAziendaleEsteso] NVARCHAR (500) NULL,
    [Ente] NVARCHAR (500) NULL,
    [RapportoConEnte] NVARCHAR (200) NULL,
    [DataInizio] NVARCHAR (30) NULL,
    [DataFine] NVARCHAR (30) NULL,
    [Attivo] NVARCHAR (1) NULL,
    [NoteQualifica] NVARCHAR (MAX) NULL,
    [SourceJson] NVARCHAR (MAX) NULL,
    [DataCreazione] DATETIME2 (7) NOT NULL,
    [DataCancellazione] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingSIA],
    SCHEMA_NAME = N'SIAT',
    OBJECT_NAME = N'StgRuolo'
    );


GO

