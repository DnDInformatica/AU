CREATE TABLE [Organizzazioni].[UnitaOrganizzativaFunzioneStorico] (
    [UnitaOrganizzativaFunzioneId] INT              NOT NULL,
    [UnitaOrganizzativaId]         INT              NOT NULL,
    [TipoFunzioneUnitaLocaleId]    INT              NOT NULL,
    [Principale]                   BIT              NOT NULL,
    [Note]                         NVARCHAR (500)   NULL,
    [DataCreazione]                DATETIME2 (7)    NOT NULL,
    [CreatoDa]                     INT              NULL,
    [DataModifica]                 DATETIME2 (7)    NULL,
    [ModificatoDa]                 INT              NULL,
    [DataCancellazione]            DATETIME2 (7)    NULL,
    [CancellatoDa]                 INT              NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]           DATETIME2 (7)    NOT NULL,
    [DataFineValidita]             DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_UnitaOrganizzativaFunzioneStorico]
    ON [Organizzazioni].[UnitaOrganizzativaFunzioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

