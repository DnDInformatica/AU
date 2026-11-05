CREATE TABLE [Accreditamento].[TipoUnitaOrganizzativaAccredia] (
    [TipoUnitaOrganizzativaAccrediaId] INT                                                NOT NULL,
    [Codice]                           NVARCHAR (50)                                      NOT NULL,
    [Descrizione]                      NVARCHAR (500)                                     NULL,
    [EsplicazioneMasNormativa]         NVARCHAR (MAX)                                     NULL,
    [PuoAvereResponsabilita]           BIT                                                DEFAULT ((0)) NOT NULL,
    [PuoSvolgerAttivitaAccreditate]    BIT                                                DEFAULT ((0)) NOT NULL,
    [PuoAvereFunzioniTecniche]         BIT                                                DEFAULT ((0)) NOT NULL,
    [EsempreSottoAudit]                BIT                                                DEFAULT ((0)) NOT NULL,
    [DataCreazione]                    DATETIME2 (7)                                      DEFAULT (sysdatetime()) NOT NULL,
    [DataModifica]                     DATETIME2 (7)                                      DEFAULT (sysdatetime()) NOT NULL,
    [CreatoDa]                         INT                                                NULL,
    [ModificatoDa]                     INT                                                NULL,
    [DataCancellazione]                DATETIME2 (7)                                      NULL,
    [CancellatoDa]                     INT                                                NULL,
    [DataInizioValidita]               DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]                 DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_TipoUnitaOrganizzativaAccredia] PRIMARY KEY CLUSTERED ([TipoUnitaOrganizzativaAccrediaId] ASC),
    CONSTRAINT [UQ_TipoUnitaOrganizzativaAccredia_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Accreditamento].[TipoUnitaOrganizzativaAccrediaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo di dominio EsempreSottoAudit.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'EsempreSottoAudit';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ASSOCIAZIONE', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"TipoUnitaOrganizzativaAccredia","column":"PuoAvereFunzioniTecniche","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'PuoAvereFunzioniTecniche';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"TipoUnitaOrganizzativaAccredia","column":"Codice","data_type":"nvarchar","max_length":100,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"TipoUnitaOrganizzativaAccredia","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:TipoUnitaOrganizzativaAccredia;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'EsempreSottoAudit';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'TipoUnitaOrganizzativaAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:TipoUnitaOrganizzativaAccredia;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'PuoSvolgerAttivitaAccreditate';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'PuoAvereFunzioniTecniche';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:TipoUnitaOrganizzativaAccredia;PK;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'TipoUnitaOrganizzativaAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"TipoUnitaOrganizzativaAccredia","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo di dominio PuoAvereResponsabilita.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'PuoAvereResponsabilita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'PuoAvereResponsabilita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"TipoUnitaOrganizzativaAccredia","column":"EsplicazioneMasNormativa","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'EsplicazioneMasNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:TipoUnitaOrganizzativaAccredia;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"TipoUnitaOrganizzativaAccredia","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"TipoUnitaOrganizzativaAccredia","entity":"TipoUnitaOrganizzativaAccredia","temporal":true,"temporal_type":2,"history_table":"Accreditamento.TipoUnitaOrganizzativaAccrediaStorico","doc":{"ms_description":"MS_Description","extended_doc":"Accredia.Doc","model_note":"Accredia.ModelNote"}}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'PuoAvereResponsabilita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'EsplicazioneMasNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'EsempreSottoAudit';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tabella dominio Accreditamento con gestione audit, soft-delete e system-versioning dove previsto.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:TipoUnitaOrganizzativaAccredia;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"TipoUnitaOrganizzativaAccredia","column":"TipoUnitaOrganizzativaAccrediaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'TipoUnitaOrganizzativaAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo di dominio PuoAvereFunzioniTecniche.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'PuoAvereFunzioniTecniche';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:TipoUnitaOrganizzativaAccredia;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'EsempreSottoAudit';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice identificativo funzionale nel perimetro del processo regolatorio.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"TipoUnitaOrganizzativaAccredia","column":"PuoSvolgerAttivitaAccreditate","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'PuoSvolgerAttivitaAccreditate';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:TipoUnitaOrganizzativaAccredia;Nullable', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'PuoAvereFunzioniTecniche';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"TipoUnitaOrganizzativaAccredia","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"TipoUnitaOrganizzativaAccredia","column":"Descrizione","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:TipoUnitaOrganizzativaAccredia;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'PuoAvereResponsabilita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'EsplicazioneMasNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo di dominio EsplicazioneMasNormativa.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'EsplicazioneMasNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'PuoSvolgerAttivitaAccreditate';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:TipoUnitaOrganizzativaAccredia;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"TipoUnitaOrganizzativaAccredia","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'TipoUnitaOrganizzativaAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'PuoAvereFunzioniTecniche';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'accreditamento;processi;audit;compliance', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"TipoUnitaOrganizzativaAccredia","column":"EsempreSottoAudit","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'EsempreSottoAudit';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:TipoUnitaOrganizzativaAccredia;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'PuoAvereFunzioniTecniche';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco del record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'TipoUnitaOrganizzativaAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'TipoUnitaOrganizzativaAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:TipoUnitaOrganizzativaAccredia;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"TipoUnitaOrganizzativaAccredia","column":"PuoAvereResponsabilita","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'PuoAvereResponsabilita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'EsplicazioneMasNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:TipoUnitaOrganizzativaAccredia;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo di dominio PuoSvolgerAttivitaAccreditate.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'PuoSvolgerAttivitaAccreditate';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:TipoUnitaOrganizzativaAccredia;NotNull', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'PuoSvolgerAttivitaAccreditate';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Accreditamento;Table:TipoUnitaOrganizzativaAccredia;Nullable', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'EsplicazioneMasNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'PuoSvolgerAttivitaAccreditate';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'PuoAvereResponsabilita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione estesa con dettaglio operativo e contestuale.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'EsempreSottoAudit';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Accreditamento","table":"TipoUnitaOrganizzativaAccredia","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'TipoUnitaOrganizzativaAccredia';


GO

