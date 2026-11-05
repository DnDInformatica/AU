CREATE EXTERNAL TABLE [ImportSIAC].[Ext_PRD_Flat_Status] (
    [RawId] BIGINT NOT NULL,
    [SnapshotYear] SMALLINT NOT NULL,
    [SnapshotMonth] TINYINT NOT NULL,
    [NumeroCertificato] NVARCHAR (200) NULL,
    [codente] NVARCHAR (150) NOT NULL,
    [DataPrimoRilascio] DATE NULL,
    [DataScadenza] DATE NULL,
    [source_status_resolved] BIT NULL,
    [source_status_origin] VARCHAR (10) NULL,
    [revoked] BIT NULL,
    [revoked_date] DATE NULL,
    [odc_revoke_date] DATE NULL,
    [norma_raw] NVARCHAR (500) NULL,
    [siglaschema] NVARCHAR (128) NOT NULL,
    [LoadDts] DATETIME2 (7) NULL,
    [fiscal_code] NVARCHAR (1000) NULL,
    [vat_number] NVARCHAR (1000) NULL,
    [cert_purpose] NVARCHAR (MAX) NULL,
    [cert_product_name] NVARCHAR (MAX) NULL,
    [enel_technical_specification] NVARCHAR (MAX) NULL,
    [enel_professional_profile] NVARCHAR (MAX) NULL,
    [company_name] NVARCHAR (500) NULL,
    [json_site_address] NVARCHAR (4000) NULL,
    [json_site_city] NVARCHAR (4000) NULL,
    [json_site_zip] NVARCHAR (4000) NULL,
    [json_site_province] NVARCHAR (4000) NULL,
    [json_site_country] NVARCHAR (4000) NULL,
    [json_site_type] NVARCHAR (4000) NULL,
    [source_record_id] NVARCHAR (200) NULL,
    [source_archive_id] INT NULL,
    [suspended] BIT NULL,
    [prev_cert_number] NVARCHAR (200) NULL,
    [sector_code] NVARCHAR (100) NULL,
    [sector_code_secondary_accredited] NVARCHAR (MAX) NULL,
    [sector_code_secondary_notaccredited] NVARCHAR (MAX) NULL,
    [expired] BIT NULL,
    [region] NVARCHAR (200) NULL,
    [site_description] NVARCHAR (MAX) NULL
)
    WITH (
    DATA_SOURCE = [StagingSIACDataSource],
    SCHEMA_NAME = N'ImportSIAC',
    OBJECT_NAME = N'PRD_Flat'
    );


GO

