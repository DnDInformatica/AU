CREATE TABLE [ImportSIAC].[wrk_SG_OrgDaCensire] (
    [piva_normalizzata]     NVARCHAR (11)   NULL,
    [fiscal_code]           NVARCHAR (1000) NULL,
    [vat_number]            NVARCHAR (1000) NULL,
    [raw_company_name]      NVARCHAR (500)  NULL,
    [raw_site_address]      NVARCHAR (1000) NULL,
    [raw_site_city]         NVARCHAR (400)  NULL,
    [raw_site_zip]          NVARCHAR (100)  NULL,
    [raw_site_country]      NVARCHAR (100)  NULL,
    [NuovoOrganizzazioneId] INT             NULL
);


GO

