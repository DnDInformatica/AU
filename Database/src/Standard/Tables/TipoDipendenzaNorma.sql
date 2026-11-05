CREATE TABLE [Standard].[TipoDipendenzaNorma] (
    [TipoDipendenzaNormaId] INT                                                IDENTITY (1, 1) NOT NULL,
    [Codice]                NVARCHAR (50)                                      NOT NULL,
    [Descrizione]           NVARCHAR (300)                                     NOT NULL,
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
    CONSTRAINT [PK_TipoDipendenzaNorma] PRIMARY KEY CLUSTERED ([TipoDipendenzaNormaId] ASC),
    CONSTRAINT [CK_TipoDipendenzaNorma_Codice] CHECK (len(ltrim(rtrim([Codice])))>(0)),
    CONSTRAINT [CK_TipoDipendenzaNorma_Descrizione] CHECK (len(ltrim(rtrim([Descrizione])))>(0)),
    CONSTRAINT [UQ_TipoDipendenzaNorma_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[TipoDipendenzaNormaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

