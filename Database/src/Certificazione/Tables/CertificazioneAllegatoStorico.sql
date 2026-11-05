CREATE TABLE [Certificazione].[CertificazioneAllegatoStorico] (
    [CertificazioneAllegatoId] INT              NOT NULL,
    [CertificazioneId]         INT              NOT NULL,
    [CertificazioneSedeId]     INT              NULL,
    [NomeFile]                 NVARCHAR (500)   NOT NULL,
    [PathFile]                 NVARCHAR (1000)  NULL,
    [DataScadenzaAllegato]     DATE             NULL,
    [Revisione]                NVARCHAR (20)    NULL,
    [DataRevisione]            DATE             NULL,
    [Note]                     NVARCHAR (500)   NULL,
    [DataCreazione]            DATETIME2 (7)    NOT NULL,
    [CreatoDa]                 INT              NULL,
    [DataModifica]             DATETIME2 (7)    NULL,
    [ModificatoDa]             INT              NULL,
    [DataCancellazione]        DATETIME2 (7)    NULL,
    [CancellatoDa]             INT              NULL,
    [UniqueRowId]              UNIQUEIDENTIFIER NOT NULL,
    [TipoAllegatoId]           INT              NOT NULL,
    [DataInizioValidita]       DATETIME2 (7)    NOT NULL,
    [DataFineValidita]         DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_CertificazioneAllegatoStorico]
    ON [Certificazione].[CertificazioneAllegatoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

