CREATE TABLE [Standard].[SettoreEAStorico] (
    [SettoreEAId]        INT              NOT NULL,
    [Codice]             NVARCHAR (10)    NOT NULL,
    [DenominazioneIta]   NVARCHAR (500)   NOT NULL,
    [DenominazioneEng]   NVARCHAR (500)   NULL,
    [CodiceNACE]         NVARCHAR (50)    NULL,
    [FonteStandard]      NVARCHAR (100)   NULL,
    [Attivo]             BIT              NOT NULL,
    [DataCreazione]      DATETIME2 (7)    NOT NULL,
    [CreatoDa]           INT              NULL,
    [DataModifica]       DATETIME2 (7)    NULL,
    [ModificatoDa]       INT              NULL,
    [DataCancellazione]  DATETIME2 (7)    NULL,
    [CancellatoDa]       INT              NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER NOT NULL,
    [StatoSettoreEAId]   INT              NOT NULL,
    [DataSoppressione]   DATE             NULL,
    [DataInizioValidita] DATETIME2 (7)    NOT NULL,
    [DataFineValidita]   DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_SettoreEAStorico]
    ON [Standard].[SettoreEAStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

