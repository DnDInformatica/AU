CREATE TABLE [Organizzazioni].[EventoSocietarioImpattoOggetto] (
    [EventoSocietarioImpattoOggettoId] INT                                                IDENTITY (1, 1) NOT NULL,
    [EventoSocietarioId]               INT                                                NOT NULL,
    [OggettoTipo]                      NVARCHAR (80)                                      NOT NULL,
    [OggettoId]                        INT                                                NOT NULL,
    [Azione]                           NVARCHAR (40)                                      NOT NULL,
    [Esito]                            NVARCHAR (40)                                      DEFAULT (N'PENDING') NOT NULL,
    [Decorrenza]                       DATE                                               NULL,
    [Dettaglio]                        NVARCHAR (MAX)                                     NULL,
    [DataCreazione]                    DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                         INT                                                NULL,
    [DataModifica]                     DATETIME2 (7)                                      NULL,
    [ModificatoDa]                     INT                                                NULL,
    [DataCancellazione]                DATETIME2 (7)                                      NULL,
    [CancellatoDa]                     INT                                                NULL,
    [UniqueRowId]                      UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]               DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]                 DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_EventoSocietarioImpattoOggetto] PRIMARY KEY CLUSTERED ([EventoSocietarioImpattoOggettoId] ASC),
    CONSTRAINT [FK_EventoSocietarioImpattoOggetto_EventoSocietario] FOREIGN KEY ([EventoSocietarioId]) REFERENCES [Organizzazioni].[EventoSocietario] ([EventoSocietarioId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Organizzazioni].[EventoSocietarioImpattoOggettoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:EventoSocietarioImpattoOggetto;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:EventoSocietarioImpattoOggetto;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'OggettoTipo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tabella eventosocietarioimpattooggetto con system-versioning nello schema Organizzazioni.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Decorrenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo decorrenza', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Decorrenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:EventoSocietarioImpattoOggetto;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'EventoSocietarioImpattoOggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"EventoSocietarioImpattoOggetto","column":"Esito","data_type":"nvarchar","max_length":80,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Esito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:EventoSocietarioImpattoOggetto;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Dettaglio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Azione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"EventoSocietarioImpattoOggetto","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'EventoSocietarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:EventoSocietarioImpattoOggetto;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete)', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'OggettoTipo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ASSOCIAZIONE', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:EventoSocietarioImpattoOggetto;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"EventoSocietarioImpattoOggetto","column":"OggettoTipo","data_type":"nvarchar","max_length":160,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'OggettoTipo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'EventoSocietarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:EventoSocietarioImpattoOggetto;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"EventoSocietarioImpattoOggetto","column":"EventoSocietarioImpattoOggettoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'EventoSocietarioImpattoOggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'EventoSocietarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Decorrenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Esito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"EventoSocietarioImpattoOggetto","column":"Dettaglio","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Dettaglio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:EventoSocietarioImpattoOggetto;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Azione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"EventoSocietarioImpattoOggetto","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco oggetto', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco eventosocietario (FK verso Organizzazioni.EventoSocietario)', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'EventoSocietarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"EventoSocietarioImpattoOggetto","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"EventoSocietarioImpattoOggetto","temporal":true,"temporal_type":2,"history_table":"Organizzazioni.EventoSocietarioImpattoOggettoStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Dettaglio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Esito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"EventoSocietarioImpattoOggetto","column":"Decorrenza","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Decorrenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco eventosocietarioimpattooggetto', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'EventoSocietarioImpattoOggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'OggettoTipo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"EventoSocietarioImpattoOggetto","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:EventoSocietarioImpattoOggetto;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'EventoSocietarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"EventoSocietarioImpattoOggetto","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Esito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:EventoSocietarioImpattoOggetto;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Decorrenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo esito', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Esito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Dettaglio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'EventoSocietarioImpattoOggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"EventoSocietarioImpattoOggetto","column":"Azione","data_type":"nvarchar","max_length":80,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Azione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco tecnico del record', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo azione', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Azione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Decorrenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:EventoSocietarioImpattoOggetto;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Esito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Azione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Dettaglio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"EventoSocietarioImpattoOggetto","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"EventoSocietarioImpattoOggetto","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'EventoSocietarioImpattoOggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"EventoSocietarioImpattoOggetto","column":"OggettoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"EventoSocietarioImpattoOggetto","column":"EventoSocietarioId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Organizzazioni.EventoSocietario.EventoSocietarioId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'EventoSocietarioId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:EventoSocietarioImpattoOggetto;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'OggettoTipo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Azione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:EventoSocietarioImpattoOggetto;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'OggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo dettaglio', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'Dettaglio';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo oggettotipo', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'OggettoTipo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'EventoSocietarioImpattoOggettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:EventoSocietarioImpattoOggetto;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:EventoSocietarioImpattoOggetto;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'EventoSocietarioImpattoOggetto', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

