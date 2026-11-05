CREATE TABLE [Eventi].[PuntoOdG] (
    [PuntoOdGId]         INT                                                IDENTITY (1, 1) NOT NULL,
    [EventoId]           INT                                                NOT NULL,
    [NumeroOrdine]       INT                                                NOT NULL,
    [Titolo]             NVARCHAR (1000)                                    NOT NULL,
    [Descrizione]        NVARCHAR (MAX)                                     NULL,
    [DataCreazione]      DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]           INT                                                NULL,
    [DataModifica]       DATETIME2 (7)                                      NULL,
    [ModificatoDa]       INT                                                NULL,
    [DataCancellazione]  DATETIME2 (7)                                      NULL,
    [CancellatoDa]       INT                                                NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [StatoPuntoOdGId]    INT                                                NOT NULL,
    CONSTRAINT [PK_PuntoOdG] PRIMARY KEY CLUSTERED ([PuntoOdGId] ASC),
    CONSTRAINT [CK_PuntoOdG_Numero] CHECK ([NumeroOrdine]>(0)),
    CONSTRAINT [FK_PuntoOdG_Evento] FOREIGN KEY ([EventoId]) REFERENCES [Eventi].[Evento] ([EventoId]),
    CONSTRAINT [FK_PuntoOdG_StatoPuntoOdG] FOREIGN KEY ([StatoPuntoOdGId]) REFERENCES [Tipologica].[StatoPuntoOdG] ([StatoPuntoOdGId]),
    CONSTRAINT [UQ_PuntoOdG_Evento_Ordine] UNIQUE NONCLUSTERED ([EventoId] ASC, [NumeroOrdine] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Eventi].[PuntoOdGStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_PuntoOdG_StatoPuntoOdGId]
    ON [Eventi].[PuntoOdG]([StatoPuntoOdGId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdG;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdG;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdG;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdG;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'PuntoOdGId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdG;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'PuntoOdGId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'eventi;odg;csa', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdG;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'NumeroOrdine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdG;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdG;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdG;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdG;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'NumeroOrdine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'NumeroOrdine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdG;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'PuntoOdGId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdG","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Titolo o identificativo descrittivo da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdG","column":"Descrizione","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdG","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdG","column":"Titolo","data_type":"nvarchar","max_length":2000,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione testuale da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdG","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:PuntoOdG;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdG","temporal":true,"temporal_type":2,"history_table":"Eventi.PuntoOdGStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdG","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Punto dell''ordine del giorno di un evento.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'PuntoOdGId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdG","column":"PuntoOdGId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'PuntoOdGId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdG","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdG","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'NumeroOrdine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'NumeroOrdine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdG","column":"NumeroOrdine","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'NumeroOrdine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'PuntoOdGId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdG","column":"EventoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Eventi.Evento.EventoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"PuntoOdG","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'PuntoOdG', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

