CREATE TABLE [Tipologica].[TipoOrganizzazioneStorico] (
    [TipoOrganizzazioneId]       INT              NOT NULL,
    [Codice]                     NVARCHAR (50)    NOT NULL,
    [Descrizione]                NVARCHAR (250)   NOT NULL,
    [CodiceSchemaAccreditamento] NVARCHAR (20)    NULL,
    [NormaRiferimento]           NVARCHAR (100)   NULL,
    [Attivo]                     BIT              NOT NULL,
    [DataCreazione]              DATETIME2 (7)    NOT NULL,
    [CreatoDa]                   INT              NULL,
    [DataModifica]               DATETIME2 (7)    NULL,
    [ModificatoDa]               INT              NULL,
    [DataCancellazione]          DATETIME2 (7)    NULL,
    [CancellatoDa]               INT              NULL,
    [UniqueRowId]                UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]         DATETIME2 (7)    NOT NULL,
    [DataFineValidita]           DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_TipoOrganizzazioneStorico]
    ON [Tipologica].[TipoOrganizzazioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

