CREATE TABLE [Certificazione].[CertificazioneStorico] (
    [CertificazioneId]                  INT              NOT NULL,
    [NumeroCertificato]                 NVARCHAR (100)   NOT NULL,
    [OrganizzazioneODCId]               INT              NOT NULL,
    [NormaAccreditamentoId]             INT              NOT NULL,
    [TipoCertificazioneId]              INT              NOT NULL,
    [StatoCertificazioneId]             INT              NOT NULL,
    [DataEmissione]                     DATE             NOT NULL,
    [DataScadenza]                      DATE             NULL,
    [DataRevoca]                        DATE             NULL,
    [MotivoRevoca]                      NVARCHAR (500)   NULL,
    [Privato]                           BIT              NOT NULL,
    [DataCreazione]                     DATETIME2 (7)    NOT NULL,
    [CreatoDa]                          INT              NULL,
    [DataModifica]                      DATETIME2 (7)    NULL,
    [ModificatoDa]                      INT              NULL,
    [DataCancellazione]                 DATETIME2 (7)    NULL,
    [CancellatoDa]                      INT              NULL,
    [UniqueRowId]                       UNIQUEIDENTIFIER NOT NULL,
    [DataPrimoRilascio]                 DATE             NULL,
    [DataInizioValidita]                DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                  DATETIME2 (7)    NOT NULL,
    [PraticaAccreditamentoId]           INT              NULL,
    [NormaEdizioneCertificazioneId]     INT              NULL,
    [ProgrammaCertificazioneId]         INT              NULL,
    [ProgrammaCertificazioneVersioneId] INT              NULL,
    [ChiaveBusinessHash]                BINARY (32)      NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_CertificazioneStorico]
    ON [Certificazione].[CertificazioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

