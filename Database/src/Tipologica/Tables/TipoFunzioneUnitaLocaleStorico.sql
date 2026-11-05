CREATE TABLE [Tipologica].[TipoFunzioneUnitaLocaleStorico] (
    [TipoFunzioneUnitaLocaleId] INT              NOT NULL,
    [Codice]                    NVARCHAR (20)    NOT NULL,
    [Descrizione]               NVARCHAR (150)   NOT NULL,
    [Ordine]                    INT              NULL,
    [DataCreazione]             DATETIME2 (7)    NOT NULL,
    [CreatoDa]                  INT              NULL,
    [DataModifica]              DATETIME2 (7)    NULL,
    [ModificatoDa]              INT              NULL,
    [DataCancellazione]         DATETIME2 (7)    NULL,
    [CancellatoDa]              INT              NULL,
    [UniqueRowId]               UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]        DATETIME2 (7)    NOT NULL,
    [DataFineValidita]          DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_TipoFunzioneUnitaLocaleStorico]
    ON [Tipologica].[TipoFunzioneUnitaLocaleStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

