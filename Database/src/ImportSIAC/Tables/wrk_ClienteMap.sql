CREATE TABLE [ImportSIAC].[wrk_ClienteMap] (
    [fiscal_code]             NVARCHAR (1000) NULL,
    [vat_number]              NVARCHAR (1000) NULL,
    [parsed_paese_iso2]       NVARCHAR (2)    NULL,
    [parsed_valore_estero]    NVARCHAR (50)   NULL,
    [OrganizzazioneClienteId] INT             NULL
);


GO

CREATE CLUSTERED INDEX [CX_ClienteMap]
    ON [ImportSIAC].[wrk_ClienteMap]([fiscal_code] ASC, [vat_number] ASC);


GO

