CREATE TABLE [Standard].[ProfiloProfessionaleIdentificativoStorico] (
    [ProfiloProfessionaleIdentificativoId]        INT              NOT NULL,
    [ProfiloProfessionaleId]                      INT              NOT NULL,
    [TipoIdentificativo]                          NVARCHAR (50)    NOT NULL,
    [ValoreIdentificativo]                        NVARCHAR (600)   NOT NULL,
    [OrigineSistema]                              NVARCHAR (100)   NOT NULL,
    [ProfiloProfessionaleIdentificativoIdOrigine] INT              NULL,
    [NormaFamigliaIdOrigine]                      INT              NULL,
    [NormaEdizioneIdOrigine]                      INT              NULL,
    [CodiceFamigliaOrigine]                       NVARCHAR (200)   NULL,
    [SiglaBaseOrigine]                            NVARCHAR (400)   NULL,
    [RiferimentoEdizioneOrigine]                  NVARCHAR (600)   NULL,
    [RiferimentoDesignazioneOrigine]              NVARCHAR (600)   NULL,
    [TitoloBaseItaOrigine]                        NVARCHAR (2000)  NULL,
    [Note]                                        NVARCHAR (2000)  NULL,
    [Attivo]                                      BIT              NOT NULL,
    [DataCreazione]                               DATETIME2 (7)    NOT NULL,
    [CreatoDa]                                    INT              NULL,
    [DataModifica]                                DATETIME2 (7)    NULL,
    [ModificatoDa]                                INT              NULL,
    [DataCancellazione]                           DATETIME2 (7)    NULL,
    [CancellatoDa]                                INT              NULL,
    [UniqueRowId]                                 UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                          DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                            DATETIME2 (7)    NOT NULL,
    [SorgenteRecordMigrazione]                    NVARCHAR (200)   NULL
);


GO

CREATE CLUSTERED INDEX [ix_ProfiloProfessionaleIdentificativoStorico]
    ON [Standard].[ProfiloProfessionaleIdentificativoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tabella o sistema tecnico dal quale e stato materializzato il record canonico; distinta dalla fonte diretta del valore.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativoStorico', @level2type = N'COLUMN', @level2name = N'SorgenteRecordMigrazione';


GO

