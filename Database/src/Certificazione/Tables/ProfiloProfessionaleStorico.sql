CREATE TABLE [Certificazione].[ProfiloProfessionaleStorico] (
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

CREATE CLUSTERED INDEX [ix_ProfiloProfessionaleStorico]
    ON [Certificazione].[ProfiloProfessionaleStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.DecommissionState', @value = N'ARCHIVED_AWAITING_EXTERNAL_APPROVAL', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleStorico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.ArchiveTable', @value = N'[ArchiveSIAC].[Legacy_Certificazione_ProfiloProfessionaleStorico]', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleStorico';


GO

