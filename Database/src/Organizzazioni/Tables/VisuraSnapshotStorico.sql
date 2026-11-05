CREATE TABLE [Organizzazioni].[VisuraSnapshotStorico] (
    [VisuraSnapshotId]      INT              NOT NULL,
    [OrganizzazioneId]      INT              NOT NULL,
    [DocumentoId]           INT              NOT NULL,
    [CameraCommercio]       NVARCHAR (120)   NULL,
    [NumeroDocumentoVisura] NVARCHAR (120)   NULL,
    [DataEstrazioneVisura]  DATETIME2 (0)    NOT NULL,
    [TipoVisura]            NVARCHAR (30)    NOT NULL,
    [HashContenuto]         NVARCHAR (128)   NULL,
    [EsitoParsing]          NVARCHAR (20)    NOT NULL,
    [VersioneParser]        NVARCHAR (40)    NULL,
    [Note]                  NVARCHAR (1000)  NULL,
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

CREATE CLUSTERED INDEX [ix_VisuraSnapshotStorico]
    ON [Organizzazioni].[VisuraSnapshotStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

