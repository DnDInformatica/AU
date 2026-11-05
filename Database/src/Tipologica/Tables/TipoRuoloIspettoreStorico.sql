CREATE TABLE [Tipologica].[TipoRuoloIspettoreStorico] (
    [TipoRuoloIspettoreId]       INT              NOT NULL,
    [Codice]                     NVARCHAR (20)    NOT NULL,
    [Descrizione]                NVARCHAR (200)   NOT NULL,
    [DescrizioneEstesa]          NVARCHAR (1000)  NULL,
    [Categoria]                  NVARCHAR (50)    NOT NULL,
    [PuoEssereTeamLeader]        BIT              NOT NULL,
    [PuoCondurreVerificaSistema] BIT              NOT NULL,
    [PuoCondurreVerificaTecnica] BIT              NOT NULL,
    [RequisitiMinimi]            NVARCHAR (MAX)   NULL,
    [Ordine]                     INT              NOT NULL,
    [Attivo]                     BIT              NOT NULL,
    [DataCreazione]              DATETIME2 (7)    NOT NULL,
    [CreatoDa]                   INT              NULL,
    [DataModifica]               DATETIME2 (7)    NULL,
    [ModificatoDa]               INT              NULL,
    [DataCancellazione]          DATETIME2 (7)    NULL,
    [CancellatoDa]               INT              NULL,
    [UniqueRowId]                UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]         DATETIME2 (7)    NOT NULL,
    [DataFineValidita]           DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_TipoRuoloIspettoreStorico]
    ON [Tipologica].[TipoRuoloIspettoreStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

