CREATE TABLE [Certificazione].[CertificazioneComunicazioneStorico] (
    [CertificazioneComunicazioneId] INT              NOT NULL,
    [CertificazioneId]              INT              NOT NULL,
    [StatoComunicazioneANACId]      INT              NULL,
    [DataInvio]                     DATETIME2 (7)    NULL,
    [DataAggiornamentoStato]        DATETIME2 (7)    NULL,
    [Payload]                       NVARCHAR (MAX)   NULL,
    [PayloadRisposta]               NVARCHAR (MAX)   NULL,
    [RiferimentoEsterno]            NVARCHAR (200)   NULL,
    [IdCertificatoEsterno]          BIGINT           NULL,
    [NotaPecInviata]                BIT              NOT NULL,
    [DataPecInviata]                DATETIME2 (7)    NULL,
    [ErroreInvio]                   NVARCHAR (MAX)   NULL,
    [DataCreazione]                 DATETIME2 (7)    NOT NULL,
    [CreatoDa]                      INT              NULL,
    [DataModifica]                  DATETIME2 (7)    NULL,
    [ModificatoDa]                  INT              NULL,
    [DataCancellazione]             DATETIME2 (7)    NULL,
    [CancellatoDa]                  INT              NULL,
    [UniqueRowId]                   UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]            DATETIME2 (7)    NOT NULL,
    [DataFineValidita]              DATETIME2 (7)    NOT NULL,
    [TipoCanaleComunicazioneId]     INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_CertificazioneComunicazioneStorico]
    ON [Certificazione].[CertificazioneComunicazioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

