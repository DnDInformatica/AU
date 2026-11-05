CREATE TABLE [Tipologica].[TipoTitoloStudioStorico] (
    [TipoTitoloStudioId]     INT              NOT NULL,
    [Descrizione]            NVARCHAR (250)   NOT NULL,
    [Codice]                 NVARCHAR (20)    NOT NULL,
    [LivelloTitoloStudioId]  INT              NOT NULL,
    [TipoSistemaFormativoId] INT              NOT NULL,
    [HaValoreLegale]         BIT              NOT NULL,
    [RichiedeTitoloPrevio]   BIT              NOT NULL,
    [RiferimentoNormativo]   NVARCHAR (300)   NULL,
    [Ordine]                 INT              NULL,
    [DataCreazione]          DATETIME2 (7)    NOT NULL,
    [CreatoDa]               INT              NULL,
    [DataModifica]           DATETIME2 (7)    NULL,
    [ModificatoDa]           INT              NULL,
    [DataCancellazione]      DATETIME2 (7)    NULL,
    [CancellatoDa]           INT              NULL,
    [UniqueRowId]            UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]     DATETIME2 (7)    NOT NULL,
    [DataFineValidita]       DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_TipoTitoloStudioStorico]
    ON [Tipologica].[TipoTitoloStudioStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

