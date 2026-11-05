CREATE TABLE [Tipologica].[TipoOrganizzazioneSedeStorico] (
    [TipoOrganizzazioneSedeId] TINYINT          NOT NULL,
    [Codice]                   NVARCHAR (20)    NOT NULL,
    [Descrizione]              NVARCHAR (200)   NOT NULL,
    [Attivo]                   BIT              NOT NULL,
    [rowguid]                  UNIQUEIDENTIFIER NOT NULL,
    [DataCreazione]            DATETIME2 (7)    NOT NULL,
    [CreatoDa]                 INT              NULL,
    [DataModifica]             DATETIME2 (7)    NULL,
    [ModificatoDa]             INT              NULL,
    [DataCancellazione]        DATETIME2 (7)    NULL,
    [CancellatoDa]             INT              NULL,
    [DataInizioValidita]       DATETIME2 (7)    NOT NULL,
    [DataFineValidita]         DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_TipoOrganizzazioneSedeStorico]
    ON [Tipologica].[TipoOrganizzazioneSedeStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

