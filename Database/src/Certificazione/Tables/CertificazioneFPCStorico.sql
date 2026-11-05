CREATE TABLE [Certificazione].[CertificazioneFPCStorico] (
    [CertificazioneFPCId]            INT              NOT NULL,
    [CertificazioneId]               INT              NOT NULL,
    [PersonaId]                      INT              NOT NULL,
    [TipoQualificaId]                INT              NOT NULL,
    [Settore]                        NVARCHAR (MAX)   NULL,
    [DataEmissioneCorrente]          DATE             NULL,
    [Straniero]                      BIT              NOT NULL,
    [CodicePersonaODC]               NVARCHAR (50)    NULL,
    [SiacId]                         INT              NULL,
    [DataCreazione]                  DATETIME2 (7)    NOT NULL,
    [CreatoDa]                       INT              NULL,
    [DataModifica]                   DATETIME2 (7)    NULL,
    [ModificatoDa]                   INT              NULL,
    [DataCancellazione]              DATETIME2 (7)    NULL,
    [CancellatoDa]                   INT              NULL,
    [UniqueRowId]                    UNIQUEIDENTIFIER NOT NULL,
    [ProgrammaCertificazioneId]      INT              NULL,
    [LivelloDigCompId]               TINYINT          NULL,
    [DataInizioValidita]             DATETIME2 (7)    NOT NULL,
    [DataFineValidita]               DATETIME2 (7)    NOT NULL,
    [RegolamentazioneODC]            NVARCHAR (MAX)   NULL,
    [ProfiloProfessionaleVersioneId] INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_CertificazioneFPCStorico]
    ON [Certificazione].[CertificazioneFPCStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

