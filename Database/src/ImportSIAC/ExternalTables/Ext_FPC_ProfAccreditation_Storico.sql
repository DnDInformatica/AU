CREATE EXTERNAL TABLE [ImportSIAC].[Ext_FPC_ProfAccreditation_Storico] (
    [EnteCode] NVARCHAR (200) NOT NULL,
    [ProfessionalCode] NVARCHAR (400) NOT NULL,
    [ValidoDal] DATE NOT NULL,
    [ValidoAl] DATE NULL,
    [IsCorrente] BIT NOT NULL,
    [NormaOrdinale] SMALLINT NOT NULL,
    [NormaTesto] NVARCHAR (800) NULL,
    [NormaBaseCanonica] NVARCHAR (400) NULL,
    [AnnoNorma] SMALLINT NULL,
    [RegolamentazioneODC] NVARCHAR (MAX) NULL,
    [IsSpecificaCAB] BIT NOT NULL,
    [HasNormaPubblica] BIT NOT NULL,
    [SchemaTipo] NVARCHAR (60) NULL,
    [LawRegulationIt] NVARCHAR (MAX) NULL,
    [LawRegHash] BINARY (32) NULL,
    [LoadDts] DATETIME2 (7) NOT NULL
)
    WITH (
    DATA_SOURCE = [StagingSIACDataSource],
    SCHEMA_NAME = N'ImportSIAC',
    OBJECT_NAME = N'Ext_FPC_ProfAccreditation_Storico'
    );


GO

