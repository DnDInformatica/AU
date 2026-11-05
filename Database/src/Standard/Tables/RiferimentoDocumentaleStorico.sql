CREATE TABLE [Standard].[RiferimentoDocumentaleStorico] (
    [RiferimentoDocumentaleId] INT              NOT NULL,
    [SoggettoFonteId]          INT              NOT NULL,
    [TipoRiferimento]          NVARCHAR (40)    NOT NULL,
    [CodiceDocumento]          NVARCHAR (100)   NOT NULL,
    [Edizione]                 NVARCHAR (50)    NULL,
    [Titolo]                   NVARCHAR (1000)  NULL,
    [Stato]                    NVARCHAR (30)    NOT NULL,
    [DataPubblicazione]        DATE             NULL,
    [DataCessazione]           DATE             NULL,
    [UrlUfficiale]             NVARCHAR (1000)  NULL,
    [RepositoryFonte]          NVARCHAR (100)   NULL,
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

CREATE CLUSTERED INDEX [ix_RiferimentoDocumentaleStorico]
    ON [Standard].[RiferimentoDocumentaleStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

