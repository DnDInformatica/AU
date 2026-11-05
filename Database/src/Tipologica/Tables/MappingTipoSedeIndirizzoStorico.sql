CREATE TABLE [Tipologica].[MappingTipoSedeIndirizzoStorico] (
    [MappingId]          INT            NOT NULL,
    [TipoSedeOrigine]    NVARCHAR (100) NULL,
    [TipoIndirizzoId]    INT            NOT NULL,
    [Principale]         BIT            NOT NULL,
    [Note]               NVARCHAR (200) NULL,
    [DataInizioValidita] DATETIME2 (7)  NOT NULL,
    [DataFineValidita]   DATETIME2 (7)  NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_MappingTipoSedeIndirizzoStorico]
    ON [Tipologica].[MappingTipoSedeIndirizzoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

