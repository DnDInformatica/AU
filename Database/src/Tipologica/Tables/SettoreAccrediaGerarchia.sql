CREATE TABLE [Tipologica].[SettoreAccrediaGerarchia] (
    [SettoreAccrediaGerarchiaId] INT                                                IDENTITY (1, 1) NOT NULL,
    [PadreId]                    INT                                                NOT NULL,
    [FiglioId]                   INT                                                NOT NULL,
    [Profondita]                 INT                                                NOT NULL,
    [DataCreazione]              DATETIME2 (7)                                      CONSTRAINT [DF_SettoreAccrediaGerarchia_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                   INT                                                NULL,
    [DataModifica]               DATETIME2 (7)                                      NULL,
    [ModificatoDa]               INT                                                NULL,
    [DataCancellazione]          DATETIME2 (7)                                      NULL,
    [CancellatoDa]               INT                                                NULL,
    [UniqueRowId]                UNIQUEIDENTIFIER                                   CONSTRAINT [DF_SettoreAccrediaGerarchia_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]         DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]           DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_SettoreAccrediaGerarchia] PRIMARY KEY CLUSTERED ([SettoreAccrediaGerarchiaId] ASC),
    CONSTRAINT [FK_SettoreAccrediaGerarchia_Figlio] FOREIGN KEY ([FiglioId]) REFERENCES [Tipologica].[SettoreAccredia] ([SettoreAccrediaId]),
    CONSTRAINT [FK_SettoreAccrediaGerarchia_Padre] FOREIGN KEY ([PadreId]) REFERENCES [Tipologica].[SettoreAccredia] ([SettoreAccrediaId]),
    CONSTRAINT [UQ_SettoreAccrediaGerarchia_Coppia] UNIQUE NONCLUSTERED ([PadreId] ASC, [FiglioId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Tipologica].[SettoreAccrediaGerarchiaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

