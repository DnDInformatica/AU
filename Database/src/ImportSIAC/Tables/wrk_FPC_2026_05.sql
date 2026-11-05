CREATE TABLE [ImportSIAC].[wrk_FPC_2026_05] (
    [RawId]                     BIGINT          NOT NULL,
    [Dominio]                   NVARCHAR (3)    NOT NULL,
    [SnapshotYear]              SMALLINT        NULL,
    [SnapshotMonth]             TINYINT         NULL,
    [NumeroCertificato]         NVARCHAR (200)  NULL,
    [codente]                   NVARCHAR (300)  NULL,
    [DataPrimoRilascio]         DATE            NULL,
    [DataEmissione]             DATE            NULL,
    [DataScadenza]              DATE            NULL,
    [DataRevoca]                DATE            NULL,
    [Privato]                   BIT             NULL,
    [norma_raw]                 NVARCHAR (300)  NULL,
    [siglaschema]               NVARCHAR (300)  NULL,
    [StatoCertificazioneId]     INT             NULL,
    [publication_date]          DATETIME2 (7)   NULL,
    [insertdate]                DATETIME2 (7)   NULL,
    [fiscal_code]               NVARCHAR (1000) NULL,
    [vat_number]                NVARCHAR (1000) NULL,
    [AmbitoIta]                 NVARCHAR (MAX)  NULL,
    [AmbitoEng]                 NVARCHAR (MAX)  NULL,
    [DataUltimoRinnovo]         DATE            NULL,
    [sede_address]              NVARCHAR (1000) NULL,
    [sede_city]                 NVARCHAR (400)  NULL,
    [sede_zip]                  NVARCHAR (100)  NULL,
    [ScopoCertificato]          NVARCHAR (MAX)  NULL,
    [NomeProdotto]              NVARCHAR (MAX)  NULL,
    [SpecificaTecnica]          NVARCHAR (MAX)  NULL,
    [enel_professional_profile] NVARCHAR (MAX)  NULL,
    [person_code]               NVARCHAR (150)  NULL,
    [first_name]                NVARCHAR (400)  NULL,
    [last_name]                 NVARCHAR (400)  NULL,
    [birth_date]                DATE            NULL,
    [birth_place]               NVARCHAR (400)  NULL,
    [fpc_fiscal_code]           NVARCHAR (100)  NULL,
    [professional_code_json]    NVARCHAR (4000) NULL,
    [competence_level]          NVARCHAR (MAX)  NULL,
    [foreigner_json]            NVARCHAR (4000) NULL,
    [id_group_json]             INT             NULL,
    [fpc_release_date]          DATE            NULL,
    [raw_company_name]          NVARCHAR (500)  NULL,
    [raw_site_address]          NVARCHAR (1000) NULL,
    [raw_site_city]             NVARCHAR (400)  NULL,
    [raw_site_zip]              NVARCHAR (100)  NULL,
    [raw_site_province]         NVARCHAR (100)  NULL,
    [raw_site_country]          NVARCHAR (100)  NULL,
    [raw_site_type]             NVARCHAR (50)   NULL
);


GO

CREATE CLUSTERED INDEX [CX_wrk_FPC_2026_05_codente]
    ON [ImportSIAC].[wrk_FPC_2026_05]([codente] ASC, [RawId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_wrk_FPC_2026_05_codente]
    ON [ImportSIAC].[wrk_FPC_2026_05]([codente] ASC)
    INCLUDE([RawId], [Dominio], [SnapshotYear], [SnapshotMonth], [NumeroCertificato], [norma_raw], [professional_code_json]);


GO

