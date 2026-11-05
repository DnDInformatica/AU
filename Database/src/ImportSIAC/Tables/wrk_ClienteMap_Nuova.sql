CREATE TABLE [ImportSIAC].[wrk_ClienteMap_Nuova] (
    [fiscal_code]             NVARCHAR (1000) NULL,
    [vat_number]              NVARCHAR (1000) NULL,
    [IdAttuale]               INT             NULL,
    [IdNuovo]                 INT             NULL,
    [TipoIdentificativoUsato] VARCHAR (10)    NULL,
    [LivelloRipiego]          INT             NULL,
    [Candidati]               INT             NULL,
    [Esito]                   VARCHAR (12)    NOT NULL
);


GO

