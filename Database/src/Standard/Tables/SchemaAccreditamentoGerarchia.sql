CREATE TABLE [Standard].[SchemaAccreditamentoGerarchia] (
    [SchemaAccreditamentoGerarchiaId] INT                                                IDENTITY (1, 1) NOT NULL,
    [PadreId]                         INT                                                NOT NULL,
    [FiglioId]                        INT                                                NOT NULL,
    [Profondita]                      INT                                                NOT NULL,
    [Note]                            NVARCHAR (500)                                     NULL,
    [Attivo]                          BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]                   DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                        INT                                                NULL,
    [DataModifica]                    DATETIME2 (7)                                      NULL,
    [ModificatoDa]                    INT                                                NULL,
    [DataCancellazione]               DATETIME2 (7)                                      NULL,
    [CancellatoDa]                    INT                                                NULL,
    [UniqueRowId]                     UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]              DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]                DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_SchemaAccreditamentoGerarchia] PRIMARY KEY CLUSTERED ([SchemaAccreditamentoGerarchiaId] ASC),
    CONSTRAINT [FK_SchemaAccrGerarchia_Figlio] FOREIGN KEY ([FiglioId]) REFERENCES [Standard].[SchemaAccreditamento] ([SchemaAccreditamentoId]),
    CONSTRAINT [FK_SchemaAccrGerarchia_Padre] FOREIGN KEY ([PadreId]) REFERENCES [Standard].[SchemaAccreditamento] ([SchemaAccreditamentoId]),
    CONSTRAINT [UQ_SchemaAccreditamentoGerarchia_PadreFiglio] UNIQUE NONCLUSTERED ([PadreId] ASC, [FiglioId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[SchemaAccreditamentoGerarchiaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Gerarchia tra schemi di accreditamento. Modella la relazione macro-schema (padre) → sotto-schema proprietario (figlio). Pattern Closure Table coerente con NACEGerarchia e SettoreEAGerarchia.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaAccreditamentoGerarchia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SchemaAccreditamentoId del nodo figlio (sotto-schema, es. FSSC 22000, EN 9100, ISO 13485).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'FiglioId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Livello di profondità nella gerarchia. 1 = figlio diretto del macro-schema.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'Profondita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SchemaAccreditamentoId del nodo padre (macro-schema, es. SGQ, FSM, SSI).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaAccreditamentoGerarchia', @level2type = N'COLUMN', @level2name = N'PadreId';


GO

