CREATE TABLE [Certificazione].[ProgrammaRequisitoStorico] (
    [ProgrammaRequisitoId]              INT              NOT NULL,
    [ProgrammaCertificazioneId]         INT              NOT NULL,
    [TipoRequisitoProgrammaId]          INT              NOT NULL,
    [CodiceRequisito]                   NVARCHAR (50)    NOT NULL,
    [Titolo]                            NVARCHAR (255)   NOT NULL,
    [Descrizione]                       NVARCHAR (MAX)   NULL,
    [ClausolaNormativa]                 NVARCHAR (100)   NULL,
    [Obbligatorio]                      BIT              NOT NULL,
    [EvidenzaRichiesta]                 NVARCHAR (MAX)   NULL,
    [CriterioValutazione]               NVARCHAR (MAX)   NULL,
    [ApplicabileIniziale]               BIT              NOT NULL,
    [ApplicabileSorveglianza]           BIT              NOT NULL,
    [ApplicabileRinnovo]                BIT              NOT NULL,
    [ApplicabileEstensione]             BIT              NOT NULL,
    [Ordine]                            SMALLINT         NOT NULL,
    [Attivo]                            BIT              NOT NULL,
    [DataCreazione]                     DATETIME2 (7)    NOT NULL,
    [CreatoDa]                          INT              NULL,
    [DataModifica]                      DATETIME2 (7)    NULL,
    [ModificatoDa]                      INT              NULL,
    [DataCancellazione]                 DATETIME2 (7)    NULL,
    [CancellatoDa]                      INT              NULL,
    [UniqueRowId]                       UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                  DATETIME2 (7)    NOT NULL,
    [ProgrammaCertificazioneVersioneId] INT              NULL
);


GO

CREATE CLUSTERED INDEX [ix_ProgrammaRequisitoStorico]
    ON [Certificazione].[ProgrammaRequisitoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

