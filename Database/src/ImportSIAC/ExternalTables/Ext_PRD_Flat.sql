CREATE EXTERNAL TABLE [ImportSIAC].[Ext_PRD_Flat] (
    [RawId] BIGINT NOT NULL,
    [SnapshotYear] SMALLINT NOT NULL,
    [SnapshotMonth] TINYINT NOT NULL,
    [NumeroCertificato] NVARCHAR (200) NOT NULL,
    [codente] NVARCHAR (150) NOT NULL,
    [DataPrimoRilascio] DATE NOT NULL,
    [DataScadenza] DATE NULL,
    [norma_raw] NVARCHAR (500) NULL,
    [siglaschema] NVARCHAR (128) NOT NULL,
    [LoadDts] DATETIME2 (7) NOT NULL,
    [fiscal_code] NVARCHAR (1000) NULL,
    [vat_number] NVARCHAR (1000) NULL,
    [cert_purpose] NVARCHAR (MAX) NULL,
    [cert_product_name] NVARCHAR (MAX) NULL,
    [enel_technical_specification] NVARCHAR (MAX) NULL,
    [enel_professional_profile] NVARCHAR (MAX) NULL,
    [company_name] NVARCHAR (500) NULL,
    [json_site_address] NVARCHAR (500) NULL,
    [json_site_city] NVARCHAR (400) NULL,
    [json_site_zip] NVARCHAR (100) NULL,
    [json_site_province] NVARCHAR (100) NULL,
    [json_site_country] NVARCHAR (100) NULL,
    [json_site_type] NVARCHAR (50) NULL
)
    WITH (
    DATA_SOURCE = [StagingSIACDataSource],
    SCHEMA_NAME = N'ImportSIAC',
    OBJECT_NAME = N'PRD_Flat'
    );


GO

