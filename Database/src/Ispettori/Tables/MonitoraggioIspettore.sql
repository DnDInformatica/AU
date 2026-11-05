CREATE TABLE [Ispettori].[MonitoraggioIspettore] (
    [MonitoraggioIspettoreId]      INT                                                IDENTITY (1, 1) NOT NULL,
    [IspettoreId]                  INT                                                NOT NULL,
    [VisitaIspettivaId]            INT                                                NULL,
    [OrganismoAccreditatoId]       INT                                                NULL,
    [TipoMonitoraggio]             NVARCHAR (50)                                      NOT NULL,
    [DataMonitoraggio]             DATE                                               NOT NULL,
    [ValutatoreId]                 INT                                                NOT NULL,
    [RuoloValutatore]              NVARCHAR (50)                                      NOT NULL,
    [EsitoMonitoraggioId]          INT                                                NOT NULL,
    [PunteggioComplessivo]         DECIMAL (3, 1)                                     NULL,
    [ValutazioneCompetenzaTecnica] DECIMAL (3, 1)                                     NULL,
    [ValutazioneCompetenzaSistema] DECIMAL (3, 1)                                     NULL,
    [ValutazioneConduzione]        DECIMAL (3, 1)                                     NULL,
    [ValutazioneDocumentazione]    DECIMAL (3, 1)                                     NULL,
    [ValutazioneRelazioneCab]      DECIMAL (3, 1)                                     NULL,
    [ValutazioneRispettoTempi]     DECIMAL (3, 1)                                     NULL,
    [PuntiForza]                   NVARCHAR (MAX)                                     NULL,
    [AreeMiglioramento]            NVARCHAR (MAX)                                     NULL,
    [RaccomandazioniFormazione]    NVARCHAR (MAX)                                     NULL,
    [RichiedeAzioneCorrettiva]     BIT                                                DEFAULT ((0)) NOT NULL,
    [DescrizioneAzioneCorrettiva]  NVARCHAR (MAX)                                     NULL,
    [DataScadenzaAzione]           DATE                                               NULL,
    [AzioneCompletata]             BIT                                                DEFAULT ((0)) NOT NULL,
    [DataCompletamentoAzione]      DATE                                               NULL,
    [ConfermaQualifica]            BIT                                                DEFAULT ((1)) NOT NULL,
    [DataProssimoMonitoraggio]     DATE                                               NULL,
    [RapportoAllegato]             BIT                                                DEFAULT ((0)) NOT NULL,
    [RiferimentoRapporto]          NVARCHAR (200)                                     NULL,
    [Note]                         NVARCHAR (MAX)                                     NULL,
    [NoteRiservate]                NVARCHAR (MAX)                                     NULL,
    [DataCreazione]                DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                     INT                                                NULL,
    [DataModifica]                 DATETIME2 (7)                                      NULL,
    [ModificatoDa]                 INT                                                NULL,
    [DataCancellazione]            DATETIME2 (7)                                      NULL,
    [CancellatoDa]                 INT                                                NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]           DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]             DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_MonitoraggioIspettore] PRIMARY KEY CLUSTERED ([MonitoraggioIspettoreId] ASC),
    CONSTRAINT [CK_MonitoraggioIspettore_Punteggio] CHECK ([PunteggioComplessivo] IS NULL OR [PunteggioComplessivo]>=(1) AND [PunteggioComplessivo]<=(10)),
    CONSTRAINT [CK_MonitoraggioIspettore_RuoloValutatore] CHECK ([RuoloValutatore]='FUNZIONARIO' OR [RuoloValutatore]='ISPETTORE_SENIOR' OR [RuoloValutatore]='DIRETTORE' OR [RuoloValutatore]='ATM'),
    CONSTRAINT [CK_MonitoraggioIspettore_TipoMonitoraggio] CHECK ([TipoMonitoraggio]='PRIMO_INCARICO' OR [TipoMonitoraggio]='REMOTO' OR [TipoMonitoraggio]='DOCUMENTALE' OR [TipoMonitoraggio]='IN_CAMPO'),
    CONSTRAINT [FK_MonitoraggioIspettore_Esito] FOREIGN KEY ([EsitoMonitoraggioId]) REFERENCES [Tipologica].[EsitoMonitoraggio] ([EsitoMonitoraggioId]),
    CONSTRAINT [FK_MonitoraggioIspettore_Ispettore] FOREIGN KEY ([IspettoreId]) REFERENCES [Ispettori].[Ispettore] ([IspettoreId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Ispettori].[MonitoraggioIspettoreStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"RapportoAllegato","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RapportoAllegato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"DataCompletamentoAzione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataCompletamentoAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataMonitoraggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneCompetenzaSistema';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataMonitoraggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RichiedeAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"DataMonitoraggio","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataMonitoraggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'PuntiForza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneCompetenzaSistema';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutatoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataCompletamentoAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'PuntiForza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'NoteRiservate';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataMonitoraggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneCompetenzaSistema';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DescrizioneAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"PuntiForza","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'PuntiForza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneCompetenzaSistema';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'TipoMonitoraggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataProssimoMonitoraggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneRispettoTempi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'AzioneCompletata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RichiedeAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'TipoMonitoraggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneCompetenzaTecnica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"TipoMonitoraggio","data_type":"nvarchar","max_length":100,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'TipoMonitoraggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RapportoAllegato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataCompletamentoAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataMonitoraggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RichiedeAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneRispettoTempi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'TipoMonitoraggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"ValutazioneCompetenzaSistema","data_type":"decimal","max_length":5,"precision":3,"scale":1,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneCompetenzaSistema';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ConfermaQualifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DescrizioneAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneConduzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"RuoloValutatore","data_type":"nvarchar","max_length":100,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RuoloValutatore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RapportoAllegato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RuoloValutatore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'AreeMiglioramento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DescrizioneAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'AreeMiglioramento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataScadenzaAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"ValutazioneDocumentazione","data_type":"decimal","max_length":5,"precision":3,"scale":1,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneDocumentazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"ConfermaQualifica","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ConfermaQualifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RuoloValutatore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RiferimentoRapporto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneDocumentazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RuoloValutatore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"AreeMiglioramento","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'AreeMiglioramento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'NoteRiservate';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataCompletamentoAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"ValutazioneConduzione","data_type":"decimal","max_length":5,"precision":3,"scale":1,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneConduzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"NoteRiservate","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'NoteRiservate';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutatoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'PuntiForza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"DescrizioneAzioneCorrettiva","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DescrizioneAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneConduzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"ValutatoreId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutatoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RapportoAllegato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataCompletamentoAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneConduzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'NoteRiservate';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutatoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'PuntiForza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneConduzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutatoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RapportoAllegato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DescrizioneAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RiferimentoRapporto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataScadenzaAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneRelazioneCab';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'IspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'MonitoraggioIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'EsitoMonitoraggioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RaccomandazioniFormazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'MonitoraggioIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'EsitoMonitoraggioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'MonitoraggioIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneDocumentazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ConfermaQualifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'IspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"PunteggioComplessivo","data_type":"decimal","max_length":5,"precision":3,"scale":1,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'PunteggioComplessivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataScadenzaAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'IspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"ValutazioneRelazioneCab","data_type":"decimal","max_length":5,"precision":3,"scale":1,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneRelazioneCab';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ConfermaQualifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"RaccomandazioniFormazione","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RaccomandazioniFormazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"IspettoreId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Ispettori.Ispettore.IspettoreId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'IspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'PunteggioComplessivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"DataScadenzaAzione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataScadenzaAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","temporal":true,"temporal_type":2,"history_table":"Ispettori.MonitoraggioIspettoreStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"RiferimentoRapporto","data_type":"nvarchar","max_length":400,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RiferimentoRapporto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneDocumentazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'AreeMiglioramento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'EsitoMonitoraggioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'NoteRiservate';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RuoloValutatore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataScadenzaAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"MonitoraggioIspettoreId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'MonitoraggioIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RiferimentoRapporto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'EsitoMonitoraggioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'AreeMiglioramento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'MonitoraggioIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneDocumentazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"EsitoMonitoraggioId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.EsitoMonitoraggio.EsitoMonitoraggioId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'EsitoMonitoraggioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ConfermaQualifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'AzioneCompletata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RichiedeAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"Note","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'OrganismoAccreditatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneRispettoTempi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"OrganismoAccreditatoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'OrganismoAccreditatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataProssimoMonitoraggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"ValutazioneCompetenzaTecnica","data_type":"decimal","max_length":5,"precision":3,"scale":1,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneCompetenzaTecnica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneRispettoTempi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneCompetenzaTecnica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'AzioneCompletata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'TipoMonitoraggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataProssimoMonitoraggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"RichiedeAzioneCorrettiva","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RichiedeAzioneCorrettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'OrganismoAccreditatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"ValutazioneRispettoTempi","data_type":"decimal","max_length":5,"precision":3,"scale":1,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneRispettoTempi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'OrganismoAccreditatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneCompetenzaTecnica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneRelazioneCab';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RaccomandazioniFormazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'VisitaIspettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'PunteggioComplessivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'AzioneCompletata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"VisitaIspettivaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'VisitaIspettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'VisitaIspettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataProssimoMonitoraggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RiferimentoRapporto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'IspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'PunteggioComplessivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneRelazioneCab';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RaccomandazioniFormazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneCompetenzaTecnica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'OrganismoAccreditatoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'RaccomandazioniFormazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ValutazioneRelazioneCab';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"AzioneCompletata","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'AzioneCompletata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'VisitaIspettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'VisitaIspettivaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:MonitoraggioIspettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'PunteggioComplessivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"MonitoraggioIspettore","column":"DataProssimoMonitoraggio","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'DataProssimoMonitoraggio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'MonitoraggioIspettore', @level2type = N'COLUMN', @level2name = N'Note';


GO

