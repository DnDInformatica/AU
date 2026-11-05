CREATE TABLE [Accreditamento].[ProvvedimentoRegolatorioStorico] (
    [ProvvedimentoRegolatorioId]    INT              NOT NULL,
    [EventoRegolatorioId]           INT              NOT NULL,
    [TipoProvvedimentoId]           INT              NOT NULL,
    [Codice]                        NVARCHAR (50)    NOT NULL,
    [Titolo]                        NVARCHAR (200)   NOT NULL,
    [Descrizione]                   NVARCHAR (MAX)   NULL,
    [NormativaViolata]              NVARCHAR (200)   NULL,
    [RequisitoViolato]              NVARCHAR (200)   NULL,
    [DataEmissione]                 DATE             NOT NULL,
    [DataScadenza]                  DATE             NULL,
    [DataChiusura]                  DATE             NULL,
    [Stato]                         NVARCHAR (30)    NOT NULL,
    [AzioneCorrettivaRichiesta]     NVARCHAR (MAX)   NULL,
    [AzioneCorrettivaEffettuata]    NVARCHAR (MAX)   NULL,
    [DataVerificaEfficacia]         DATE             NULL,
    [EsitoVerificaEfficacia]        NVARCHAR (30)    NULL,
    [AmbitoAccreditamentoImpattato] NVARCHAR (200)   NULL,
    [ImportoSanzione]               DECIMAL (18, 2)  NULL,
    [Valuta]                        NVARCHAR (3)     NULL,
    [DataCreazione]                 DATETIME2 (7)    NOT NULL,
    [CreatoDa]                      INT              NULL,
    [DataModifica]                  DATETIME2 (7)    NULL,
    [ModificatoDa]                  INT              NULL,
    [DataCancellazione]             DATETIME2 (7)    NULL,
    [CancellatoDa]                  INT              NULL,
    [UniqueRowId]                   UNIQUEIDENTIFIER NOT NULL,
    [PersonaId]                     INT              NULL,
    [DataInizioValidita]            DATETIME2 (7)    NOT NULL,
    [DataFineValidita]              DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ProvvedimentoRegolatorioStorico]
    ON [Accreditamento].[ProvvedimentoRegolatorioStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

