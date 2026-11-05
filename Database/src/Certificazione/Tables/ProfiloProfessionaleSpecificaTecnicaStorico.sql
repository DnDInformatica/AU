CREATE TABLE [Certificazione].[ProfiloProfessionaleSpecificaTecnicaStorico] (
    [ProfiloProfessionaleSpecificaTecnicaId] INT              NOT NULL,
    [ProfiloProfessionaleId]                 INT              NOT NULL,
    [Ordinale]                               INT              NOT NULL,
    [SpecificaTecnicaIta]                    NVARCHAR (1000)  NOT NULL,
    [SpecificaTecnicaEng]                    NVARCHAR (1000)  NULL,
    [AnnoNorma]                              INT              NULL,
    [Attivo]                                 BIT              NOT NULL,
    [DataCreazione]                          DATETIME2 (7)    NOT NULL,
    [CreatoDa]                               INT              NULL,
    [DataModifica]                           DATETIME2 (7)    NULL,
    [ModificatoDa]                           INT              NULL,
    [DataCancellazione]                      DATETIME2 (7)    NULL,
    [CancellatoDa]                           INT              NULL,
    [UniqueRowId]                            UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                     DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                       DATETIME2 (7)    NOT NULL,
    [NormaEdizioneId]                        INT              NULL
);


GO

CREATE CLUSTERED INDEX [ix_ProfiloProfessionaleSpecificaTecnicaStorico]
    ON [Certificazione].[ProfiloProfessionaleSpecificaTecnicaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.DecommissionState', @value = N'ARCHIVED_AWAITING_EXTERNAL_APPROVAL', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleSpecificaTecnicaStorico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.ArchiveTable', @value = N'[ArchiveSIAC].[Legacy_Certificazione_ProfiloProfessionaleSpecificaTecnicaStorico]', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleSpecificaTecnicaStorico';


GO

