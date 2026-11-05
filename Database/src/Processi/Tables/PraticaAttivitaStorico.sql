CREATE TABLE [Processi].[PraticaAttivitaStorico] (
    [PraticaAttivitaId]      INT              NOT NULL,
    [PraticaId]              INT              NOT NULL,
    [TaskId]                 INT              NULL,
    [Titolo]                 NVARCHAR (1000)  NOT NULL,
    [Descrizione]            NVARCHAR (MAX)   NULL,
    [AssegnatoAPersonaId]    INT              NULL,
    [TipoRuoloAccrediaId]    INT              NULL,
    [DataScadenza]           DATETIME2 (7)    NULL,
    [DataCompletamento]      DATETIME2 (7)    NULL,
    [DataCreazione]          DATETIME2 (7)    NOT NULL,
    [CreatoDa]               INT              NULL,
    [DataModifica]           DATETIME2 (7)    NULL,
    [ModificatoDa]           INT              NULL,
    [DataCancellazione]      DATETIME2 (7)    NULL,
    [CancellatoDa]           INT              NULL,
    [UniqueRowId]            UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]     DATETIME2 (7)    NOT NULL,
    [DataFineValidita]       DATETIME2 (7)    NOT NULL,
    [EsitoLavorazioneId]     INT              NULL,
    [StatoAttivitaPraticaId] INT              NOT NULL,
    [TipoAttivitaPraticaId]  INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_PraticaAttivitaStorico]
    ON [Processi].[PraticaAttivitaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

