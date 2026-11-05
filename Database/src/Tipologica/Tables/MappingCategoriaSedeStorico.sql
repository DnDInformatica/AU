CREATE TABLE [Tipologica].[MappingCategoriaSedeStorico] (
    [MappingId]                INT            NOT NULL,
    [CategoriaOrigine]         NVARCHAR (100) NULL,
    [TipoUnitaOrganizzativaId] INT            NOT NULL,
    [TipoSedeId]               INT            NOT NULL,
    [Principale]               BIT            NOT NULL,
    [Escludere]                BIT            NOT NULL,
    [Note]                     NVARCHAR (500) NULL,
    [DataInizioValidita]       DATETIME2 (7)  NOT NULL,
    [DataFineValidita]         DATETIME2 (7)  NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_MappingCategoriaSedeStorico]
    ON [Tipologica].[MappingCategoriaSedeStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

