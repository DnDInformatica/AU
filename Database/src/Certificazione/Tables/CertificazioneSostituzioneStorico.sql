CREATE TABLE [Certificazione].[CertificazioneSostituzioneStorico] (
    [CertificazioneSostituzioneId] INT              NOT NULL,
    [CertificazioneId]             INT              NOT NULL,
    [CertificazioneSostituitaId]   INT              NULL,
    [NumeroCertificatoPrecedente]  NVARCHAR (200)   NOT NULL,
    [TipoFonteLegameId]            INT              NOT NULL,
    [DataEfficacia]                DATE             NULL,
    [Note]                         NVARCHAR (1000)  NULL,
    [DataCreazione]                DATETIME2 (7)    NOT NULL,
    [CreatoDa]                     INT              NULL,
    [DataModifica]                 DATETIME2 (7)    NULL,
    [ModificatoDa]                 INT              NULL,
    [DataCancellazione]            DATETIME2 (7)    NULL,
    [CancellatoDa]                 INT              NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]           DATETIME2 (7)    NOT NULL,
    [DataFineValidita]             DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_CertificazioneSostituzioneStorico]
    ON [Certificazione].[CertificazioneSostituzioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

