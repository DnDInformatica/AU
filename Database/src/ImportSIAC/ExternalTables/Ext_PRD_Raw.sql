CREATE EXTERNAL TABLE [ImportSIAC].[Ext_PRD_Raw] (
    [PRD_RawId] BIGINT NOT NULL,
    [SnapshotYear] SMALLINT NOT NULL,
    [SnapshotMonth] TINYINT NOT NULL,
    [SourceTable] NVARCHAR (128) NOT NULL,
    [codente] NVARCHAR (150) NOT NULL,
    [certificate_number] NVARCHAR (200) NOT NULL,
    [cert_release_date] DATE NOT NULL,
    [cert_expiration_date] DATE NULL,
    [cert_norm_type] NVARCHAR (500) NULL,
    [cert_purpose] NVARCHAR (MAX) NULL,
    [cert_product_name] NVARCHAR (MAX) NULL,
    [enel_technical_specification] NVARCHAR (MAX) NULL,
    [enel_professional_profile] NVARCHAR (MAX) NULL,
    [fiscal_code] NVARCHAR (1000) NULL,
    [vat_number] NVARCHAR (1000) NULL,
    [company_name] NVARCHAR (550) NULL,
    [payload_json] NVARCHAR (MAX) NULL,
    [LoadDts] DATETIME2 (7) NOT NULL,
    [_IssueCode] NVARCHAR (50) NULL,
    [_FixCode] NVARCHAR (50) NULL,
    [_FixNote] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [StagingSIACDataSource],
    SCHEMA_NAME = N'PRD',
    OBJECT_NAME = N'Raw'
    );


GO

