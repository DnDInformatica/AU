CREATE TABLE [ImportSIAC].[OrganizzazioneFonteCanonica] (
    [OrganizzazioneFonteCanonicaId] BIGINT          NOT NULL,
    [FiscalCodeNorm]                NVARCHAR (1000) NULL,
    [VatNumberNorm]                 NVARCHAR (1000) NULL,
    [FiscalCodeRaw]                 NVARCHAR (1000) NULL,
    [VatNumberRaw]                  NVARCHAR (1000) NULL,
    [RagioneSociale]                NVARCHAR (1000) NULL,
    [CodEnte]                       NVARCHAR (150)  NULL,
    [Indirizzo]                     NVARCHAR (1000) NULL,
    [Citta]                         NVARCHAR (500)  NULL,
    [CAP]                           NVARCHAR (100)  NULL,
    [Provincia]                     NVARCHAR (200)  NULL,
    [Paese]                         NVARCHAR (200)  NULL,
    [PrimoSnapshot]                 INT             NOT NULL,
    [UltimoSnapshot]                INT             NOT NULL,
    [NumeroOccorrenze]              BIGINT          NOT NULL,
    [NumeroVarianti]                INT             NOT NULL,
    [PresentePP]                    BIT             NOT NULL,
    [PresentePRD]                   BIT             NOT NULL,
    [EsitoRaccordo]                 VARCHAR (30)    NULL,
    [OrganizzazioneId]              INT             NULL,
    [MetodoRaccordo]                VARCHAR (50)    NULL,
    [NumeroCandidati]               INT             NULL,
    [DataAcquisizione]              DATETIME2 (7)   CONSTRAINT [DF_ImportSIAC_OrgFonteCanonica_Data] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ImportSIAC_OrganizzazioneFonteCanonica] PRIMARY KEY CLUSTERED ([OrganizzazioneFonteCanonicaId] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_ImportSIAC_OrgFonteCanonica_CF]
    ON [ImportSIAC].[OrganizzazioneFonteCanonica]([FiscalCodeNorm] ASC)
    INCLUDE([VatNumberNorm], [OrganizzazioneId], [EsitoRaccordo]);


GO

CREATE NONCLUSTERED INDEX [IX_ImportSIAC_OrgFonteCanonica_PIVA]
    ON [ImportSIAC].[OrganizzazioneFonteCanonica]([VatNumberNorm] ASC)
    INCLUDE([FiscalCodeNorm], [OrganizzazioneId], [EsitoRaccordo]);


GO

