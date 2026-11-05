CREATE TABLE [Eventi].[Verbale] (
    [VerbaleId]          INT                                                IDENTITY (1, 1) NOT NULL,
    [EventoId]           INT                                                NOT NULL,
    [DocumentoId]        INT                                                NOT NULL,
    [DataRedazione]      DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [DataApprovazione]   DATETIME2 (7)                                      NULL,
    [Sintesi]            NVARCHAR (MAX)                                     NULL,
    [DataCreazione]      DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]           INT                                                NULL,
    [DataModifica]       DATETIME2 (7)                                      NULL,
    [ModificatoDa]       INT                                                NULL,
    [DataCancellazione]  DATETIME2 (7)                                      NULL,
    [CancellatoDa]       INT                                                NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [StatoVerbaleId]     INT                                                NOT NULL,
    CONSTRAINT [PK_Verbale] PRIMARY KEY CLUSTERED ([VerbaleId] ASC),
    CONSTRAINT [CK_Verbale_Date] CHECK ([DataApprovazione] IS NULL OR [DataApprovazione]>=[DataRedazione]),
    CONSTRAINT [FK_Verbale_Documento] FOREIGN KEY ([DocumentoId]) REFERENCES [Documentale].[Documento] ([DocumentoId]),
    CONSTRAINT [FK_Verbale_Evento] FOREIGN KEY ([EventoId]) REFERENCES [Eventi].[Evento] ([EventoId]),
    CONSTRAINT [FK_Verbale_StatoVerbale] FOREIGN KEY ([StatoVerbaleId]) REFERENCES [Tipologica].[StatoVerbale] ([StatoVerbaleId]),
    CONSTRAINT [UQ_Verbale_Documento] UNIQUE NONCLUSTERED ([DocumentoId] ASC),
    CONSTRAINT [UQ_Verbale_Evento] UNIQUE NONCLUSTERED ([EventoId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Eventi].[VerbaleStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_Verbale_StatoVerbaleId]
    ON [Eventi].[Verbale]([StatoVerbaleId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'Sintesi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Verbale","column":"DocumentoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Documentale.Documento.DocumentoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Verbale;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataApprovazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Verbale strutturato associato a un evento e al relativo documento.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'Sintesi';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'VerbaleId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Verbale","column":"DataRedazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataRedazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Verbale","temporal":true,"temporal_type":2,"history_table":"Eventi.VerbaleStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Verbale;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataRedazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Verbale;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'VerbaleId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataRedazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Verbale;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'VerbaleId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Verbale","column":"VerbaleId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'VerbaleId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'Sintesi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataApprovazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataRedazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Verbale","column":"EventoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Eventi.Evento.EventoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Verbale","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Verbale;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Verbale;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Verbale","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Verbale","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Data di business da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataRedazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Verbale;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Verbale;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Verbale","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataRedazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'eventi;verbale;csa;documentale', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Data di business da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataApprovazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'Sintesi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataApprovazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Verbale;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Verbale;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Verbale","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Verbale;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Verbale","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Verbale;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataApprovazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Verbale","column":"DataApprovazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataApprovazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Verbale;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'Sintesi';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'VerbaleId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Verbale","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Verbale","column":"Sintesi","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'Sintesi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Verbale', @level2type = N'COLUMN', @level2name = N'VerbaleId';


GO

