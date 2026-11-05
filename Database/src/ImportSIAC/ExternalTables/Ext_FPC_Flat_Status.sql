CREATE EXTERNAL TABLE [ImportSIAC].[Ext_FPC_Flat_Status] (
    [RawId] BIGINT NOT NULL,
    [SnapshotYear] SMALLINT NOT NULL,
    [SnapshotMonth] TINYINT NOT NULL,
    [NumeroCertificato] NVARCHAR (200) NULL,
    [codente] NVARCHAR (150) NOT NULL,
    [DataPrimoRilascio] DATE NULL,
    [DataEmissione] DATE NULL,
    [DataScadenza] DATE NULL,
    [source_status_resolved] BIT NULL,
    [source_status_origin] VARCHAR (10) NULL,
    [revoked] BIT NULL,
    [revoked_date] DATE NULL,
    [odc_revoke_date] DATE NULL,
    [Privato] BIT NULL,
    [norma_raw] NVARCHAR (200) NULL,
    [siglaschema] NVARCHAR (128) NOT NULL,
    [LoadDts] DATETIME2 (7) NULL,
    [person_code] NVARCHAR (150) NULL,
    [first_name] NVARCHAR (400) NULL,
    [last_name] NVARCHAR (400) NULL,
    [birth_date] DATE NULL,
    [birth_place] NVARCHAR (400) NULL,
    [fpc_fiscal_code] NVARCHAR (50) NULL,
    [competence_level] NVARCHAR (MAX) NULL,
    [json_professional_code] NVARCHAR (4000) NULL,
    [json_foreigner] NVARCHAR (4000) NULL,
    [json_id_group] INT NULL,
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
    OBJECT_NAME = N'FPC_Flat'
    );


GO

