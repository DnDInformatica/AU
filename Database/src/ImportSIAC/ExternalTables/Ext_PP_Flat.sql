CREATE EXTERNAL TABLE [ImportSIAC].[Ext_PP_Flat] (
    [RawId] BIGINT NOT NULL,
    [SnapshotYear] SMALLINT NOT NULL,
    [SnapshotMonth] TINYINT NOT NULL,
    [NumeroCertificato] NVARCHAR (200) NULL,
    [codente] NVARCHAR (150) NOT NULL,
    [DataPrimoRilascio] DATE NULL,
    [DataEmissione] DATE NULL,
    [DataScadenza] DATE NULL,
    [DataRevoca] DATE NULL,
    [Privato] BIT NULL,
    [norma_raw] NVARCHAR (500) NULL,
    [siglaschema] NVARCHAR (255) NULL,
    [revoked] BIT NULL,
    [publication_date] DATETIME2 (3) NULL,
    [insertdate] DATETIME2 (3) NULL,
    [fiscal_code] NVARCHAR (1000) NULL,
    [vat_number] NVARCHAR (1000) NULL,
    [scope_ita] NVARCHAR (MAX) NULL,
    [scope_eng] NVARCHAR (MAX) NULL,
    [DataUltimoRinnovo] DATE NULL,
    [suspended] BIT NULL,
    [prev_cert_number] NVARCHAR (200) NULL,
    [sector_code] NVARCHAR (100) NULL,
    [sector_code_secondary_accredited] NVARCHAR (MAX) NULL,
    [sector_code_secondary_notaccredited] NVARCHAR (MAX) NULL,
    [source_record_id] NVARCHAR (100) NULL,
    [source_archive_id] INT NULL,
    [expired] BIT NULL,
    [region] NVARCHAR (200) NULL,
    [site_description] NVARCHAR (MAX) NULL,
    [json_piva] NVARCHAR (1000) NULL,
    [json_address] NVARCHAR (MAX) NULL,
    [json_city] NVARCHAR (MAX) NULL,
    [json_zipcode] NVARCHAR (MAX) NULL,
    [json_companyname] NVARCHAR (MAX) NULL,
    [json_province] NVARCHAR (MAX) NULL,
    [json_country] NVARCHAR (MAX) NULL,
    [json_sitetype] NVARCHAR (MAX) NULL
)
    WITH (
    DATA_SOURCE = [StagingSIACDataSource],
    SCHEMA_NAME = N'ImportSIAC',
    OBJECT_NAME = N'PP_Flat'
    );


GO

