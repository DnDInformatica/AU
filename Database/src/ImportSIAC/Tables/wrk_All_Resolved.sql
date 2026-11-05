CREATE TABLE [ImportSIAC].[wrk_All_Resolved] (
    [RawId]                   BIGINT          NULL,
    [Dominio]                 NVARCHAR (3)    NULL,
    [SnapshotYear]            SMALLINT        NULL,
    [SnapshotMonth]           TINYINT         NULL,
    [SnapshotDate]            DATE            NULL,
    [SnapshotBusinessTs]      DATETIME2 (7)   NULL,
    [NumeroCertificato]       NVARCHAR (200)  NULL,
    [codente]                 NVARCHAR (300)  NULL,
    [DataPrimoRilascio]       DATE            NULL,
    [DataEmissione]           DATE            NULL,
    [DataScadenza]            DATE            NULL,
    [DataRevoca]              DATE            NULL,
    [Privato]                 BIT             NULL,
    [StatoCertificazioneId]   INT             NULL,
    [publication_date]        DATETIME2 (7)   NULL,
    [insertdate]              DATETIME2 (7)   NULL,
    [OrganizzazioneODCId]     INT             NULL,
    [TipoCertificazioneId]    INT             NULL,
    [NormaAccreditamentoId]   INT             NULL,
    [NormaFallbackUsata]      BIT             NULL,
    [OrganizzazioneClienteId] INT             NULL,
    [AmbitoIta]               NVARCHAR (MAX)  NULL,
    [AmbitoEng]               NVARCHAR (MAX)  NULL,
    [DataUltimoRinnovo]       DATE            NULL,
    [sede_address]            NVARCHAR (1000) NULL,
    [sede_city]               NVARCHAR (400)  NULL,
    [sede_zip]                NVARCHAR (100)  NULL,
    [raw_site_type]           NVARCHAR (50)   NULL,
    [raw_site_province]       NVARCHAR (100)  NULL,
    [raw_site_country]        NVARCHAR (100)  NULL,
    [ScopoCertificato]        NVARCHAR (MAX)  NULL,
    [NomeProdotto]            NVARCHAR (MAX)  NULL,
    [SpecificaTecnica]        NVARCHAR (MAX)  NULL,
    [ProfiloProfessionaleId]  INT             NULL,
    [person_code]             NVARCHAR (150)  NULL,
    [first_name]              NVARCHAR (400)  NULL,
    [last_name]               NVARCHAR (400)  NULL,
    [birth_date]              DATE            NULL,
    [birth_place]             NVARCHAR (400)  NULL,
    [fpc_fiscal_code]         NVARCHAR (100)  NULL,
    [professional_code_json]  NVARCHAR (4000) NULL,
    [competence_level]        NVARCHAR (MAX)  NULL,
    [Straniero]               BIT             NULL,
    [SiacId]                  INT             NULL,
    [fpc_release_date]        DATE            NULL,
    [TipoQualificaId]         INT             NULL
);


GO

CREATE CLUSTERED COLUMNSTORE INDEX [CCI_All_Resolved]
    ON [ImportSIAC].[wrk_All_Resolved];


GO

