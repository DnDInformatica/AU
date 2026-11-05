CREATE TABLE [Certificazione].[AzioneCorrettivaStorico] (
    [AzioneCorrettivaId]           INT              NOT NULL,
    [NonConformitaId]              INT              NOT NULL,
    [StatoAzioneCorrettivaId]      INT              NOT NULL,
    [CodiceAzioneCorrettiva]       NVARCHAR (50)    NOT NULL,
    [Descrizione]                  NVARCHAR (MAX)   NOT NULL,
    [ResponsabileAzione]           NVARCHAR (255)   NULL,
    [DataProposta]                 DATE             NULL,
    [DataScadenza]                 DATE             NULL,
    [DataCompletamento]            DATE             NULL,
    [DataVerificaEfficacia]        DATE             NULL,
    [VerificataDa]                 INT              NULL,
    [Attivo]                       BIT              NOT NULL,
    [DataCreazione]                DATETIME2 (7)    NOT NULL,
    [CreatoDa]                     INT              NULL,
    [DataModifica]                 DATETIME2 (7)    NULL,
    [ModificatoDa]                 INT              NULL,
    [DataCancellazione]            DATETIME2 (7)    NULL,
    [CancellatoDa]                 INT              NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER NOT NULL,
    [TipoEsitoVerificaEfficaciaId] INT              NULL,
    [ResponsabilePersonaId]        INT              NULL,
    [ResponsabileOrganizzazioneId] INT              NULL,
    [NoteVerificaEfficacia]        NVARCHAR (MAX)   NULL,
    [DataAccettazione]             DATE             NULL,
    [DataInizioValidita]           DATETIME2 (7)    NOT NULL,
    [DataFineValidita]             DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_AzioneCorrettivaStorico]
    ON [Certificazione].[AzioneCorrettivaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

