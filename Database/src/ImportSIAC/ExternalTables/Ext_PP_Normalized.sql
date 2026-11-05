CREATE EXTERNAL TABLE [ImportSIAC].[Ext_PP_Normalized] (
    [RawId] BIGINT NOT NULL,
    [SnapshotYear] SMALLINT NOT NULL,
    [SnapshotMonth] TINYINT NOT NULL,
    [NumeroCertificato] NVARCHAR (200) NOT NULL,
    [codente] NVARCHAR (150) NOT NULL,
    [DataPrimoRilascio] DATE NULL,
    [DataEmissione] DATE NULL,
    [DataScadenza] DATE NULL,
    [DataRevoca] DATE NULL,
    [Privato] BIT NULL,
    [norma_raw] NVARCHAR (500) NULL,
    [siglaschema] NVARCHAR (255) NULL,
    [revoked] BIT NULL,
    [publication_date] DATETIME2 (7) NULL,
    [insertdate] DATETIME2 (7) NULL,
    [fiscal_code] NVARCHAR (1000) NULL,
    [vat_number] NVARCHAR (1000) NULL,
    [scope_ita] NVARCHAR (MAX) NULL,
    [scope_eng] NVARCHAR (MAX) NULL,
    [DataUltimoRinnovo] DATE NULL,
    [json_piva] NVARCHAR (200) NULL,
    [json_address] NVARCHAR (500) NULL,
    [json_city] NVARCHAR (400) NULL,
    [json_zipcode] NVARCHAR (100) NULL,
    [json_companyname] NVARCHAR (500) NULL,
    [json_province] NVARCHAR (100) NULL,
    [json_country] NVARCHAR (100) NULL,
    [json_sitetype] NVARCHAR (50) NULL
)
    WITH (
    DATA_SOURCE = [StagingSIACDataSource],
    SCHEMA_NAME = N'ImportSIAC',
    OBJECT_NAME = N'vw_PP_Normalized'
    );


GO

