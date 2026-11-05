CREATE TABLE [Ispettori].[MonitoraggioIspettoreStorico] (
    [MonitoraggioIspettoreId]      INT              NOT NULL,
    [IspettoreId]                  INT              NOT NULL,
    [VisitaIspettivaId]            INT              NULL,
    [OrganismoAccreditatoId]       INT              NULL,
    [TipoMonitoraggio]             NVARCHAR (50)    NOT NULL,
    [DataMonitoraggio]             DATE             NOT NULL,
    [ValutatoreId]                 INT              NOT NULL,
    [RuoloValutatore]              NVARCHAR (50)    NOT NULL,
    [EsitoMonitoraggioId]          INT              NOT NULL,
    [PunteggioComplessivo]         DECIMAL (3, 1)   NULL,
    [ValutazioneCompetenzaTecnica] DECIMAL (3, 1)   NULL,
    [ValutazioneCompetenzaSistema] DECIMAL (3, 1)   NULL,
    [ValutazioneConduzione]        DECIMAL (3, 1)   NULL,
    [ValutazioneDocumentazione]    DECIMAL (3, 1)   NULL,
    [ValutazioneRelazioneCab]      DECIMAL (3, 1)   NULL,
    [ValutazioneRispettoTempi]     DECIMAL (3, 1)   NULL,
    [PuntiForza]                   NVARCHAR (MAX)   NULL,
    [AreeMiglioramento]            NVARCHAR (MAX)   NULL,
    [RaccomandazioniFormazione]    NVARCHAR (MAX)   NULL,
    [RichiedeAzioneCorrettiva]     BIT              NOT NULL,
    [DescrizioneAzioneCorrettiva]  NVARCHAR (MAX)   NULL,
    [DataScadenzaAzione]           DATE             NULL,
    [AzioneCompletata]             BIT              NOT NULL,
    [DataCompletamentoAzione]      DATE             NULL,
    [ConfermaQualifica]            BIT              NOT NULL,
    [DataProssimoMonitoraggio]     DATE             NULL,
    [RapportoAllegato]             BIT              NOT NULL,
    [RiferimentoRapporto]          NVARCHAR (200)   NULL,
    [Note]                         NVARCHAR (MAX)   NULL,
    [NoteRiservate]                NVARCHAR (MAX)   NULL,
    [DataCreazione]                DATETIME2 (7)    NOT NULL,
    [CreatoDa]                     INT              NULL,
    [DataModifica]                 DATETIME2 (7)    NULL,
    [ModificatoDa]                 INT              NULL,
    [DataCancellazione]            DATETIME2 (7)    NULL,
    [CancellatoDa]                 INT              NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]           DATETIME2 (7)    NOT NULL,
    [DataFineValidita]             DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_MonitoraggioIspettoreStorico]
    ON [Ispettori].[MonitoraggioIspettoreStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

