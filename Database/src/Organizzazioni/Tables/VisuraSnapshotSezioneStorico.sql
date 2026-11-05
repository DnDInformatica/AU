CREATE TABLE [Organizzazioni].[VisuraSnapshotSezioneStorico] (
    [VisuraSnapshotSezioneId] INT              NOT NULL,
    [VisuraSnapshotId]        INT              NOT NULL,
    [NumeroSezione]           SMALLINT         NOT NULL,
    [TitoloSezione]           NVARCHAR (200)   NOT NULL,
    [CoperturaModello]        NVARCHAR (20)    NOT NULL,
    [RigheEstratte]           INT              NULL,
    [NoteAnalisi]             NVARCHAR (1000)  NULL,
    [DataCreazione]           DATETIME2 (7)    NOT NULL,
    [CreatoDa]                INT              NULL,
    [DataModifica]            DATETIME2 (7)    NULL,
    [ModificatoDa]            INT              NULL,
    [DataCancellazione]       DATETIME2 (7)    NULL,
    [CancellatoDa]            INT              NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]      DATETIME2 (7)    NOT NULL,
    [DataFineValidita]        DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_VisuraSnapshotSezioneStorico]
    ON [Organizzazioni].[VisuraSnapshotSezioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

