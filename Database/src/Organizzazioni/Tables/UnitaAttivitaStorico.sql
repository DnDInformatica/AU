CREATE TABLE [Organizzazioni].[UnitaAttivitaStorico] (
    [UnitaAttivitaId]      INT              NOT NULL,
    [UnitaOrganizzativaId] INT              NOT NULL,
    [CodiceATECORI]        NVARCHAR (20)    NOT NULL,
    [DescrizioneAttivita]  NVARCHAR (500)   NULL,
    [Importanza]           NVARCHAR (50)    NOT NULL,
    [DataCreazione]        DATETIME2 (7)    NOT NULL,
    [CreatoDa]             INT              NULL,
    [DataModifica]         DATETIME2 (7)    NULL,
    [ModificatoDa]         INT              NULL,
    [DataCancellazione]    DATETIME2 (7)    NULL,
    [CancellatoDa]         INT              NULL,
    [UniqueRowId]          UNIQUEIDENTIFIER NOT NULL,
    [DataInizioAttivita]   DATE             NULL,
    [DataFineAttivita]     DATE             NULL,
    [FonteDato]            NVARCHAR (50)    NULL,
    [Note]                 NVARCHAR (1000)  NULL,
    [DataInizioValidita]   DATETIME2 (7)    NOT NULL,
    [DataFineValidita]     DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_UnitaAttivitaStorico]
    ON [Organizzazioni].[UnitaAttivitaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

