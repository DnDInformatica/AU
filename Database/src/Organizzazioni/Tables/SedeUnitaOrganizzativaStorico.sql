CREATE TABLE [Organizzazioni].[SedeUnitaOrganizzativaStorico] (
    [SedeUnitaOrganizzativaId] INT              NOT NULL,
    [SedeId]                   INT              NOT NULL,
    [UnitaOrganizzativaId]     INT              NOT NULL,
    [RuoloOperativo]           NVARCHAR (100)   NULL,
    [DescrizioneRuolo]         NVARCHAR (500)   NULL,
    [DataInizio]               DATE             NOT NULL,
    [DataFine]                 DATE             NULL,
    [Principale]               BIT              NOT NULL,
    [IsTemporanea]             BIT              NOT NULL,
    [PercentualeAttivita]      DECIMAL (5, 2)   NULL,
    [Note]                     NVARCHAR (MAX)   NULL,
    [DataCreazione]            DATETIME2 (7)    NOT NULL,
    [CreatoDa]                 INT              NULL,
    [DataModifica]             DATETIME2 (7)    NULL,
    [ModificatoDa]             INT              NULL,
    [DataCancellazione]        DATETIME2 (7)    NULL,
    [CancellatoDa]             INT              NULL,
    [UniqueRowId]              UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]       DATETIME2 (7)    NOT NULL,
    [DataFineValidita]         DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_SedeUnitaOrganizzativaStorico]
    ON [Organizzazioni].[SedeUnitaOrganizzativaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

