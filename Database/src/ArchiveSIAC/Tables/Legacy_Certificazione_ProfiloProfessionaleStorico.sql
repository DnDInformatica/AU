CREATE TABLE [ArchiveSIAC].[Legacy_Certificazione_ProfiloProfessionaleStorico] (
    [ProfiloProfessionaleId] INT              NOT NULL,
    [Codice]                 NVARCHAR (100)   NOT NULL,
    [Descrizione]            NVARCHAR (2000)  NOT NULL,
    [DescrizioneEng]         NVARCHAR (2000)  NULL,
    [Attivo]                 BIT              NOT NULL,
    [DataCreazione]          DATETIME2 (7)    NOT NULL,
    [CreatoDa]               INT              NULL,
    [DataModifica]           DATETIME2 (7)    NULL,
    [ModificatoDa]           INT              NULL,
    [DataCancellazione]      DATETIME2 (7)    NULL,
    [CancellatoDa]           INT              NULL,
    [UniqueRowId]            UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]     DATETIME2 (7)    NOT NULL,
    [DataFineValidita]       DATETIME2 (7)    NOT NULL,
    [ScopoFlessibile]        BIT              NOT NULL
);


GO

CREATE   TRIGGER [ArchiveSIAC].[TR_MIG123_Immutable_ProfiloProfessionaleStorico] ON [ArchiveSIAC].[Legacy_Certificazione_ProfiloProfessionaleStorico] AFTER INSERT, UPDATE, DELETE AS
               BEGIN
                   SET NOCOUNT ON;
                   THROW 62330,
                       'MIG_123: archivio legacy immutabile.', 1;
               END;

GO

