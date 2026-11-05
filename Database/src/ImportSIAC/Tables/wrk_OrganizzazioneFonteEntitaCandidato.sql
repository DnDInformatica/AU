CREATE TABLE [ImportSIAC].[wrk_OrganizzazioneFonteEntitaCandidato] (
    [EntitaFonteId]    INT          NOT NULL,
    [OrganizzazioneId] INT          NOT NULL,
    [Metodo]           VARCHAR (19) NOT NULL
);


GO

CREATE UNIQUE CLUSTERED INDEX [CX_wrk_OrganizzazioneFonteEntitaCandidato]
    ON [ImportSIAC].[wrk_OrganizzazioneFonteEntitaCandidato]([EntitaFonteId] ASC, [OrganizzazioneId] ASC, [Metodo] ASC);


GO

