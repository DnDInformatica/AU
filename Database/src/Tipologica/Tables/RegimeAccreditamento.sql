CREATE TABLE [Tipologica].[RegimeAccreditamento] (
    [RegimeAccreditamentoId] TINYINT                                            NOT NULL,
    [Codice]                 NVARCHAR (20)                                      NOT NULL,
    [Descrizione]            NVARCHAR (200)                                     NOT NULL,
    [Attivo]                 BIT                                                DEFAULT ((1)) NOT NULL,
    [UniqueRowId]            UNIQUEIDENTIFIER                                   DEFAULT (newsequentialid()) NOT NULL,
    [DataCreazione]          DATETIME2 (7)                                      DEFAULT (getdate()) NOT NULL,
    [CreatoDa]               INT                                                NULL,
    [DataModifica]           DATETIME2 (7)                                      NULL,
    [ModificatoDa]           INT                                                NULL,
    [DataCancellazione]      DATETIME2 (7)                                      NULL,
    [CancellatoDa]           INT                                                NULL,
    [DataInizioValidita]     DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_RegimeAccreditamento] PRIMARY KEY CLUSTERED ([RegimeAccreditamentoId] ASC),
    CONSTRAINT [UQ_RegimeAccreditamento_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Tipologica].[RegimeAccreditamentoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"RegimeAccreditamento","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:RegimeAccreditamento;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tabella tipologica che classifica il regime di applicazione di una norma di accreditamento rispetto a uno schema. Distingue tra accreditamento su base volontaria, cogente (obbligatorio per legge) o misto. Il regime è attributo della relazione norma-schema (NormaAccreditamentoSchema), non della norma né dello schema in isolamento. Riferimento normativo europeo: Decisione 768/2008/CE (NLF) Allegato II — il ricorso agli OdC accreditati è cogente per prodotti soggetti a marcatura CE; Dir. 2003/87/CE art. 15 + Reg. 600/2012 — la verifica delle emissioni ETS è cogente per impianti soggetti (schemi GHG e V&V); Reg. UE 2017/625 artt. 37–43 — laboratori ufficiali per controlli alimentari devono essere accreditati (regime cogente per LAB/MED).', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'RegimeAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"RegimeAccreditamento","column":"RegimeAccreditamentoId","data_type":"tinyint","max_length":1,"precision":3,"scale":0,"nullable":false,"identity":false,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'RegimeAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record. FK verso tabella utenti applicativi.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:RegimeAccreditamento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di attività del record. 1 = attivo, 0 = disattivato (soft delete logico).', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora di inserimento del record.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Etichetta leggibile del regime di accreditamento.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:RegimeAccreditamento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:RegimeAccreditamento;PK;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'RegimeAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha eseguito la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"RegimeAccreditamento","column":"Attivo","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'LOOKUP', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"RegimeAccreditamento","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:RegimeAccreditamento;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:RegimeAccreditamento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'RegimeAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice breve del regime. Valori: VOL (Volontario), COG (Cogente), MIS (Misto).', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:RegimeAccreditamento;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"RegimeAccreditamento","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora dell''ultima modifica al record.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:RegimeAccreditamento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"RegimeAccreditamento","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'RegimeAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"RegimeAccreditamento","column":"Descrizione","data_type":"nvarchar","max_length":400,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di cancellazione logica. NULL = record attivo. Valorizzata = soft delete.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"RegimeAccreditamento","temporal":true,"pattern":"lookup","pk_type":"tinyint","domain":["VOL","COG","MIS"],"used_in":"Standard.NormaAccreditamentoSchema.RegimeAccreditamentoId","business_rule":"il regime è attributo della relazione norma-schema, non della norma né dello schema isolato"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:RegimeAccreditamento;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:RegimeAccreditamento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"RegimeAccreditamento","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:RegimeAccreditamento;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"RegimeAccreditamento","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata tinyint. Dominio fisso: 1=Volontario, 2=Cogente, 3=Misto.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'RegimeAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'accreditamento,regime,volontario,cogente,misto,lookup,tipologica,GHG,EU-ETS,norma', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco GUID per la riga. Generato automaticamente (NEWSEQUENTIALID). Usato per sincronizzazione e replica.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"RegimeAccreditamento","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"RegimeAccreditamento","column":"Codice","data_type":"nvarchar","max_length":40,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'RegimeAccreditamento', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

