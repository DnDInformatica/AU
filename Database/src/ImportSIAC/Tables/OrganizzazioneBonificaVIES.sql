CREATE TABLE [ImportSIAC].[OrganizzazioneBonificaVIES] (
    [OrganizzazioneId]        INT             NOT NULL,
    [PaeseISO2]               CHAR (2)        NULL,
    [NumeroIVA]               NVARCHAR (40)   NULL,
    [Valido]                  BIT             NOT NULL,
    [RagioneSocialeUfficiale] NVARCHAR (1000) NULL,
    [IndirizzoUfficiale]      NVARCHAR (2000) NULL,
    [Errore]                  NVARCHAR (500)  NULL,
    [Fonte]                   NVARCHAR (500)  CONSTRAINT [DF_OrganizzazioneBonificaVIES_Fonte] DEFAULT (N'Commissione europea - VIES REST API') NOT NULL,
    [DataVerifica]            DATETIME2 (7)   CONSTRAINT [DF_OrganizzazioneBonificaVIES_Data] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_OrganizzazioneBonificaVIES] PRIMARY KEY CLUSTERED ([OrganizzazioneId] ASC),
    CONSTRAINT [FK_OrganizzazioneBonificaVIES_Organizzazione] FOREIGN KEY ([OrganizzazioneId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId])
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Esiti probatori della verifica VAT europea per la bonifica delle denominazioni numeriche SIDAC.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'OrganizzazioneBonificaVIES';


GO

