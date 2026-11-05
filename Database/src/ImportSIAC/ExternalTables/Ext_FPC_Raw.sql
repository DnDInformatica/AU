CREATE EXTERNAL TABLE [ImportSIAC].[Ext_FPC_Raw] (
    [FPC_RawId] BIGINT NOT NULL,
    [SnapshotYear] SMALLINT NOT NULL,
    [SnapshotMonth] TINYINT NOT NULL,
    [SourceTable] NVARCHAR (128) NOT NULL,
    [person_code] NVARCHAR (150) NULL,
    [codente] NVARCHAR (150) NOT NULL,
    [first_release_date] DATE NOT NULL,
    [certificate_number] NVARCHAR (200) NULL,
    [release_date] DATE NULL,
    [expiration_date] DATE NULL,
    [private] BIT NULL,
    [norm_code] NVARCHAR (200) NULL,
    [first_name] NVARCHAR (400) NULL,
    [last_name] NVARCHAR (400) NULL,
    [birth_date] DATE NULL,
    [birth_place] NVARCHAR (400) NULL,
    [payload_json] NVARCHAR (MAX) NULL,
    [LoadDts] DATETIME2 (7) NOT NULL,
    [_IssueCode] NVARCHAR (50) NULL,
    [_FixCode] NVARCHAR (50) NULL,
    [_FixNote] NVARCHAR (500) NULL,
    [fiscal_code] NVARCHAR (50) NULL,
    [professional_description] NVARCHAR (MAX) NULL,
    [competence_level] NVARCHAR (MAX) NULL,
    [law_regulation] NVARCHAR (MAX) NULL
)
    WITH (
    DATA_SOURCE = [StagingSIACDataSource],
    SCHEMA_NAME = N'FPC',
    OBJECT_NAME = N'Raw'
    );


GO

