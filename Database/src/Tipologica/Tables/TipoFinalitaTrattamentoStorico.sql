CREATE TABLE [Tipologica].[TipoFinalitaTrattamentoStorico] (
    [TipoFinalitaTrattamentoId] INT              NOT NULL,
    [Codice]                    NVARCHAR (30)    NOT NULL,
    [Descrizione]               NVARCHAR (200)   NOT NULL,
    [DescrizioneEstesa]         NVARCHAR (MAX)   NULL,
    [Categoria]                 NVARCHAR (50)    NOT NULL,
    [BaseGiuridicaDefault]      NVARCHAR (50)    NOT NULL,
    [RichiedeConsensoEsplicito] BIT              NOT NULL,
    [DurataConservazioneAnni]   INT              NULL,
    [IsObbligatorio]            BIT              NOT NULL,
    [Ordine]                    INT              NULL,
    [DataCreazione]             DATETIME2 (7)    NOT NULL,
    [CreatoDa]                  INT              NULL,
    [DataModifica]              DATETIME2 (7)    NULL,
    [ModificatoDa]              INT              NULL,
    [DataCancellazione]         DATETIME2 (7)    NULL,
    [CancellatoDa]              INT              NULL,
    [UniqueRowId]               UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]        DATETIME2 (7)    NOT NULL,
    [DataFineValidita]          DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_TipoFinalitaTrattamentoStorico]
    ON [Tipologica].[TipoFinalitaTrattamentoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

