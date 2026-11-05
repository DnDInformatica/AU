CREATE TABLE [ImportSIAC].[OrganizzazioneFonteEntitaMappa] (
    [EntitaFonteId]    INT           NOT NULL,
    [OrganizzazioneId] INT           NOT NULL,
    [Metodo]           VARCHAR (50)  NOT NULL,
    [DataCreazione]    DATETIME2 (7) DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ImportSIAC_OrganizzazioneFonteEntitaMappa] PRIMARY KEY CLUSTERED ([EntitaFonteId] ASC),
    CONSTRAINT [FK_ImportSIAC_OrgFonteEntitaMappa_Organizzazione] FOREIGN KEY ([OrganizzazioneId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId])
);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_ImportSIAC_OrgFonteEntitaMappa_Organizzazione]
    ON [ImportSIAC].[OrganizzazioneFonteEntitaMappa]([OrganizzazioneId] ASC);


GO

