CREATE TABLE [Platform].[DocumentoStorico] (
    [DocumentId]         UNIQUEIDENTIFIER NOT NULL,
    [FileName]           NVARCHAR (500)   NOT NULL,
    [ContentType]        NVARCHAR (200)   NOT NULL,
    [Length]             BIGINT           NOT NULL,
    [StorageProvider]    NVARCHAR (50)    NOT NULL,
    [StorageKey]         NVARCHAR (1000)  NOT NULL,
    [Checksum]           NVARCHAR (100)   NULL,
    [VisibilityScope]    NVARCHAR (50)    NOT NULL,
    [Module]             NVARCHAR (100)   NOT NULL,
    [OwnerType]          NVARCHAR (100)   NOT NULL,
    [OwnerId]            NVARCHAR (200)   NOT NULL,
    [CreatedAtUtc]       DATETIME2 (7)    NOT NULL,
    [StoredAtUtc]        DATETIME2 (7)    NULL,
    [CartellaId]         UNIQUEIDENTIFIER NULL,
    [UpdatedAtUtc]       DATETIME2 (7)    NOT NULL,
    [VersionNumber]      INT              NOT NULL,
    [CreatedBy]          INT              NULL,
    [UpdatedBy]          INT              NULL,
    [DeletedAtUtc]       DATETIME2 (7)    NULL,
    [DeletedBy]          INT              NULL,
    [DataInizioValidita] DATETIME2 (7)    NOT NULL,
    [DataFineValidita]   DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [CIX_DocumentoStorico_Periodo]
    ON [Platform].[DocumentoStorico]([DataInizioValidita] ASC, [DataFineValidita] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_DocumentoStorico_Documento]
    ON [Platform].[DocumentoStorico]([DocumentId] ASC, [DataFineValidita] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Storico di sistema di Platform.Documento: le versioni precedenti dei file, con la StorageKey di ciascuna, e lo stato delle righe prima di ogni modifica o cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'DocumentoStorico';


GO

