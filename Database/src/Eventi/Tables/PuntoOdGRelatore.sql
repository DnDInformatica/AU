CREATE TABLE [Eventi].[PuntoOdGRelatore] (
    [PuntoOdGRelatoreId] INT                                         IDENTITY (1, 1) NOT NULL,
    [PuntoOdGId]         INT                                         NOT NULL,
    [PersonaId]          INT                                         NOT NULL,
    [DataDesignazione]   DATE                                        NULL,
    [Note]               NVARCHAR (2000)                             NULL,
    [DataCreazione]      DATETIME2 (7)                               CONSTRAINT [DF_PuntoOdGRelatore_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]           INT                                         NULL,
    [DataModifica]       DATETIME2 (7)                               NULL,
    [ModificatoDa]       INT                                         NULL,
    [DataCancellazione]  DATETIME2 (7)                               NULL,
    [CancellatoDa]       INT                                         NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER                            CONSTRAINT [DF_PuntoOdGRelatore_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_PuntoOdGRelatore] PRIMARY KEY CLUSTERED ([PuntoOdGRelatoreId] ASC),
    CONSTRAINT [FK_PuntoOdGRelatore_Persona] FOREIGN KEY ([PersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [FK_PuntoOdGRelatore_PuntoOdG] FOREIGN KEY ([PuntoOdGId]) REFERENCES [Eventi].[PuntoOdG] ([PuntoOdGId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Eventi].[PuntoOdGRelatoreStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_PuntoOdGRelatore_CreatoDa]
    ON [Eventi].[PuntoOdGRelatore]([CreatoDa] ASC);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_PuntoOdGRelatore]
    ON [Eventi].[PuntoOdGRelatore]([PuntoOdGId] ASC, [PersonaId] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_PuntoOdGRelatore_PersonaId]
    ON [Eventi].[PuntoOdGRelatore]([PersonaId] ASC);


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_PuntoOdGRelatore_DataCancellazione]
    ON [Eventi].[PuntoOdGRelatore]([PuntoOdGRelatoreId] ASC) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdGRelatore","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdGRelatore","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdGRelatore","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdGRelatore","column":"DataDesignazione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataDesignazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogata della designazione. Identity, senza significato di business.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'PuntoOdGRelatoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdGRelatore;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'PuntoOdGId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Persona designata come relatore. FK verso Persone.Persona. E di norma un Componente dell''organo, ma il vincolo non e imposto a livello di schema perche la designazione puo precedere la registrazione del mandato.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'PuntoOdGRelatoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdGRelatore;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'PuntoOdGRelatoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdGRelatore;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdGRelatore;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'PuntoOdGId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdGRelatore;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdGRelatore","column":"DataFineValidita","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":true,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdGRelatore","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio del periodo di validita della versione di riga (colonna di periodo SYSTEM_TIME, generata dal motore).', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdGRelatore;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdGRelatore","column":"PuntoOdGId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Eventi.PuntoOdG.PuntoOdGId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'PuntoOdGId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataDesignazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdGRelatore;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record, per riconciliazione tra sistemi distribuiti.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdGRelatore","column":"Note","data_type":"nvarchar","max_length":4000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ASSOCIAZIONE', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Punto all''ordine del giorno per cui la designazione e disposta. FK verso Eventi.PuntoOdG.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'PuntoOdGId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataDesignazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdGRelatore;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'PuntoOdGRelatoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdGRelatore","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdGRelatore;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdGRelatore","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdGRelatore;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data della designazione, che puo coincidere con l''avviso di convocazione o essere successiva.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataDesignazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'PuntoOdGRelatoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdGRelatore","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'PuntoOdGId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdGRelatore;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdGRelatore;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Annotazioni libere sulla designazione, ad esempio il criterio di rotazione applicato.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdGRelatore;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdGRelatore","column":"PuntoOdGRelatoreId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'PuntoOdGRelatoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdGRelatore;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataDesignazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataDesignazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Relatori designati per la trattazione di uno specifico punto all''ordine del giorno. La relazione e per singola pratica e non per seduta: nell''avviso di convocazione, o con successive comunicazioni, vengono indicati i Relatori per le singole pratiche sulla base di principi di competenza e rotazione (RG-04 rev.06 art. 6). Modellare la relatorship come attributo del punto e non del partecipante evita di duplicare la persona in Eventi.EventoPartecipante e di alterare per errore la base di calcolo del numero legale.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'PuntoOdGId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdGRelatore","column":"PersonaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine del periodo di validita della versione di riga (colonna di periodo SYSTEM_TIME, generata dal motore).', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdGRelatore","column":"DataInizioValidita","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":true,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdGRelatore', @level2type = N'COLUMN', @level2name = N'Note';


GO

