CREATE TABLE [ArchiveSIAC].[Legacy_Certificazione_ProfiloProfessionaleSpecificaTecnica] (
    [ProfiloProfessionaleSpecificaTecnicaId] INT              IDENTITY (1, 1) NOT NULL,
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

CREATE   TRIGGER [ArchiveSIAC].[TR_MIG123_Immutable_ProfiloProfessionaleSpecificaTecnica] ON [ArchiveSIAC].[Legacy_Certificazione_ProfiloProfessionaleSpecificaTecnica] AFTER INSERT, UPDATE, DELETE AS
               BEGIN
                   SET NOCOUNT ON;
                   THROW 62330,
                       'MIG_123: archivio legacy immutabile.', 1;
               END;

GO

