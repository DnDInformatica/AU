CREATE TABLE [Certificazione].[CertificazioneProvaStorico] (
    [CertificazioneProvaId]     INT              NOT NULL,
    [CertificazioneSettoreEAId] INT              NOT NULL,
    [CodiceProva]               NVARCHAR (50)    NULL,
    [DescrizioneProva]          NVARCHAR (500)   NOT NULL,
    [MetodoDiProva]             NVARCHAR (200)   NULL,
    [MatriceProva]              NVARCHAR (200)   NULL,
    [CampoFlessibile]           BIT              NOT NULL,
    [DataCreazione]             DATETIME2 (7)    NOT NULL,
    [CreatoDa]                  INT              NULL,
    [DataModifica]              DATETIME2 (7)    NULL,
    [ModificatoDa]              INT              NULL,
    [DataCancellazione]         DATETIME2 (7)    NULL,
    [CancellatoDa]              INT              NULL,
    [UniqueRowId]               UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]        DATETIME2 (7)    NOT NULL,
    [DataFineValidita]          DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_CertificazioneProvaStorico]
    ON [Certificazione].[CertificazioneProvaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

