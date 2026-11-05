CREATE TABLE [Certificazione].[CertificazioneSospensioneStorico] (
    [CertificazioneSospensioneId] INT              NOT NULL,
    [CertificazioneId]            INT              NOT NULL,
    [CertificazioneSettoreEAId]   INT              NULL,
    [CertificazioneProvaId]       INT              NULL,
    [TipoSospensioneId]           INT              NOT NULL,
    [TipoDispositoreId]           INT              NOT NULL,
    [DataInizio]                  DATE             NOT NULL,
    [DataFine]                    DATE             NULL,
    [MotivoSospensione]           NVARCHAR (500)   NULL,
    [DescrizioneProvvedimento]    NVARCHAR (1000)  NULL,
    [RiferimentoNormativo]        NVARCHAR (200)   NULL,
    [NumeroDelibera]              NVARCHAR (100)   NULL,
    [DataCreazione]               DATETIME2 (7)    NOT NULL,
    [CreatoDa]                    INT              NULL,
    [DataModifica]                DATETIME2 (7)    NULL,
    [ModificatoDa]                INT              NULL,
    [DataCancellazione]           DATETIME2 (7)    NULL,
    [CancellatoDa]                INT              NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]          DATETIME2 (7)    NOT NULL,
    [DataFineValidita]            DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_CertificazioneSospensioneStorico]
    ON [Certificazione].[CertificazioneSospensioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

