CREATE TABLE [Eventi].[EventoStorico] (
    [EventoId]               INT              NOT NULL,
    [TipoEventoId]           INT              NOT NULL,
    [Titolo]                 NVARCHAR (500)   NOT NULL,
    [Descrizione]            NVARCHAR (MAX)   NULL,
    [DipartimentoAccrediaId] INT              NULL,
    [OrganizzazioneId]       INT              NULL,
    [DataInizio]             DATETIME2 (7)    NOT NULL,
    [DataFine]               DATETIME2 (7)    NULL,
    [Luogo]                  NVARCHAR (500)   NULL,
    [ResponsabilePersonaId]  INT              NULL,
    [DataCreazione]          DATETIME2 (7)    NOT NULL,
    [CreatoDa]               INT              NULL,
    [DataModifica]           DATETIME2 (7)    NULL,
    [ModificatoDa]           INT              NULL,
    [DataCancellazione]      DATETIME2 (7)    NULL,
    [CancellatoDa]           INT              NULL,
    [UniqueRowId]            UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]     DATETIME2 (7)    NOT NULL,
    [DataFineValidita]       DATETIME2 (7)    NOT NULL,
    [OrganoCollegialeId]     INT              NULL,
    [StatoEventoId]          INT              NOT NULL,
    [VisibilitaEventoId]     INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_EventoStorico]
    ON [Eventi].[EventoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

