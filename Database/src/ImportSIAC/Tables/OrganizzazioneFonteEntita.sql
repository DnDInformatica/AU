CREATE TABLE [ImportSIAC].[OrganizzazioneFonteEntita] (
    [EntitaFonteId]                        INT             NOT NULL,
    [OrganizzazioneFonteRappresentativaId] BIGINT          NOT NULL,
    [RagioneSociale]                       NVARCHAR (1000) NOT NULL,
    [FiscalCodeRaw]                        NVARCHAR (1000) NULL,
    [VatNumberRaw]                         NVARCHAR (1000) NULL,
    [CodEnte]                              NVARCHAR (150)  NULL,
    [Indirizzo]                            NVARCHAR (1000) NULL,
    [Citta]                                NVARCHAR (500)  NULL,
    [CAP]                                  NVARCHAR (100)  NULL,
    [Provincia]                            NVARCHAR (200)  NULL,
    [Paese]                                NVARCHAR (200)  NULL,
    [PrimoSnapshot]                        INT             NOT NULL,
    [UltimoSnapshot]                       INT             NOT NULL,
    [NumeroOccorrenze]                     BIGINT          NOT NULL,
    [NumeroChiavi]                         INT             NOT NULL,
    [PresentePP]                           BIT             NOT NULL,
    [PresentePRD]                          BIT             NOT NULL,
    [EsitoRaccordo]                        VARCHAR (30)    NULL,
    [OrganizzazioneId]                     INT             NULL,
    [MetodoRaccordo]                       VARCHAR (50)    NULL,
    [NumeroCandidati]                      INT             NULL,
    [DataConsolidamento]                   DATETIME2 (7)   DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ImportSIAC_OrganizzazioneFonteEntita] PRIMARY KEY CLUSTERED ([EntitaFonteId] ASC)
);


GO

