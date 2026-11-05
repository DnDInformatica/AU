CREATE TABLE [Certificazione].[CertificazioneEvidenzaDocumentoStorico] (
    [CertificazioneEvidenzaDocumentoId] INT              NOT NULL,
    [CertificazioneId]                  INT              NOT NULL,
    [ProgrammaRequisitoEvidenzaId]      INT              NOT NULL,
    [DocumentoId]                       INT              NOT NULL,
    [DataPresentazione]                 DATETIME2 (7)    NOT NULL,
    [DataValidazione]                   DATETIME2 (7)    NULL,
    [ValidatoDa]                        INT              NULL,
    [NoteValidazione]                   NVARCHAR (MAX)   NULL,
    [Obbligatoria]                      BIT              NOT NULL,
    [Attivo]                            BIT              NOT NULL,
    [DataCreazione]                     DATETIME2 (7)    NOT NULL,
    [CreatoDa]                          INT              NULL,
    [DataModifica]                      DATETIME2 (7)    NULL,
    [ModificatoDa]                      INT              NULL,
    [DataCancellazione]                 DATETIME2 (7)    NULL,
    [CancellatoDa]                      INT              NULL,
    [UniqueRowId]                       UNIQUEIDENTIFIER NOT NULL,
    [TipoEsitoValidazioneEvidenzaId]    INT              NULL,
    [DataInizioValidita]                DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                  DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_CertificazioneEvidenzaDocumentoStorico]
    ON [Certificazione].[CertificazioneEvidenzaDocumentoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

