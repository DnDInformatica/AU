CREATE TABLE [ImportSIAC].[OrganizzazioneFonteComponente] (
    [OrganizzazioneFonteCanonicaId] BIGINT NOT NULL,
    [EntitaFonteId]                 INT    NOT NULL,
    CONSTRAINT [PK_ImportSIAC_OrganizzazioneFonteComponente] PRIMARY KEY CLUSTERED ([OrganizzazioneFonteCanonicaId] ASC),
    CONSTRAINT [FK_ImportSIAC_OrgFonteComponente_Canonica] FOREIGN KEY ([OrganizzazioneFonteCanonicaId]) REFERENCES [ImportSIAC].[OrganizzazioneFonteCanonica] ([OrganizzazioneFonteCanonicaId]),
    CONSTRAINT [FK_ImportSIAC_OrgFonteComponente_Entita] FOREIGN KEY ([EntitaFonteId]) REFERENCES [ImportSIAC].[OrganizzazioneFonteEntita] ([EntitaFonteId])
);


GO

CREATE NONCLUSTERED INDEX [IX_ImportSIAC_OrgFonteComponente_Entita]
    ON [ImportSIAC].[OrganizzazioneFonteComponente]([EntitaFonteId] ASC);


GO

