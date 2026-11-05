CREATE TABLE [Standard].[ProfiloProfessionaleStorico] (
    [ProfiloProfessionaleId]        INT              NOT NULL,
    [Codice]                        NVARCHAR (100)   NOT NULL,
    [OrigineSistema]                NVARCHAR (200)   NOT NULL,
    [ProfiloProfessionaleIdOrigine] INT              NULL,
    [Attivo]                        BIT              NOT NULL,
    [DataCreazione]                 DATETIME2 (7)    NOT NULL,
    [CreatoDa]                      INT              NULL,
    [DataModifica]                  DATETIME2 (7)    NULL,
    [ModificatoDa]                  INT              NULL,
    [DataCancellazione]             DATETIME2 (7)    NULL,
    [CancellatoDa]                  INT              NULL,
    [UniqueRowId]                   UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]            DATETIME2 (7)    NOT NULL,
    [DataFineValidita]              DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ProfiloProfessionaleStorico]
    ON [Standard].[ProfiloProfessionaleStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

