CREATE TABLE [Persone].[PersonaTitoloStudioStorico] (
    [PersonaTitoloStudioId] INT              NOT NULL,
    [PersonaId]             INT              NOT NULL,
    [TipoTitoloStudioId]    INT              NOT NULL,
    [Istituzione]           NVARCHAR (200)   NULL,
    [Corso]                 NVARCHAR (200)   NULL,
    [DataConseguimento]     DATE             NULL,
    [Voto]                  NVARCHAR (30)    NULL,
    [Lode]                  BIT              NOT NULL,
    [Paese]                 NVARCHAR (100)   NULL,
    [Note]                  NVARCHAR (300)   NULL,
    [Principale]            BIT              NOT NULL,
    [DataCreazione]         DATETIME2 (7)    NOT NULL,
    [CreatoDa]              INT              NULL,
    [DataModifica]          DATETIME2 (7)    NULL,
    [ModificatoDa]          INT              NULL,
    [DataCancellazione]     DATETIME2 (7)    NULL,
    [CancellatoDa]          INT              NULL,
    [UniqueRowId]           UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]    DATETIME2 (7)    NOT NULL,
    [DataFineValidita]      DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_PersonaTitoloStudioStorico]
    ON [Persone].[PersonaTitoloStudioStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

