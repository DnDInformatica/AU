CREATE TABLE [Standard].[NormaAccreditamentoStorico] (
    [NormaAccreditamentoId]   INT              NOT NULL,
    [Codice]                  NVARCHAR (100)   NOT NULL,
    [CodiceVersione]          NVARCHAR (20)    NULL,
    [Riferimento]             NVARCHAR (200)   NOT NULL,
    [TitoloIta]               NVARCHAR (1000)  NULL,
    [TitoloEng]               NVARCHAR (1000)  NULL,
    [Attivo]                  BIT              NOT NULL,
    [DataCreazione]           DATETIME2 (7)    NOT NULL,
    [CreatoDa]                INT              NULL,
    [DataModifica]            DATETIME2 (7)    NULL,
    [ModificatoDa]            INT              NULL,
    [DataCancellazione]       DATETIME2 (7)    NULL,
    [CancellatoDa]            INT              NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER NOT NULL,
    [StatoNormaId]            INT              NOT NULL,
    [TipoNorma]               NVARCHAR (30)    NOT NULL,
    [CategoriaFonte]          NVARCHAR (30)    NOT NULL,
    [DataScadenzaTransizione] DATE             NULL,
    [SchemeOwner]             NVARCHAR (200)   NULL,
    [DataInizioValidita]      DATETIME2 (7)    NOT NULL,
    [DataFineValidita]        DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_NormaAccreditamentoStorico]
    ON [Standard].[NormaAccreditamentoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

