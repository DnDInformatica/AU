CREATE TABLE [Standard].[ProfiloProfessionaleVersioneStorico] (
    [ProfiloProfessionaleVersioneId] INT              NOT NULL,
    [ProfiloProfessionaleId]         INT              NOT NULL,
    [CodiceVersione]                 NVARCHAR (100)   NOT NULL,
    [DescrizioneIta]                 NVARCHAR (2000)  NOT NULL,
    [DescrizioneEng]                 NVARCHAR (2000)  NULL,
    [ScopoFlessibile]                BIT              NOT NULL,
    [DataInizioApplicabilita]        DATE             NULL,
    [DataFineApplicabilita]          DATE             NULL,
    [VersioneCorrente]               BIT              NOT NULL,
    [OrigineSistema]                 NVARCHAR (200)   NOT NULL,
    [ProfiloProfessionaleIdOrigine]  INT              NULL,
    [DataInizioValiditaOrigine]      DATETIME2 (7)    NULL,
    [DataFineValiditaOrigine]        DATETIME2 (7)    NULL,
    [Attivo]                         BIT              NOT NULL,
    [DataCreazione]                  DATETIME2 (7)    NOT NULL,
    [CreatoDa]                       INT              NULL,
    [DataModifica]                   DATETIME2 (7)    NULL,
    [ModificatoDa]                   INT              NULL,
    [DataCancellazione]              DATETIME2 (7)    NULL,
    [CancellatoDa]                   INT              NULL,
    [UniqueRowId]                    UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]             DATETIME2 (7)    NOT NULL,
    [DataFineValidita]               DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ProfiloProfessionaleVersioneStorico]
    ON [Standard].[ProfiloProfessionaleVersioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

