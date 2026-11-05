CREATE TABLE [ArchiveSIAC].[Legacy_Certificazione_ProfiloProfessionaleIdentificativoStorico] (
    [ProfiloProfessionaleIdentificativoId] INT              NOT NULL,
    [ProfiloProfessionaleId]               INT              NOT NULL,
    [TipoIdentificativo]                   NVARCHAR (100)   NOT NULL,
    [ValoreIdentificativo]                 NVARCHAR (600)   NOT NULL,
    [OrigineSistema]                       NVARCHAR (200)   NOT NULL,
    [NormaFamigliaIdOrigine]               INT              NULL,
    [NormaEdizioneIdOrigine]               INT              NULL,
    [CodiceFamigliaOrigine]                NVARCHAR (200)   NULL,
    [SiglaBaseOrigine]                     NVARCHAR (400)   NULL,
    [RiferimentoEdizioneOrigine]           NVARCHAR (600)   NULL,
    [RiferimentoDesignazioneOrigine]       NVARCHAR (600)   NULL,
    [TitoloBaseItaOrigine]                 NVARCHAR (2000)  NULL,
    [Note]                                 NVARCHAR (2000)  NULL,
    [Attivo]                               BIT              NOT NULL,
    [DataCreazione]                        DATETIME2 (7)    NOT NULL,
    [CreatoDa]                             INT              NULL,
    [DataModifica]                         DATETIME2 (7)    NULL,
    [ModificatoDa]                         INT              NULL,
    [DataCancellazione]                    DATETIME2 (7)    NULL,
    [CancellatoDa]                         INT              NULL,
    [UniqueRowId]                          UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                   DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                     DATETIME2 (7)    NOT NULL
);


GO

CREATE   TRIGGER [ArchiveSIAC].[TR_MIG123_Immutable_ProfiloProfessionaleIdentificativoStorico] ON [ArchiveSIAC].[Legacy_Certificazione_ProfiloProfessionaleIdentificativoStorico] AFTER INSERT, UPDATE, DELETE AS
               BEGIN
                   SET NOCOUNT ON;
                   THROW 62330,
                       'MIG_123: archivio legacy immutabile.', 1;
               END;

GO

