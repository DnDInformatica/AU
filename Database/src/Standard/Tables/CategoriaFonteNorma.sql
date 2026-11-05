CREATE TABLE [Standard].[CategoriaFonteNorma] (
    [CategoriaFonteNormaId] INT                                                IDENTITY (1, 1) NOT NULL,
    [Codice]                NVARCHAR (40)                                      NOT NULL,
    [Descrizione]           NVARCHAR (500)                                     NOT NULL,
    [Attivo]                BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]         DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]              INT                                                NULL,
    [DataModifica]          DATETIME2 (7)                                      NULL,
    [ModificatoDa]          INT                                                NULL,
    [DataCancellazione]     DATETIME2 (7)                                      NULL,
    [CancellatoDa]          INT                                                NULL,
    [UniqueRowId]           UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]    DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]      DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_CategoriaFonteNorma] PRIMARY KEY CLUSTERED ([CategoriaFonteNormaId] ASC),
    CONSTRAINT [CK_CategoriaFonteNorma_Codice] CHECK (len(ltrim(rtrim([Codice])))>(0)),
    CONSTRAINT [CK_CategoriaFonteNorma_Descrizione] CHECK (len(ltrim(rtrim([Descrizione])))>(0)),
    CONSTRAINT [UQ_CategoriaFonteNorma_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[CategoriaFonteNormaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice della categoria fonte: quadro normativo di accreditamento, normativa europea, normativa italiana, standard internazionale, schema proprietario o altra categoria codificata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'CategoriaFonteNorma', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata della categoria di fonte normativa nel Modello B.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'CategoriaFonteNorma', @level2type = N'COLUMN', @level2name = N'CategoriaFonteNormaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione della categoria fonte. Usare per distinguere natura e provenienza della norma senza dedurre il ruolo applicativo, che appartiene a TipoNormaAccreditamento.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'CategoriaFonteNorma', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

