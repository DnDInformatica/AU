CREATE EXTERNAL TABLE [ImportSIAC].[Ext_PP_Raw] (
    [PP_RawId] BIGINT NOT NULL,
    [SnapshotYear] SMALLINT NOT NULL,
    [SnapshotMonth] TINYINT NOT NULL,
    [SourceTable] NVARCHAR (128) NOT NULL,
    [codente] NVARCHAR (150) NOT NULL,
    [odc_name] NVARCHAR (MAX) NULL,
    [fiscal_code] NVARCHAR (1000) NULL,
    [vat_number] NVARCHAR (1000) NULL,
    [ncertificate] NVARCHAR (200) NOT NULL,
    [first_issue_date] DATE NULL,
    [issue_date] DATE NULL,
    [expiry_date] DATE NULL,
    [publication_date] DATETIME2 (7) NULL,
    [insertdate] DATETIME2 (7) NULL,
    [revoked] BIT NULL,
    [revoked_date] DATE NULL,
    [scope_ita] NVARCHAR (MAX) NULL,
    [scope_eng] NVARCHAR (MAX) NULL,
    [sector_code] NVARCHAR (100) NULL,
    [norma_raw] NVARCHAR (500) NULL,
    [codg] NVARCHAR (200) NULL,
    [codn] NVARCHAR (200) NULL,
    [private] BIT NULL,
    [payload_json] NVARCHAR (MAX) NULL,
    [LoadDts] DATETIME2 (7) NOT NULL,
    [_IssueCode] NVARCHAR (50) NULL,
    [_FixCode] NVARCHAR (50) NULL,
    [_FixNote] NVARCHAR (500) NULL,
    [siglaschema] NVARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [StagingSIACDataSource],
    SCHEMA_NAME = N'PP',
    OBJECT_NAME = N'Raw'
    );


GO

