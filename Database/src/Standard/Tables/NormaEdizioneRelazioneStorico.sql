CREATE TABLE [Standard].[NormaEdizioneRelazioneStorico] (
    [NormaEdizioneRelazioneId] INT              NOT NULL,
    [PadreEdizioneId]          INT              NOT NULL,
    [FiglioEdizioneId]         INT              NOT NULL,
    [Profondita]               INT              NOT NULL,
    [TipoRelazioneNormaId]     INT              NOT NULL,
    [NoteRelazione]            NVARCHAR (1000)  NULL,
    [DataInizioRelazione]      DATE             NULL,
    [DataFineRelazione]        DATE             NULL,
    [Attivo]                   BIT              NOT NULL,
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

CREATE CLUSTERED INDEX [ix_NormaEdizioneRelazioneStorico]
    ON [Standard].[NormaEdizioneRelazioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

