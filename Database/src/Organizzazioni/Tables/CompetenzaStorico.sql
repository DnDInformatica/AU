CREATE TABLE [Organizzazioni].[CompetenzaStorico] (
    [CompetenzaId]          INT              NOT NULL,
    [CodiceCompetenza]      NVARCHAR (50)    NOT NULL,
    [DescrizioneCompetenza] NVARCHAR (MAX)   NULL,
    [Principale]            BIT              NOT NULL,
    [Attivo]                BIT              NOT NULL,
    [Cancellato]            BIT              NOT NULL,
    [Verificato]            BIT              NOT NULL,
    [DataCreazione]         DATETIME2 (7)    NOT NULL,
    [CreatoDa]              INT              NOT NULL,
    [DataModifica]          DATETIME2 (7)    NULL,
    [ModificatoDa]          INT              NULL,
    [DataCancellazione]     DATETIME2 (7)    NULL,
    [CancellatoDa]          INT              NULL,
    [UniqueRowId]           UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]    DATETIME2 (7)    NOT NULL,
    [DataFineValidita]      DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_CompetenzaStorico]
    ON [Organizzazioni].[CompetenzaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

