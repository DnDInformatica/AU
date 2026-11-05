CREATE TABLE [ImportSIAC].[wrk_OrganizzazioneFonteCandidato] (
    [OrganizzazioneFonteCanonicaId] BIGINT       NOT NULL,
    [OrganizzazioneId]              INT          NOT NULL,
    [Metodo]                        VARCHAR (11) NOT NULL
);


GO

CREATE UNIQUE CLUSTERED INDEX [CX_wrk_OrganizzazioneFonteCandidato]
    ON [ImportSIAC].[wrk_OrganizzazioneFonteCandidato]([OrganizzazioneFonteCanonicaId] ASC, [OrganizzazioneId] ASC, [Metodo] ASC);


GO

