CREATE TABLE [ImportSIAC].[wrk_ESTERO_OrgDaCensire] (
    [map_fc]                NVARCHAR (1000)  NULL,
    [map_vn]                NVARCHAR (1000)  NULL,
    [parsed_paese_iso2]     NVARCHAR (2)     NULL,
    [parsed_valore_estero]  NVARCHAR (50)    NULL,
    [paese_iso2_norm]       NVARCHAR (2)     NULL,
    [raw_company_name]      NVARCHAR (500)   NULL,
    [raw_site_address]      NVARCHAR (1000)  NULL,
    [raw_site_city]         NVARCHAR (400)   NULL,
    [raw_site_zip]          NVARCHAR (100)   NULL,
    [raw_site_country]      NVARCHAR (100)   NULL,
    [TempGuid]              UNIQUEIDENTIFIER NULL,
    [NuovoOrganizzazioneId] INT              NULL
);


GO

