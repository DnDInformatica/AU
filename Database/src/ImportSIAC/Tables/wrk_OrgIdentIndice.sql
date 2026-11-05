CREATE TABLE [ImportSIAC].[wrk_OrgIdentIndice] (
    [ValoreNorm]         VARCHAR (60) NOT NULL,
    [ValoreCifre]        VARCHAR (60) NULL,
    [TipoIdentificativo] VARCHAR (30) NOT NULL,
    [PaeseISO2]          CHAR (2)     NULL,
    [OrganizzazioneId]   INT          NOT NULL,
    [Provenienza]        VARCHAR (60) NOT NULL
);


GO

CREATE NONCLUSTERED INDEX [IX_wrk_OrgIdentIndice_Cifre]
    ON [ImportSIAC].[wrk_OrgIdentIndice]([ValoreCifre] ASC)
    INCLUDE([TipoIdentificativo], [OrganizzazioneId]);


GO

CREATE NONCLUSTERED INDEX [IX_wrk_OrgIdentIndice_Valore]
    ON [ImportSIAC].[wrk_OrgIdentIndice]([ValoreNorm] ASC)
    INCLUDE([TipoIdentificativo], [PaeseISO2], [OrganizzazioneId]);


GO

