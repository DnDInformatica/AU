CREATE TABLE [Tipologica].[TipoFormazioneObbligatoriaStorico] (
    [TipoFormazioneObbligatoriaId] INT              NOT NULL,
    [Codice]                       NVARCHAR (30)    NOT NULL,
    [Descrizione]                  NVARCHAR (100)   NOT NULL,
    [DescrizioneEstesa]            NVARCHAR (500)   NULL,
    [Categoria]                    NVARCHAR (30)    NOT NULL,
    [DurataOreMinima]              INT              NULL,
    [ValiditaMesi]                 INT              NULL,
    [RiferimentoNormativo]         NVARCHAR (200)   NULL,
    [ObbligatoriaPerTutti]         BIT              NOT NULL,
    [Ordine]                       INT              NOT NULL,
    [Attivo]                       BIT              NOT NULL,
    [DataCreazione]                DATETIME2 (7)    NOT NULL,
    [CreatoDa]                     INT              NULL,
    [DataModifica]                 DATETIME2 (7)    NULL,
    [ModificatoDa]                 INT              NULL,
    [DataCancellazione]            DATETIME2 (7)    NULL,
    [CancellatoDa]                 INT              NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]           DATETIME2 (7)    NOT NULL,
    [DataFineValidita]             DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_TipoFormazioneObbligatoriaStorico]
    ON [Tipologica].[TipoFormazioneObbligatoriaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

