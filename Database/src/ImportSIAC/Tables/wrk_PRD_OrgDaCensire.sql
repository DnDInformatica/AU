CREATE TABLE [ImportSIAC].[wrk_PRD_OrgDaCensire] (
    [fiscal_code]           NVARCHAR (100) NOT NULL,
    [vat_number]            NVARCHAR (100) NULL,
    [raw_company_name]      NVARCHAR (500) NULL,
    [raw_site_address]      NVARCHAR (250) NULL,
    [raw_site_city]         NVARCHAR (150) NULL,
    [raw_site_zip]          NVARCHAR (50)  NULL,
    [raw_site_province]     NVARCHAR (50)  NULL,
    [raw_site_country]      NVARCHAR (100) NULL,
    [raw_site_type]         NVARCHAR (100) NULL,
    [NuovoOrganizzazioneId] INT            NULL
);


GO

CREATE UNIQUE CLUSTERED INDEX [CX_wrk_PRD_OrgDaCensire]
    ON [ImportSIAC].[wrk_PRD_OrgDaCensire]([fiscal_code] ASC);


GO

