CREATE TABLE [ImportSIAC].[OrganizzazioneFonteEntitaIdentificativo] (
    [EntitaFonteId] INT             NOT NULL,
    [Tipo]          VARCHAR (10)    NOT NULL,
    [ValoreNorm]    NVARCHAR (1000) NOT NULL,
    [ValoreRaw]     NVARCHAR (1000) NULL,
    CONSTRAINT [PK_ImportSIAC_OrganizzazioneFonteEntitaIdentificativo] PRIMARY KEY CLUSTERED ([EntitaFonteId] ASC, [Tipo] ASC, [ValoreNorm] ASC),
    CONSTRAINT [FK_ImportSIAC_OrgFonteEntitaIdentificativo_Entita] FOREIGN KEY ([EntitaFonteId]) REFERENCES [ImportSIAC].[OrganizzazioneFonteEntita] ([EntitaFonteId])
);


GO

CREATE NONCLUSTERED INDEX [IX_ImportSIAC_OrgFonteEntitaIdentificativo_Valore]
    ON [ImportSIAC].[OrganizzazioneFonteEntitaIdentificativo]([ValoreNorm] ASC)
    INCLUDE([EntitaFonteId], [Tipo]);


GO

