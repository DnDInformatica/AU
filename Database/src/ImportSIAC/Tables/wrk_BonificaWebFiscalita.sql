CREATE TABLE [ImportSIAC].[wrk_BonificaWebFiscalita] (
    [Id]                        INT             IDENTITY (1, 1) NOT NULL,
    [Lotto]                     NVARCHAR (20)   NOT NULL,
    [Sistema]                   NVARCHAR (20)   NOT NULL,
    [CodiceSorgente]            NVARCHAR (200)  NOT NULL,
    [DenominazioneSorgente]     NVARCHAR (1000) NULL,
    [Esito]                     NVARCHAR (20)   NOT NULL,
    [PartitaIVA]                NVARCHAR (20)   NULL,
    [CodiceFiscale]             NVARCHAR (32)   NULL,
    [PaeseISO2]                 NCHAR (2)       DEFAULT (N'IT') NOT NULL,
    [ViesValido]                BIT             NULL,
    [ViesNome]                  NVARCHAR (500)  NULL,
    [Confidenza]                NVARCHAR (10)   NULL,
    [OrganizzazioneIdCandidata] INT             NULL,
    [DenominazioneOrgCandidata] NVARCHAR (1000) NULL,
    [IdentitaCoerente]          BIT             NULL,
    [Azione]                    NVARCHAR (40)   NULL,
    [Fonti]                     NVARCHAR (MAX)  NULL,
    [Note]                      NVARCHAR (MAX)  NULL,
    [DataRilevazione]           DATETIME2 (7)   DEFAULT (sysutcdatetime()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Esiti della bonifica per ricerca web della fiscalita dei record GIDAS/SIA/SIAT senza CF/P.IVA. Ogni riga porta le fonti consultate, l esito della validazione VIES, il livello di confidenza e l azione proposta (RACCORDO_CERTO, ORG_DA_CENSIRE, IDENTITA_ORG_DA_BONIFICARE, RICERCA_DA_APPROFONDIRE). Tabella di lavoro: le righe diverse da RACCORDO_CERTO richiedono validazione del responsabile di processo prima di qualsiasi scrittura su Organizzazioni.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'wrk_BonificaWebFiscalita';


GO

