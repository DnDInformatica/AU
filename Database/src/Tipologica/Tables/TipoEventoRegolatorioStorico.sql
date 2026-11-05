CREATE TABLE [Tipologica].[TipoEventoRegolatorioStorico] (
    [TipoEventoRegolatorioId] INT              NOT NULL,
    [Codice]                  NVARCHAR (30)    NOT NULL,
    [Descrizione]             NVARCHAR (200)   NOT NULL,
    [Categoria]               NVARCHAR (30)    NOT NULL,
    [EnteCompetente]          NVARCHAR (50)    NULL,
    [RichiedeFollowUp]        BIT              NOT NULL,
    [GiorniMaxFollowUp]       INT              NULL,
    [GravitaDefault]          NVARCHAR (20)    NULL,
    [Ordine]                  INT              NULL,
    [DataCreazione]           DATETIME2 (7)    NOT NULL,
    [CreatoDa]                INT              NULL,
    [DataModifica]            DATETIME2 (7)    NULL,
    [ModificatoDa]            INT              NULL,
    [DataCancellazione]       DATETIME2 (7)    NULL,
    [CancellatoDa]            INT              NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]      DATETIME2 (7)    NOT NULL,
    [DataFineValidita]        DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_TipoEventoRegolatorioStorico]
    ON [Tipologica].[TipoEventoRegolatorioStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

