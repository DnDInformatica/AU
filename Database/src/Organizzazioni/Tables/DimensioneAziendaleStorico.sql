CREATE TABLE [Organizzazioni].[DimensioneAziendaleStorico] (
    [DimensioneAziendaleId] INT              NOT NULL,
    [OrganizzazioneId]      INT              NOT NULL,
    [DataRiferimento]       DATE             NOT NULL,
    [NumeroAddetti]         INT              NULL,
    [FasciaDimensionale]    NVARCHAR (20)    NULL,
    [FonteDato]             NVARCHAR (100)   NULL,
    [DocumentoId]           INT              NULL,
    [Note]                  NVARCHAR (500)   NULL,
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

CREATE CLUSTERED INDEX [ix_DimensioneAziendaleStorico]
    ON [Organizzazioni].[DimensioneAziendaleStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

