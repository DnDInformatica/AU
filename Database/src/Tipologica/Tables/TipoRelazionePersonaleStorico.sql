CREATE TABLE [Tipologica].[TipoRelazionePersonaleStorico] (
    [TipoRelazionePersonaleId] INT              NOT NULL,
    [Codice]                   NVARCHAR (30)    NOT NULL,
    [Descrizione]              NVARCHAR (200)   NOT NULL,
    [Simmetrica]               BIT              NOT NULL,
    [TipoRelazioneInversaId]   INT              NULL,
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

CREATE CLUSTERED INDEX [ix_TipoRelazionePersonaleStorico]
    ON [Tipologica].[TipoRelazionePersonaleStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

