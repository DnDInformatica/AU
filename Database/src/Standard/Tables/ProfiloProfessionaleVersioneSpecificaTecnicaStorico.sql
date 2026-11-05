CREATE TABLE [Standard].[ProfiloProfessionaleVersioneSpecificaTecnicaStorico] (
    [ProfiloProfessionaleVersioneSpecificaTecnicaId] INT              NOT NULL,
    [ProfiloProfessionaleVersioneId]                 INT              NOT NULL,
    [Ordinale]                                       INT              NOT NULL,
    [SpecificaTecnicaIta]                            NVARCHAR (1000)  NOT NULL,
    [SpecificaTecnicaEng]                            NVARCHAR (1000)  NULL,
    [AnnoNorma]                                      INT              NULL,
    [NormaEdizioneId]                                INT              NULL,
    [OrigineSistema]                                 NVARCHAR (200)   NOT NULL,
    [ProfiloProfessionaleSpecificaTecnicaIdOrigine]  INT              NULL,
    [Attivo]                                         BIT              NOT NULL,
    [DataCreazione]                                  DATETIME2 (7)    NOT NULL,
    [CreatoDa]                                       INT              NULL,
    [DataModifica]                                   DATETIME2 (7)    NULL,
    [ModificatoDa]                                   INT              NULL,
    [DataCancellazione]                              DATETIME2 (7)    NULL,
    [CancellatoDa]                                   INT              NULL,
    [UniqueRowId]                                    UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                             DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                               DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ProfiloProfessionaleVersioneSpecificaTecnicaStorico]
    ON [Standard].[ProfiloProfessionaleVersioneSpecificaTecnicaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

