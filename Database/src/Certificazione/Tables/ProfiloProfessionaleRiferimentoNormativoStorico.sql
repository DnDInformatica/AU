CREATE TABLE [Certificazione].[ProfiloProfessionaleRiferimentoNormativoStorico] (
    [ProfiloProfessionaleRiferimentoNormativoId] INT              NOT NULL,
    [ProfiloProfessionaleId]                     INT              NOT NULL,
    [ProfiloProfessionaleSpecificaTecnicaId]     INT              NULL,
    [NormaEdizioneId]                            INT              NULL,
    [SchemaCertificazioneVersioneId]             INT              NULL,
    [TipoRelazione]                              NVARCHAR (30)    NOT NULL,
    [Ordinale]                                   INT              NOT NULL,
    [Obbligatoria]                               BIT              NOT NULL,
    [RiferimentoGrezzo]                          NVARCHAR (2000)  NULL,
    [Attivo]                                     BIT              NOT NULL,
    [DataCreazione]                              DATETIME2 (7)    NOT NULL,
    [CreatoDa]                                   INT              NULL,
    [DataModifica]                               DATETIME2 (7)    NULL,
    [ModificatoDa]                               INT              NULL,
    [DataCancellazione]                          DATETIME2 (7)    NULL,
    [CancellatoDa]                               INT              NULL,
    [UniqueRowId]                                UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                         DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                           DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ProfiloProfessionaleRiferimentoNormativoStorico]
    ON [Certificazione].[ProfiloProfessionaleRiferimentoNormativoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.DecommissionState', @value = N'ARCHIVED_AWAITING_EXTERNAL_APPROVAL', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleRiferimentoNormativoStorico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.ArchiveTable', @value = N'[ArchiveSIAC].[Legacy_Certificazione_ProfiloProfessionaleRiferimentoNormativoStorico]', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleRiferimentoNormativoStorico';


GO

