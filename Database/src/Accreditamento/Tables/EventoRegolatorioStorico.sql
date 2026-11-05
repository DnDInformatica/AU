CREATE TABLE [Accreditamento].[EventoRegolatorioStorico] (
    [EventoRegolatorioId]     INT              NOT NULL,
    [OrganizzazioneId]        INT              NOT NULL,
    [UnitaOrganizzativaId]    INT              NULL,
    [EnteAccreditamentoId]    INT              NULL,
    [TipoEventoRegolatorioId] INT              NOT NULL,
    [Codice]                  NVARCHAR (50)    NOT NULL,
    [Titolo]                  NVARCHAR (200)   NOT NULL,
    [Descrizione]             NVARCHAR (MAX)   NULL,
    [DataEvento]              DATE             NOT NULL,
    [DataNotifica]            DATE             NULL,
    [DataScadenzaRisposta]    DATE             NULL,
    [Esito]                   NVARCHAR (30)    NULL,
    [NoteEsito]               NVARCHAR (MAX)   NULL,
    [DataChiusura]            DATE             NULL,
    [ProtocolloEsterno]       NVARCHAR (50)    NULL,
    [RiferimentoNormativo]    NVARCHAR (200)   NULL,
    [NomeIspettore]           NVARCHAR (200)   NULL,
    [EnteIspettore]           NVARCHAR (100)   NULL,
    [DataCreazione]           DATETIME2 (7)    NOT NULL,
    [CreatoDa]                INT              NULL,
    [DataModifica]            DATETIME2 (7)    NULL,
    [ModificatoDa]            INT              NULL,
    [DataCancellazione]       DATETIME2 (7)    NULL,
    [CancellatoDa]            INT              NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER NOT NULL,
    [PersonaId]               INT              NULL,
    [DataInizioValidita]      DATETIME2 (7)    NOT NULL,
    [DataFineValidita]        DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_EventoRegolatorioStorico]
    ON [Accreditamento].[EventoRegolatorioStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

