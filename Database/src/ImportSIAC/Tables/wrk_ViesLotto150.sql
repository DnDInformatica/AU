CREATE TABLE [ImportSIAC].[wrk_ViesLotto150] (
    [PartitaIVA]         NVARCHAR (20)  NOT NULL,
    [VatEco]             NVARCHAR (20)  NULL,
    [Valido]             BIT            NOT NULL,
    [NomeVies]           NVARCHAR (500) NULL,
    [IndirizzoVies]      NVARCHAR (500) NULL,
    [DataInterrogazione] DATETIME2 (7)  DEFAULT (sysutcdatetime()) NOT NULL,
    [NomePulito]         NVARCHAR (500) NULL,
    [Classe]             NVARCHAR (40)  NULL,
    [Motivo]             NVARCHAR (500) NULL,
    PRIMARY KEY CLUSTERED ([PartitaIVA] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Esiti dell interrogazione diretta al servizio VIES della Commissione europea sulle partite IVA gia presenti in SIDAC, usata per ricostruire le denominazioni corrotte dal difetto di caricamento (lotto 150). La colonna Classe distingue: SCRIVIBILE (denominazione ufficiale utilizzabile), VIES_NON_VALIDO (P.IVA non confermata: serve visura), NOME_TRONCATO (VIES tronca a 60 caratteri: serve completamento), GRUPPO_IVA (la P.IVA identifica un Gruppo IVA e non la persona giuridica accreditata). NomePulito rimuove il separatore !! con cui il VIES accoda la forma abbreviata. Interrogazione effettuata via PowerShell con lettura diretta del JSON, verificando che il vatNumber restituito coincida con quello richiesto.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'wrk_ViesLotto150';


GO

