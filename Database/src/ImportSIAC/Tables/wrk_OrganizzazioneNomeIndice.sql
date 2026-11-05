CREATE TABLE [ImportSIAC].[wrk_OrganizzazioneNomeIndice] (
    [OrganizzazioneId] INT             IDENTITY (1, 1) NOT NULL,
    [NomeNorm]         NVARCHAR (4000) NULL
);


GO

CREATE NONCLUSTERED INDEX [IX_wrk_OrganizzazioneNomeIndice]
    ON [ImportSIAC].[wrk_OrganizzazioneNomeIndice]([NomeNorm] ASC);


GO

