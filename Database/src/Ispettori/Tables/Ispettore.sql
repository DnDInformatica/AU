CREATE TABLE [Ispettori].[Ispettore] (
    [IspettoreId]                  INT                                                IDENTITY (1, 1) NOT NULL,
    [CodiceIspettore]              NVARCHAR (20)                                      NOT NULL,
    [PersonaId]                    INT                                                NOT NULL,
    [IsIspettoreInterno]           BIT                                                DEFAULT ((0)) NOT NULL,
    [IncaricoId]                   INT                                                NULL,
    [DatoreLavoroOrganizzazioneId] INT                                                NULL,
    [TipoRapportoLavoro]           NVARCHAR (30)                                      NULL,
    [TipoRuoloIspettoreId]         INT                                                NOT NULL,
    [StatoIspettoreId]             INT                                                NOT NULL,
    [DataQualifica]                DATE                                               NOT NULL,
    [DataPrimaQualifica]           DATE                                               NULL,
    [DataUltimoRinnovo]            DATE                                               NULL,
    [DataScadenzaQualifica]        DATE                                               NULL,
    [NumeroConvenzione]            NVARCHAR (50)                                      NULL,
    [DataFirmaConvenzione]         DATE                                               NULL,
    [DataScadenzaConvenzione]      DATE                                               NULL,
    [TariffaGiornaliera]           DECIMAL (10, 2)                                    NULL,
    [IBAN]                         NVARCHAR (34)                                      NULL,
    [DisponibilitaMensile]         INT                                                NULL,
    [ZonaGeograficaPreferita]      NVARCHAR (200)                                     NULL,
    [Note]                         NVARCHAR (MAX)                                     NULL,
    [DataCreazione]                DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                     INT                                                NULL,
    [DataModifica]                 DATETIME2 (7)                                      NULL,
    [ModificatoDa]                 INT                                                NULL,
    [DataCancellazione]            DATETIME2 (7)                                      NULL,
    [CancellatoDa]                 INT                                                NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DipendenteId]                 INT                                                NULL,
    [DataInizioValidita]           DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]             DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_Ispettore] PRIMARY KEY CLUSTERED ([IspettoreId] ASC),
    CONSTRAINT [CK_Ispettore_InternoEsterno] CHECK ([IsIspettoreInterno]=(1) AND [DipendenteId] IS NOT NULL AND [DatoreLavoroOrganizzazioneId] IS NULL OR [IsIspettoreInterno]=(0) AND [DipendenteId] IS NULL),
    CONSTRAINT [CK_Ispettore_TipoRapporto] CHECK ([TipoRapportoLavoro]='ALTRO' OR [TipoRapportoLavoro]='PENSIONATO' OR [TipoRapportoLavoro]='UNIVERSITA' OR [TipoRapportoLavoro]='PA' OR [TipoRapportoLavoro]='AUTONOMO' OR [TipoRapportoLavoro]='DIPENDENTE'),
    CONSTRAINT [FK_Ispettore_DatoreLavoro] FOREIGN KEY ([DatoreLavoroOrganizzazioneId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId]),
    CONSTRAINT [FK_Ispettore_Dipendente] FOREIGN KEY ([DipendenteId]) REFERENCES [RisorseUmane].[Dipendente] ([DipendenteId]),
    CONSTRAINT [FK_Ispettore_Incarico] FOREIGN KEY ([IncaricoId]) REFERENCES [Organizzazioni].[Incarico] ([IncaricoId]),
    CONSTRAINT [FK_Ispettore_Persona] FOREIGN KEY ([PersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [FK_Ispettore_Stato] FOREIGN KEY ([StatoIspettoreId]) REFERENCES [Tipologica].[StatoIspettore] ([StatoIspettoreId]),
    CONSTRAINT [FK_Ispettore_TipoRuolo] FOREIGN KEY ([TipoRuoloIspettoreId]) REFERENCES [Tipologica].[TipoRuoloIspettore] ([TipoRuoloIspettoreId]),
    CONSTRAINT [UQ_Ispettore_Codice] UNIQUE NONCLUSTERED ([CodiceIspettore] ASC),
    CONSTRAINT [UQ_Ispettore_Persona] UNIQUE NONCLUSTERED ([PersonaId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Ispettori].[IspettoreStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'ZonaGeograficaPreferita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'TariffaGiornaliera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataQualifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"PersonaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataScadenzaQualifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'IspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"TariffaGiornaliera","data_type":"decimal","max_length":9,"precision":10,"scale":2,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'TariffaGiornaliera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'IncaricoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataScadenzaConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'ZonaGeograficaPreferita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'IncaricoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataScadenzaQualifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataQualifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'TipoRuoloIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'IncaricoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'TipoRuoloIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"IspettoreId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'IspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"DataPrimaQualifica","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataPrimaQualifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"NumeroConvenzione","data_type":"nvarchar","max_length":100,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'NumeroConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'TariffaGiornaliera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"TipoRuoloIspettoreId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.TipoRuoloIspettore.TipoRuoloIspettoreId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'TipoRuoloIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'NumeroConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataPrimaQualifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"Note","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'TariffaGiornaliera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DisponibilitaMensile';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'TipoRapportoLavoro';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'CodiceIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataScadenzaQualifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"DataScadenzaConvenzione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataScadenzaConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'ZonaGeograficaPreferita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"DataQualifica","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataQualifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'IncaricoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"DipendenteId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"RisorseUmane.Dipendente.DipendenteId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'CodiceIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataScadenzaConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DisponibilitaMensile';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataUltimoRinnovo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'IsIspettoreInterno';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataQualifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"IncaricoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Organizzazioni.Incarico.IncaricoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'IncaricoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataScadenzaConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataQualifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'MASTER', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataScadenzaQualifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'TipoRapportoLavoro';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'ZonaGeograficaPreferita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso RisorseUmane.Dipendente. Obbligatorio per ispettori INTERNI.', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"DataScadenzaQualifica","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataScadenzaQualifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'TipoRapportoLavoro';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataScadenzaConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"ZonaGeograficaPreferita","data_type":"nvarchar","max_length":400,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'ZonaGeograficaPreferita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'CodiceIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'CodiceIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;Nullable;PII', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'IBAN';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"DataUltimoRinnovo","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataUltimoRinnovo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DatoreLavoroOrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'StatoIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataFirmaConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'IsIspettoreInterno';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DisponibilitaMensile';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"StatoIspettoreId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.StatoIspettore.StatoIspettoreId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'StatoIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DatoreLavoroOrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'IBAN';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataUltimoRinnovo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"IsIspettoreInterno","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'IsIspettoreInterno';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"DataFirmaConvenzione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataFirmaConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'IsIspettoreInterno';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataFirmaConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataUltimoRinnovo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'StatoIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DisponibilitaMensile';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"TipoRapportoLavoro","data_type":"nvarchar","max_length":60,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'TipoRapportoLavoro';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataUltimoRinnovo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataFirmaConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'TipoRapportoLavoro';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"DisponibilitaMensile","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DisponibilitaMensile';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","temporal":true,"temporal_type":2,"history_table":"Ispettori.IspettoreStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"CodiceIspettore","data_type":"nvarchar","max_length":40,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'CodiceIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'StatoIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"DatoreLavoroOrganizzazioneId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Organizzazioni.Organizzazione.OrganizzazioneId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DatoreLavoroOrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'IBAN';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'NumeroConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'TipoRuoloIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataPrimaQualifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DatoreLavoroOrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'TariffaGiornaliera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataPrimaQualifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'TipoRuoloIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'NumeroConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'IspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'IsIspettoreInterno';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'IBAN';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataFirmaConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'IspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"IBAN","data_type":"nvarchar","max_length":68,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"PII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'IBAN';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'IspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'NumeroConvenzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DatoreLavoroOrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'StatoIspettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Ispettori;Table:Ispettore;Nullable', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'DataPrimaQualifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Ispettori","table":"Ispettore","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Ispettori', @level1type = N'TABLE', @level1name = N'Ispettore', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

