CREATE TABLE [Certificazione].[ProfiloProfessionaleIdentificativoStorico] (
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

CREATE CLUSTERED INDEX [ix_ProfiloProfessionaleIdentificativoStorico]
    ON [Certificazione].[ProfiloProfessionaleIdentificativoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.ArchiveTable', @value = N'[ArchiveSIAC].[Legacy_Certificazione_ProfiloProfessionaleIdentificativoStorico]', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativoStorico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.DecommissionState', @value = N'ARCHIVED_AWAITING_EXTERNAL_APPROVAL', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativoStorico';


GO

