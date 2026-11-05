CREATE TABLE [ArchiveSIAC].[Legacy_Certificazione_ProfiloProfessionaleRiferimentoNormativoStorico] (
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

CREATE   TRIGGER [ArchiveSIAC].[TR_MIG123_Immutable_ProfiloProfessionaleRiferimentoNormativoStorico] ON [ArchiveSIAC].[Legacy_Certificazione_ProfiloProfessionaleRiferimentoNormativoStorico] AFTER INSERT, UPDATE, DELETE AS
               BEGIN
                   SET NOCOUNT ON;
                   THROW 62330,
                       'MIG_123: archivio legacy immutabile.', 1;
               END;

GO

