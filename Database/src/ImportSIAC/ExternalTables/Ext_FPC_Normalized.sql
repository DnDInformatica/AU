CREATE EXTERNAL TABLE [ImportSIAC].[Ext_FPC_Normalized] (
    [RawId] BIGINT NOT NULL,
    [SnapshotYear] SMALLINT NOT NULL,
    [SnapshotMonth] TINYINT NOT NULL,
    [NumeroCertificato] NVARCHAR (200) NULL,
    [codente] NVARCHAR (150) NOT NULL,
    [DataPrimoRilascio] DATE NOT NULL,
    [DataEmissione] DATE NULL,
    [DataScadenza] DATE NULL,
    [Privato] BIT NULL,
    [norma_raw] NVARCHAR (200) NULL,
    [siglaschema] NVARCHAR (128) NOT NULL,
    [LoadDts] DATETIME2 (7) NOT NULL,
    [person_code] NVARCHAR (150) NULL,
    [first_name] NVARCHAR (400) NULL,
    [last_name] NVARCHAR (400) NULL,
    [birth_date] DATE NULL,
    [birth_place] NVARCHAR (400) NULL,
    [fpc_fiscal_code] NVARCHAR (50) NULL,
    [competence_level] NVARCHAR (MAX) NULL,
    [json_professional_code] NVARCHAR (200) NULL,
    [json_foreigner] NVARCHAR (10) NULL,
    [json_id_group] INT NULL
)
    WITH (
    DATA_SOURCE = [StagingSIACDataSource],
    SCHEMA_NAME = N'ImportSIAC',
    OBJECT_NAME = N'vw_FPC_Normalized'
    );


GO

