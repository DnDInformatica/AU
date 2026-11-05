CREATE TABLE [Certificazione].[ProgrammaCertificazioneVersioneIdentificativoStorico] (
    [ProgrammaCertificazioneVersioneIdentificativoId] INT              NOT NULL,
    [ProgrammaCertificazioneVersioneId]               INT              NOT NULL,
    [TipoIdentificativo]                              NVARCHAR (400)   NOT NULL,
    [ValoreIdentificativo]                            NVARCHAR (2400)  NOT NULL,
    [OrigineSistema]                                  NVARCHAR (800)   NOT NULL,
    [NormaFamigliaIdOrigine]                          INT              NULL,
    [NormaEdizioneIdOrigine]                          INT              NULL,
    [NormaAccreditamentoIdOrigine]                    INT              NULL,
    [NormaAccreditamentoSchemaIdOrigine]              INT              NULL,
    [CodiceSPOrigine]                                 NVARCHAR (200)   NULL,
    [NomeProgrammaOrigine]                            NVARCHAR (1020)  NULL,
    [RiferimentoEdizioneOrigine]                      NVARCHAR (1200)  NULL,
    [RiferimentoDesignazioneOrigine]                  NVARCHAR (1200)  NULL,
    [Note]                                            NVARCHAR (4000)  NULL,
    [Attivo]                                          BIT              NOT NULL,
    [DataCreazione]                                   DATETIME2 (7)    NOT NULL,
    [CreatoDa]                                        INT              NULL,
    [DataModifica]                                    DATETIME2 (7)    NULL,
    [ModificatoDa]                                    INT              NULL,
    [DataCancellazione]                               DATETIME2 (7)    NULL,
    [CancellatoDa]                                    INT              NULL,
    [UniqueRowId]                                     UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                              DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                                DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ProgrammaCertificazioneVersioneIdentificativoStorico]
    ON [Certificazione].[ProgrammaCertificazioneVersioneIdentificativoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

