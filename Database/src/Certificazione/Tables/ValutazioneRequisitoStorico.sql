CREATE TABLE [Certificazione].[ValutazioneRequisitoStorico] (
    [ValutazioneRequisitoId]          INT              NOT NULL,
    [CertificazioneId]                INT              NOT NULL,
    [ProgrammaRequisitoId]            INT              NOT NULL,
    [TipoEsitoValutazioneRequisitoId] INT              NOT NULL,
    [WorkflowIstanzaId]               INT              NULL,
    [TaskId]                          INT              NULL,
    [DeliberaId]                      INT              NULL,
    [ProgressivoValutazione]          SMALLINT         NOT NULL,
    [DataValutazione]                 DATETIME2 (7)    NOT NULL,
    [ValutatoDa]                      INT              NULL,
    [CommentoValutazione]             NVARCHAR (MAX)   NULL,
    [MotivazioneNonApplicabilita]     NVARCHAR (MAX)   NULL,
    [RichiedeAzioneCorrettiva]        BIT              NOT NULL,
    [Punteggio]                       DECIMAL (9, 2)   NULL,
    [Peso]                            DECIMAL (9, 2)   NULL,
    [Attivo]                          BIT              NOT NULL,
    [DataCreazione]                   DATETIME2 (7)    NOT NULL,
    [CreatoDa]                        INT              NULL,
    [DataModifica]                    DATETIME2 (7)    NULL,
    [ModificatoDa]                    INT              NULL,
    [DataCancellazione]               DATETIME2 (7)    NULL,
    [CancellatoDa]                    INT              NULL,
    [UniqueRowId]                     UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]              DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ValutazioneRequisitoStorico]
    ON [Certificazione].[ValutazioneRequisitoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

