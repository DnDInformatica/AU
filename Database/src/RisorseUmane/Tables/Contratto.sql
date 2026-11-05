CREATE TABLE [RisorseUmane].[Contratto] (
    [ContrattoId]          INT                                                IDENTITY (1, 1) NOT NULL,
    [DipendenteId]         INT                                                NOT NULL,
    [TipoContrattoId]      INT                                                NOT NULL,
    [DataInizio]           DATE                                               NOT NULL,
    [DataFine]             DATE                                               NULL,
    [LivelloInquadramento] NVARCHAR (20)                                      NULL,
    [CCNLApplicato]        NVARCHAR (100)                                     NULL,
    [RAL]                  DECIMAL (12, 2)                                    NULL,
    [PercentualePartTime]  DECIMAL (5, 2)                                     NULL,
    [OreLavoroSettimanali] DECIMAL (5, 2)                                     NULL,
    [IsContrattoCorrente]  BIT                                                DEFAULT ((0)) NOT NULL,
    [Note]                 NVARCHAR (MAX)                                     NULL,
    [DataCreazione]        DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]             INT                                                NULL,
    [DataModifica]         DATETIME2 (7)                                      NULL,
    [ModificatoDa]         INT                                                NULL,
    [DataCancellazione]    DATETIME2 (7)                                      NULL,
    [CancellatoDa]         INT                                                NULL,
    [UniqueRowId]          UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]     DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_Contratto] PRIMARY KEY CLUSTERED ([ContrattoId] ASC),
    CONSTRAINT [CK_Contratto_Date] CHECK ([DataFine] IS NULL OR [DataFine]>=[DataInizio]),
    CONSTRAINT [CK_Contratto_PartTime] CHECK ([PercentualePartTime] IS NULL OR [PercentualePartTime]>(0) AND [PercentualePartTime]<=(100)),
    CONSTRAINT [FK_Contratto_Dipendente] FOREIGN KEY ([DipendenteId]) REFERENCES [RisorseUmane].[Dipendente] ([DipendenteId]),
    CONSTRAINT [FK_Contratto_TipoContratto] FOREIGN KEY ([TipoContrattoId]) REFERENCES [Tipologica].[TipoContratto] ([TipoContrattoId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[RisorseUmane].[ContrattoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'CCNLApplicato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Contratto;Nullable', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'OreLavoroSettimanali';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Contratto","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'OreLavoroSettimanali';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ore lavoro settimanali (es. 40 full-time, 20 part-time 50%).', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'OreLavoroSettimanali';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso RisorseUmane.Dipendente.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Contratto","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'CCNLApplicato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Contratto","column":"CCNLApplicato","data_type":"nvarchar","max_length":200,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'CCNLApplicato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Contratto;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'CCNLApplicato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'IsContrattoCorrente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Contratto","column":"TipoContrattoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.TipoContratto.TipoContrattoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'TipoContrattoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'TipoContrattoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Contratto","column":"IsContrattoCorrente","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'IsContrattoCorrente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'CCNL applicato (es. Commercio, Metalmeccanico).', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'CCNLApplicato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'TipoContrattoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Contratto;Nullable', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'CCNLApplicato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'TipoContrattoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'ContrattoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'LivelloInquadramento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Percentuale part-time (es. 50, 80). NULL per full-time.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'PercentualePartTime';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data scadenza contratto. NULL per tempo indeterminato.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Contratto;Nullable', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'PercentualePartTime';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Storico contratti di lavoro dei dipendenti ACCREDIA. Relazione 1:N con Dipendente.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'ContrattoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'OreLavoroSettimanali';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'LivelloInquadramento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Contratto","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Contratto","column":"ContrattoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'ContrattoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Contratto","column":"LivelloInquadramento","data_type":"nvarchar","max_length":40,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'LivelloInquadramento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Contratto;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'ContrattoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Contratto","column":"OreLavoroSettimanali","data_type":"decimal","max_length":5,"precision":5,"scale":2,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'OreLavoroSettimanali';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'LivelloInquadramento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Contratto;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogate auto-incrementale.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'ContrattoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'ContrattoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Livello di inquadramento CCNL (es. Q, 1, 2, 3S, 3, 4, 5).', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'LivelloInquadramento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Contratto;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Contratto","column":"DipendenteId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"RisorseUmane.Dipendente.DipendenteId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Contratto;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Contratto;Nullable', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'LivelloInquadramento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'OreLavoroSettimanali';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Contratto","column":"Note","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retribuzione Annua Lorda. DATO SENSIBILE con accesso ristretto.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'RAL';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data decorrenza contratto.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Contratto;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Contratto","column":"DataFine","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Contratto;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Contratto","column":"PercentualePartTime","data_type":"decimal","max_length":5,"precision":5,"scale":2,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'PercentualePartTime';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'PercentualePartTime';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'PercentualePartTime';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{

        "schema": "RisorseUmane",

        "table": "Contratto",

        "entity": "Contratto",

        "temporal": true,

        "temporal_type": 2,

        "history_table": "RisorseUmane.ContrattoStorico",

        "business_rules": {

            "one_current_per_employee": true,

            "end_date_required_for": ["DET", "APPRENDISTATO", "SOMMINISTRAZIONE", "STAGE"]

        },

        "gdpr": {

            "contains_pii": true,

            "sensitive_columns": ["RAL"],

            "retention_years": 10,

            "access_restricted": true

        },

        "reference": "CCNL Commercio / Regolamento del Personale"

    }', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'MASTER', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Contratto","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Contratto","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'risorse-umane,contratto,retribuzione,gdpr,sensibile', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Contratto;Nullable', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Contratto;Nullable', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'PercentualePartTime';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'RAL';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Contratto;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Tipologica.TipoContratto. INDET, DET, APPRENDISTATO, etc.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'TipoContrattoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Contratto;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'IsContrattoCorrente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Contratto;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'TipoContrattoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'IsContrattoCorrente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Contratto","column":"RAL","data_type":"decimal","max_length":9,"precision":12,"scale":2,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'RAL';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Contratto","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'TRUE se è il contratto attualmente in vigore per il dipendente.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'IsContrattoCorrente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'RAL';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Contratto","column":"DataInizio","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Contratto;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'IsContrattoCorrente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'RAL';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Contratto","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Contratto;Nullable', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'RAL';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Contratto;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Contratto', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

