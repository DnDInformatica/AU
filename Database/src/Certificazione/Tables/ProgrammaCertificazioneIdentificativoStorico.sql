CREATE TABLE [Certificazione].[ProgrammaCertificazioneIdentificativoStorico] (
    [ProgrammaCertificazioneIdentificativoId] INT              NOT NULL,
    [ProgrammaCertificazioneId]               INT              NOT NULL,
    [TipoIdentificativo]                      NVARCHAR (200)   NOT NULL,
    [ValoreIdentificativo]                    NVARCHAR (1200)  NOT NULL,
    [OrigineSistema]                          NVARCHAR (400)   NOT NULL,
    [NormaFamigliaIdOrigine]                  INT              NULL,
    [NormaEdizioneIdOrigine]                  INT              NULL,
    [NormaAccreditamentoIdOrigine]            INT              NULL,
    [NormaAccreditamentoSchemaIdOrigine]      INT              NULL,
    [CodiceSPOrigine]                         NVARCHAR (100)   NULL,
    [NomeProgrammaOrigine]                    NVARCHAR (510)   NULL,
    [RiferimentoEdizioneOrigine]              NVARCHAR (600)   NULL,
    [RiferimentoDesignazioneOrigine]          NVARCHAR (600)   NULL,
    [Note]                                    NVARCHAR (4000)  NULL,
    [Attivo]                                  BIT              NOT NULL,
    [DataCreazione]                           DATETIME2 (7)    NOT NULL,
    [CreatoDa]                                INT              NULL,
    [DataModifica]                            DATETIME2 (7)    NULL,
    [ModificatoDa]                            INT              NULL,
    [DataCancellazione]                       DATETIME2 (7)    NULL,
    [CancellatoDa]                            INT              NULL,
    [UniqueRowId]                             UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                      DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                        DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ProgrammaCertificazioneIdentificativoStorico]
    ON [Certificazione].[ProgrammaCertificazioneIdentificativoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

