CREATE TABLE [Standard].[ProfiloProfessionaleVersioneRiferimentoNormativoStorico] (
    [ProfiloProfessionaleVersioneRiferimentoNormativoId] INT              NOT NULL,
    [ProfiloProfessionaleVersioneId]                     INT              NOT NULL,
    [ProfiloProfessionaleVersioneSpecificaTecnicaId]     INT              NULL,
    [NormaEdizioneId]                                    INT              NULL,
    [SchemaCertificazioneVersioneId]                     INT              NULL,
    [TipoRelazione]                                      NVARCHAR (30)    NOT NULL,
    [Ordinale]                                           INT              NOT NULL,
    [Obbligatoria]                                       BIT              NOT NULL,
    [RiferimentoGrezzo]                                  NVARCHAR (2000)  NULL,
    [OrigineSistema]                                     NVARCHAR (200)   NOT NULL,
    [ProfiloProfessionaleRiferimentoNormativoIdOrigine]  INT              NULL,
    [Attivo]                                             BIT              NOT NULL,
    [DataCreazione]                                      DATETIME2 (7)    NOT NULL,
    [CreatoDa]                                           INT              NULL,
    [DataModifica]                                       DATETIME2 (7)    NULL,
    [ModificatoDa]                                       INT              NULL,
    [DataCancellazione]                                  DATETIME2 (7)    NULL,
    [CancellatoDa]                                       INT              NULL,
    [UniqueRowId]                                        UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                                 DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                                   DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ProfiloProfessionaleVersioneRiferimentoNormativoStorico]
    ON [Standard].[ProfiloProfessionaleVersioneRiferimentoNormativoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

