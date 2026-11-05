CREATE TABLE [Standard].[StatoSettoreEA] (
    [StatoSettoreEAId]   INT                                                IDENTITY (1, 1) NOT NULL,
    [Codice]             NVARCHAR (40)                                      NOT NULL,
    [Descrizione]        NVARCHAR (400)                                     NOT NULL,
    [Attivo]             BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]      DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]           INT                                                NULL,
    [DataModifica]       DATETIME2 (7)                                      NULL,
    [ModificatoDa]       INT                                                NULL,
    [DataCancellazione]  DATETIME2 (7)                                      NULL,
    [CancellatoDa]       INT                                                NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_StatoSettoreEA] PRIMARY KEY CLUSTERED ([StatoSettoreEAId] ASC),
    CONSTRAINT [UQ_StatoSettoreEA_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[StatoSettoreEAStorico], DATA_CONSISTENCY_CHECK=ON));


GO

