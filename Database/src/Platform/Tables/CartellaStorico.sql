CREATE TABLE [Platform].[CartellaStorico] (
    [CartellaId]         UNIQUEIDENTIFIER NOT NULL,
    [OdcId]              INT              NOT NULL,
    [Nome]               NVARCHAR (200)   NOT NULL,
    [ParentId]           UNIQUEIDENTIFIER NULL,
    [CreatedAtUtc]       DATETIME2 (7)    NOT NULL,
    [UpdatedAtUtc]       DATETIME2 (7)    NOT NULL,
    [DeletedAtUtc]       DATETIME2 (7)    NULL,
    [CreatedBy]          INT              NULL,
    [UpdatedBy]          INT              NULL,
    [DeletedBy]          INT              NULL,
    [DataInizioValidita] DATETIME2 (7)    NOT NULL,
    [DataFineValidita]   DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [CIX_CartellaStorico_Periodo]
    ON [Platform].[CartellaStorico]([DataInizioValidita] ASC, [DataFineValidita] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Storico di sistema di Platform.Cartella: stato delle cartelle prima di ogni ridenominazione, spostamento o cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'CartellaStorico';


GO

