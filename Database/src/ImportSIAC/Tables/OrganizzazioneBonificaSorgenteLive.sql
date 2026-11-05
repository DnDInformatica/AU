CREATE TABLE [ImportSIAC].[OrganizzazioneBonificaSorgenteLive] (
    [Sistema]          NVARCHAR (20)   NOT NULL,
    [CodiceSorgente]   NVARCHAR (200)  NOT NULL,
    [RagioneSociale]   NVARCHAR (1000) NULL,
    [Denominazione]    NVARCHAR (1000) NULL,
    [CodiceFiscale]    NVARCHAR (100)  NULL,
    [PartitaIVA]       NVARCHAR (100)  NULL,
    [CodiceGamma]      NVARCHAR (100)  NULL,
    [Note]             NVARCHAR (2000) NULL,
    [DataAcquisizione] DATETIME2 (7)   CONSTRAINT [DF_OrganizzazioneBonificaSorgenteLive_Data] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_OrganizzazioneBonificaSorgenteLive] PRIMARY KEY CLUSTERED ([Sistema] ASC, [CodiceSorgente] ASC)
);


GO

