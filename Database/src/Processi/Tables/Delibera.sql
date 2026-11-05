CREATE TABLE [Processi].[Delibera] (
    [DeliberaId]         INT                                                IDENTITY (1, 1) NOT NULL,
    [PraticaId]          INT                                                NOT NULL,
    [EventoId]           INT                                                NULL,
    [DocumentoId]        INT                                                NULL,
    [NumeroDelibera]     NVARCHAR (100)                                     NULL,
    [DataDelibera]       DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [TestoSintesi]       NVARCHAR (MAX)                                     NULL,
    [DataCreazione]      DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]           INT                                                NULL,
    [DataModifica]       DATETIME2 (7)                                      NULL,
    [ModificatoDa]       INT                                                NULL,
    [DataCancellazione]  DATETIME2 (7)                                      NULL,
    [CancellatoDa]       INT                                                NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [EsitoDeliberaId]    INT                                                NOT NULL,
    [StatoDeliberaId]    INT                                                NOT NULL,
    CONSTRAINT [PK_Delibera] PRIMARY KEY CLUSTERED ([DeliberaId] ASC),
    CONSTRAINT [FK_Delibera_Documento] FOREIGN KEY ([DocumentoId]) REFERENCES [Documentale].[Documento] ([DocumentoId]),
    CONSTRAINT [FK_Delibera_EsitoDelibera] FOREIGN KEY ([EsitoDeliberaId]) REFERENCES [Tipologica].[EsitoDelibera] ([EsitoDeliberaId]),
    CONSTRAINT [FK_Delibera_Evento] FOREIGN KEY ([EventoId]) REFERENCES [Eventi].[Evento] ([EventoId]),
    CONSTRAINT [FK_Delibera_Pratica] FOREIGN KEY ([PraticaId]) REFERENCES [Processi].[Pratica] ([PraticaId]),
    CONSTRAINT [FK_Delibera_StatoDelibera] FOREIGN KEY ([StatoDeliberaId]) REFERENCES [Tipologica].[StatoDelibera] ([StatoDeliberaId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Processi].[DeliberaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_Delibera_EsitoDeliberaId]
    ON [Processi].[Delibera]([EsitoDeliberaId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Delibera_StatoDeliberaId]
    ON [Processi].[Delibera]([StatoDeliberaId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Delibera","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'TestoSintesi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Delibera","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Titolo o identificativo descrittivo da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'NumeroDelibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Delibera;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Delibera;Nullable', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'NumeroDelibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Delibera;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Data di business da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataDelibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Delibera","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Delibera","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Delibera;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'processi;delibere;csa;compliance', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'NumeroDelibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Delibera;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Delibera;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataDelibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Delibera","column":"TestoSintesi","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'TestoSintesi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Delibera;NotNull', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Delibera;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Delibera;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Delibera","column":"DocumentoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Documentale.Documento.DocumentoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'TestoSintesi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Delibera","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Delibera","column":"NumeroDelibera","data_type":"nvarchar","max_length":200,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'NumeroDelibera';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Delibera formalizzata associata a una pratica e a una seduta.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Delibera;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataDelibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Delibera;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Delibera","column":"DataDelibera","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataDelibera';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'TestoSintesi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Delibera","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'TestoSintesi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Delibera;NotNull', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataDelibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Delibera","column":"DeliberaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'NumeroDelibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Delibera","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Delibera","column":"PraticaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Processi.Pratica.PraticaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'PraticaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Delibera;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Delibera","column":"EventoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Eventi.Evento.EventoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Processi","table":"Delibera","temporal":true,"temporal_type":2,"history_table":"Processi.DeliberaStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataDelibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Processi;Table:Delibera;Nullable', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'TestoSintesi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'NumeroDelibera';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'TABLE', @level1name = N'Delibera', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

