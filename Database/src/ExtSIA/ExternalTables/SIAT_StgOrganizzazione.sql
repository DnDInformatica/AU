CREATE EXTERNAL TABLE [ExtSIA].[SIAT_StgOrganizzazione] (
    [StgOrganizzazioneId] BIGINT NOT NULL,
    [RunId] UNIQUEIDENTIFIER NOT NULL,
    [LayoutName] NVARCHAR (255) NOT NULL,
    [FileMakerRecordId] NVARCHAR (100) NOT NULL,
    [FileMakerModId] NVARCHAR (100) NULL,
    [SourceHash] VARBINARY (32) NULL,
    [RecordBusinessKey] NVARCHAR (500) NULL,
    [NormalizationStatus] NVARCHAR (20) NOT NULL,
    [NormalizationNotes] NVARCHAR (1000) NULL,
    [CodiceEnte] NVARCHAR (50) NULL,
    [Denominazione] NVARCHAR (500) NULL,
    [DettagliUO] NVARCHAR (200) NULL,
    [Categoria] NVARCHAR (200) NULL,
    [PartitaIva] NVARCHAR (50) NULL,
    [CodiceFiscale] NVARCHAR (50) NULL,
    [CodiceGamma] NVARCHAR (50) NULL,
    [CodiceSIAT] NVARCHAR (50) NULL,
    [CodiceSedeLaboratorio] NVARCHAR (50) NULL,
    [Chiave] NVARCHAR (10) NULL,
    [CodiceUnivoco] NVARCHAR (50) NULL,
    [CodNazFatt] NVARCHAR (50) NULL,
    [Pec] NVARCHAR (200) NULL,
    [PecFatturazione] NVARCHAR (200) NULL,
    [SitoWeb] NVARCHAR (300) NULL,
    [SplitPayment] NVARCHAR (5) NULL,
    [AppartenentaA] NVARCHAR (50) NULL,
    [Attivo] NVARCHAR (1) NULL,
    [Valido] NVARCHAR (1) NULL,
    [NoteFatturazione] NVARCHAR (MAX) NULL,
    [NoteContabili] NVARCHAR (MAX) NULL,
    [Note] NVARCHAR (MAX) NULL,
    [OrganizzazioneId] INT NULL,
    [SourceJson] NVARCHAR (MAX) NULL,
    [DataCreazione] DATETIME2 (7) NOT NULL,
    [DataModifica] DATETIME2 (7) NULL,
    [DataCancellazione] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [EDS_StagingSIA],
    SCHEMA_NAME = N'SIAT',
    OBJECT_NAME = N'StgOrganizzazione'
    );


GO

