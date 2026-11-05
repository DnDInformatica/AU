CREATE TABLE [Ispettori].[AssegnazioneIspettoreStorico] (
    [AssegnazioneIspettoreId] INT              NOT NULL,
    [GruppoVerificaId]        INT              NOT NULL,
    [IspettoreId]             INT              NOT NULL,
    [RuoloNelGruppo]          NVARCHAR (50)    NOT NULL,
    [IsTeamLeader]            BIT              NOT NULL,
    [QualificaIspettoreId]    INT              NULL,
    [DataAssegnazione]        DATE             NOT NULL,
    [DataConferma]            DATE             NULL,
    [DataPartecipazione]      DATE             NULL,
    [StatoAssegnazione]       NVARCHAR (20)    NOT NULL,
    [MotivoRifiuto]           NVARCHAR (500)   NULL,
    [ConflittoRilevato]       BIT              NOT NULL,
    [DescrizioneConflitto]    NVARCHAR (500)   NULL,
    [ConflittoRisolto]        BIT              NOT NULL,
    [OrePreventivate]         DECIMAL (5, 2)   NULL,
    [OreEffettive]            DECIMAL (5, 2)   NULL,
    [ValutazioneTeamLeader]   NVARCHAR (MAX)   NULL,
    [Note]                    NVARCHAR (1000)  NULL,
    [DataCreazione]           DATETIME2 (7)    NOT NULL,
    [CreatoDa]                INT              NULL,
    [DataModifica]            DATETIME2 (7)    NULL,
    [ModificatoDa]            INT              NULL,
    [DataCancellazione]       DATETIME2 (7)    NULL,
    [CancellatoDa]            INT              NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]      DATETIME2 (7)    NOT NULL,
    [DataFineValidita]        DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_AssegnazioneIspettoreStorico]
    ON [Ispettori].[AssegnazioneIspettoreStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

