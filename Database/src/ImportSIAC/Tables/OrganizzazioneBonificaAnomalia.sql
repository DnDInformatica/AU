CREATE TABLE [ImportSIAC].[OrganizzazioneBonificaAnomalia] (
    [OrganizzazioneBonificaAnomaliaId] BIGINT          IDENTITY (1, 1) NOT NULL,
    [Sistema]                          NVARCHAR (10)   NOT NULL,
    [CodiceSorgente]                   NVARCHAR (100)  NOT NULL,
    [DenominazioneSorgente]            NVARCHAR (500)  NULL,
    [CodiceFiscale]                    NVARCHAR (50)   NULL,
    [PartitaIVA]                       NVARCHAR (50)   NULL,
    [TipoAnomalia]                     NVARCHAR (80)   NOT NULL,
    [Dettaglio]                        NVARCHAR (1000) NULL,
    [Stato]                            NVARCHAR (20)   CONSTRAINT [DF_OrgBonificaAnomalia_Stato] DEFAULT (N'APERTO') NOT NULL,
    [DataRilevazione]                  DATETIME2 (7)   CONSTRAINT [DF_OrgBonificaAnomalia_Data] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataRisoluzione]                  DATETIME2 (7)   NULL,
    PRIMARY KEY CLUSTERED ([OrganizzazioneBonificaAnomaliaId] ASC),
    CONSTRAINT [UQ_OrgBonificaAnomalia] UNIQUE NONCLUSTERED ([Sistema] ASC, [CodiceSorgente] ASC, [TipoAnomalia] ASC)
);


GO

