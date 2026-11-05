CREATE TABLE [Certificazione].[DecisioneCertificazioneStorico] (
    [DecisioneCertificazioneId]           INT              NOT NULL,
    [CertificazioneId]                    INT              NOT NULL,
    [DeliberaId]                          INT              NULL,
    [WorkflowIstanzaId]                   INT              NULL,
    [TipoEsitoDecisioneCertificazioneId]  INT              NOT NULL,
    [DataDecisione]                       DATETIME2 (7)    NOT NULL,
    [DecisaDaPersonaId]                   INT              NULL,
    [DecisaDaOrganizzazioneId]            INT              NULL,
    [IndipendenzaVerificata]              BIT              NOT NULL,
    [DecisionMakerCoinvoltoInValutazione] BIT              NOT NULL,
    [Motivazione]                         NVARCHAR (MAX)   NULL,
    [Condizioni]                          NVARCHAR (MAX)   NULL,
    [Note]                                NVARCHAR (MAX)   NULL,
    [DataEfficacia]                       DATE             NULL,
    [DataScadenzaDecisione]               DATE             NULL,
    [AggiornaStatoCertificazione]         BIT              NOT NULL,
    [StatoCertificazioneDestinazioneId]   INT              NULL,
    [Attivo]                              BIT              NOT NULL,
    [DataCreazione]                       DATETIME2 (7)    NOT NULL,
    [CreatoDa]                            INT              NULL,
    [DataModifica]                        DATETIME2 (7)    NULL,
    [ModificatoDa]                        INT              NULL,
    [DataCancellazione]                   DATETIME2 (7)    NULL,
    [CancellatoDa]                        INT              NULL,
    [UniqueRowId]                         UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                  DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                    DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_DecisioneCertificazioneStorico]
    ON [Certificazione].[DecisioneCertificazioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

