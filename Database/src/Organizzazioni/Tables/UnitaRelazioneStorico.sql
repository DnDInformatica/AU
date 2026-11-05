CREATE TABLE [Organizzazioni].[UnitaRelazioneStorico] (
    [UnitaRelazioneId]    INT              NOT NULL,
    [UnitaPadreId]        INT              NOT NULL,
    [UnitaFigliaId]       INT              NOT NULL,
    [TipoRelazioneId]     INT              NOT NULL,
    [DataCreazione]       DATETIME2 (7)    NOT NULL,
    [CreatoDa]            INT              NULL,
    [DataModifica]        DATETIME2 (7)    NULL,
    [ModificatoDa]        INT              NULL,
    [DataCancellazione]   DATETIME2 (7)    NULL,
    [CancellatoDa]        INT              NULL,
    [UniqueRowId]         UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]  DATETIME2 (7)    NOT NULL,
    [DataFineValidita]    DATETIME2 (7)    NOT NULL,
    [DataInizioRelazione] DATE             NULL,
    [DataFineRelazione]   DATE             NULL,
    [FonteValidita]       NVARCHAR (1000)  NULL,
    [DataUltimaVerifica]  DATE             NULL
);


GO

CREATE CLUSTERED INDEX [ix_UnitaRelazioneStorico]
    ON [Organizzazioni].[UnitaRelazioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

