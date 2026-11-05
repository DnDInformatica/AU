CREATE TABLE [Organizzazioni].[OrganizzazioneTipoOrganizzazioneStorico] (
    [OrganizzazioneTipoId] INT              NOT NULL,
    [OrganizzazioneId]     INT              NOT NULL,
    [TipoOrganizzazioneId] INT              NOT NULL,
    [DataAssegnazione]     DATE             NOT NULL,
    [DataRevoca]           DATE             NULL,
    [MotivoRevoca]         NVARCHAR (500)   NULL,
    [Principale]           BIT              NOT NULL,
    [Note]                 NVARCHAR (1000)  NULL,
    [DataCreazione]        DATETIME2 (7)    NOT NULL,
    [CreatoDa]             INT              NULL,
    [DataModifica]         DATETIME2 (7)    NULL,
    [ModificatoDa]         INT              NULL,
    [DataCancellazione]    DATETIME2 (7)    NULL,
    [CancellatoDa]         INT              NULL,
    [UniqueRowId]          UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]   DATETIME2 (7)    NOT NULL,
    [DataFineValidita]     DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_OrganizzazioneTipoOrganizzazioneStorico]
    ON [Organizzazioni].[OrganizzazioneTipoOrganizzazioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

