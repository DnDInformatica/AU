CREATE TABLE [Certificazione].[CertificazionePRDStorico] (
    [CertificazionePRDId]         INT              NOT NULL,
    [CertificazioneId]            INT              NOT NULL,
    [OrganizzazioneClienteId]     INT              NULL,
    [AmbitoIta]                   NVARCHAR (MAX)   NULL,
    [AmbitoEng]                   NVARCHAR (MAX)   NULL,
    [ScopoCertificato]            NVARCHAR (MAX)   NULL,
    [NomeProdotto]                NVARCHAR (MAX)   NULL,
    [DataUltimoRinnovo]           DATE             NULL,
    [NumeroCertificatoPrecedente] NVARCHAR (100)   NULL,
    [DataCreazione]               DATETIME2 (7)    NOT NULL,
    [CreatoDa]                    INT              NULL,
    [DataModifica]                DATETIME2 (7)    NULL,
    [ModificatoDa]                INT              NULL,
    [DataCancellazione]           DATETIME2 (7)    NULL,
    [CancellatoDa]                INT              NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER NOT NULL,
    [SpecificaTecnica]            NVARCHAR (MAX)   NULL,
    [DataInizioValidita]          DATETIME2 (7)    NOT NULL,
    [DataFineValidita]            DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_CertificazionePRDStorico]
    ON [Certificazione].[CertificazionePRDStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

