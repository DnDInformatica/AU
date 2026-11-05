CREATE TABLE [Standard].[NormaFamigliaIdentificativoStorico] (
    [NormaFamigliaIdentificativoId] INT              NOT NULL,
    [NormaFamigliaId]               INT              NOT NULL,
    [TipoIdentificativo]            NVARCHAR (100)   NOT NULL,
    [ValoreIdentificativo]          NVARCHAR (600)   NOT NULL,
    [OrigineSistema]                NVARCHAR (200)   NOT NULL,
    [NormaFamigliaIdOrigine]        INT              NULL,
    [CodiceFamigliaOrigine]         NVARCHAR (200)   NULL,
    [SiglaBaseOrigine]              NVARCHAR (400)   NULL,
    [TitoloBaseItaOrigine]          NVARCHAR (2000)  NULL,
    [Note]                          NVARCHAR (2000)  NULL,
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

CREATE CLUSTERED INDEX [ix_NormaFamigliaIdentificativoStorico]
    ON [Standard].[NormaFamigliaIdentificativoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

