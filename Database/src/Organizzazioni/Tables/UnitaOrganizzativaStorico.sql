CREATE TABLE [Organizzazioni].[UnitaOrganizzativaStorico] (
    [UnitaOrganizzativaId]             INT              NOT NULL,
    [OrganizzazioneId]                 INT              NOT NULL,
    [TipoUnitaOrganizzativaId]         INT              NOT NULL,
    [Nome]                             NVARCHAR (500)   NOT NULL,
    [NIscrizioneREA]                   NVARCHAR (11)    NULL,
    [Codice]                           NVARCHAR (150)   NULL,
    [Principale]                       BIT              NOT NULL,
    [DataCreazione]                    DATETIME2 (7)    NOT NULL,
    [CreatoDa]                         INT              NULL,
    [DataModifica]                     DATETIME2 (7)    NULL,
    [ModificatoDa]                     INT              NULL,
    [DataCancellazione]                DATETIME2 (7)    NULL,
    [CancellatoDa]                     INT              NULL,
    [UniqueRowId]                      UNIQUEIDENTIFIER NOT NULL,
    [TipoUnitaOrganizzativaAccrediaId] INT              NULL,
    [TipoSedeId]                       INT              NOT NULL,
    [CodiceUnitaOrganizzativa]         NVARCHAR (20)    NULL,
    [DataInizioValidita]               DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                 DATETIME2 (7)    NOT NULL,
    [DataInizioAttivita]               DATE             NULL,
    [DataFineAttivita]                 DATE             NULL,
    [StatoOperativo]                   NVARCHAR (20)    NULL,
    [FonteValidita]                    NVARCHAR (1000)  NULL,
    [DataUltimaVerifica]               DATE             NULL
);


GO

CREATE CLUSTERED INDEX [ix_UnitaOrganizzativaStorico]
    ON [Organizzazioni].[UnitaOrganizzativaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

