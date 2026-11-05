CREATE TABLE [Standard].[NormaAccreditamentoRelazioneStorico] (
    [NormaAccreditamentoRelazioneId] INT              NOT NULL,
    [PadreNormaId]                   INT              NOT NULL,
    [FiglioNormaId]                  INT              NOT NULL,
    [TipoRelazioneNormaId]           INT              NOT NULL,
    [Profondita]                     INT              NOT NULL,
    [NoteRelazione]                  NVARCHAR (2000)  NULL,
    [DataInizioRelazione]            DATE             NULL,
    [DataFineRelazione]              DATE             NULL,
    [Attivo]                         BIT              NOT NULL,
    [DataCreazione]                  DATETIME2 (7)    NOT NULL,
    [CreatoDa]                       INT              NULL,
    [DataModifica]                   DATETIME2 (7)    NULL,
    [ModificatoDa]                   INT              NULL,
    [DataCancellazione]              DATETIME2 (7)    NULL,
    [CancellatoDa]                   INT              NULL,
    [UniqueRowId]                    UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]             DATETIME2 (7)    NOT NULL,
    [DataFineValidita]               DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_NormaAccreditamentoRelazioneStorico]
    ON [Standard].[NormaAccreditamentoRelazioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

