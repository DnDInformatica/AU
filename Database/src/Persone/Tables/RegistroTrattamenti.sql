CREATE TABLE [Persone].[RegistroTrattamenti] (
    [RegistroTrattamentiId]      INT                                                IDENTITY (1, 1) NOT NULL,
    [Codice]                     NVARCHAR (30)                                      NOT NULL,
    [NomeTrattamento]            NVARCHAR (200)                                     NOT NULL,
    [Descrizione]                NVARCHAR (MAX)                                     NULL,
    [TipoFinalitaTrattamentoId]  INT                                                NOT NULL,
    [BaseGiuridica]              NVARCHAR (30)                                      NOT NULL,
    [CategorieDati]              NVARCHAR (500)                                     NOT NULL,
    [CategorieInteressati]       NVARCHAR (500)                                     NOT NULL,
    [DatiParticolari]            BIT                                                DEFAULT ((0)) NOT NULL,
    [DatiGiudiziari]             BIT                                                DEFAULT ((0)) NOT NULL,
    [CategorieDestinatari]       NVARCHAR (500)                                     NULL,
    [TrasferimentoExtraUE]       BIT                                                DEFAULT ((0)) NOT NULL,
    [PaesiExtraUE]               NVARCHAR (200)                                     NULL,
    [GaranzieExtraUE]            NVARCHAR (200)                                     NULL,
    [TermineConservazione]       NVARCHAR (100)                                     NOT NULL,
    [TermineConservazioneGiorni] INT                                                NULL,
    [MisureSicurezza]            NVARCHAR (MAX)                                     NULL,
    [ResponsabileTrattamentoId]  INT                                                NULL,
    [ContitolareId]              INT                                                NULL,
    [DPONotificato]              BIT                                                DEFAULT ((0)) NOT NULL,
    [Stato]                      NVARCHAR (20)                                      DEFAULT ('ATTIVO') NOT NULL,
    [DataInizioTrattamento]      DATE                                               NOT NULL,
    [DataFineTrattamento]        DATE                                               NULL,
    [DataCreazione]              DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                   INT                                                NULL,
    [DataModifica]               DATETIME2 (7)                                      NULL,
    [ModificatoDa]               INT                                                NULL,
    [DataCancellazione]          DATETIME2 (7)                                      NULL,
    [CancellatoDa]               INT                                                NULL,
    [UniqueRowId]                UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]         DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]           DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_RegistroTrattamenti] PRIMARY KEY CLUSTERED ([RegistroTrattamentiId] ASC),
    CONSTRAINT [CK_RegistroTrattamenti_BaseGiuridica] CHECK ([BaseGiuridica]='ART6_1_F' OR [BaseGiuridica]='ART6_1_E' OR [BaseGiuridica]='ART6_1_D' OR [BaseGiuridica]='ART6_1_C' OR [BaseGiuridica]='ART6_1_B' OR [BaseGiuridica]='ART6_1_A'),
    CONSTRAINT [CK_RegistroTrattamenti_Stato] CHECK ([Stato]='CESSATO' OR [Stato]='SOSPESO' OR [Stato]='ATTIVO'),
    CONSTRAINT [FK_RegistroTrattamenti_Finalita] FOREIGN KEY ([TipoFinalitaTrattamentoId]) REFERENCES [Tipologica].[TipoFinalitaTrattamento] ([TipoFinalitaTrattamentoId]),
    CONSTRAINT [FK_RegistroTrattamenti_Responsabile] FOREIGN KEY ([ResponsabileTrattamentoId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [UK_RegistroTrattamenti_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Persone].[RegistroTrattamentiStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CategorieDati';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DatiGiudiziari';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'MisureSicurezza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TipoFinalitaTrattamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Misure di sicurezza tecniche e organizzative adottate per il trattamento. GDPR art. 32: il titolare adotta misure adeguate al rischio (pseudonimizzazione, cifratura, continuità operativa, test di sicurezza). Art. 30 §1 lett. g: le misure di sicurezza devono essere descritte nel registro. Descrivere per categoria: CRITTOGRAFIA / PSEUDONIMIZZAZIONE / CONTROLLO_ACCESSI / BACKUP / AUDIT_LOG.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'MisureSicurezza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DPONotificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DatiParticolari';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'BaseGiuridica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"DataInizioTrattamento","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataInizioTrattamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataFineTrattamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'ResponsabileTrattamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"PaesiExtraUE","data_type":"nvarchar","max_length":400,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'PaesiExtraUE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DPONotificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'GaranzieExtraUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CategorieInteressati';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'NomeTrattamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"RegistroTrattamentiId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'RegistroTrattamentiId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CategorieDestinatari';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TermineConservazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","entity":"RegistroTrattamenti","temporal":true,"temporal_type":2,"history_table":"Persone.RegistroTrattamentiStorico","doc":{"ms_description":"MS_Description","extended_doc":"Accredia.Doc","model_note":"Accredia.ModelNote"}}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'GaranzieExtraUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TrasferimentoExtraUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TipoFinalitaTrattamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TermineConservazioneGiorni';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DatiGiudiziari';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Categorie di dati personali trattati. GDPR art. 30 §1 lett. c: il registro deve indicare le categorie di dati. Art. 4 §1: dato personale = qualsiasi informazione relativa a persona fisica identificata o identificabile. Elencare per categoria: ANAGRAFICI / CONTATTO / FISCALI / PROFESSIONALI / BIOMETRICI (se applicabile).', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CategorieDati';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'ContitolareId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataFineTrattamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CategorieDestinatari';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TrasferimentoExtraUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"GaranzieExtraUE","data_type":"nvarchar","max_length":400,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'GaranzieExtraUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TermineConservazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'ResponsabileTrattamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag che indica se il trattamento include dati giudiziari. GDPR art. 10: i dati relativi a condanne penali e reati possono essere trattati solo sotto il controllo dell''autorità pubblica o sulla base del diritto dell''Unione/dello Stato membro. In Italia: D.Lgs. 196/2003 art. 2-octies. Richiede autorizzazione specifica del Garante.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DatiGiudiziari';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'BaseGiuridica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Termine di conservazione dei dati (descrizione testuale). GDPR art. 5 §1 lett. e — limitazione della conservazione: i dati non devono essere conservati in forma identificabile per un periodo superiore a quello necessario alle finalità. Art. 30 §1 lett. f: il termine deve essere documentato nel registro. Valorizzare con descrizione (es. "10 anni dalla cessazione del rapporto contrattuale").', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TermineConservazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CategorieInteressati';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'ContitolareId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'RegistroTrattamentiId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TermineConservazioneGiorni';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'MisureSicurezza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"CategorieDati","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CategorieDati';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DatiGiudiziari';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ASSOCIAZIONE', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"DataFineTrattamento","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataFineTrattamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"DatiParticolari","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DatiParticolari';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"TipoFinalitaTrattamentoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.TipoFinalitaTrattamento.TipoFinalitaTrattamentoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TipoFinalitaTrattamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'ResponsabileTrattamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DPONotificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CategorieInteressati';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'GaranzieExtraUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TrasferimentoExtraUE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag trasferimento dati verso paesi extra-UE. GDPR artt. 44–49: il trasferimento di dati personali verso un paese terzo è consentito solo se: a) decisione di adeguatezza della Commissione UE (art. 45), b) garanzie appropriate (art. 46: BCR, clausole contrattuali tipo), c) deroghe specifiche (art. 49). Richiede valorizzazione di PaesiExtraUE e GaranzieExtraUE.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TrasferimentoExtraUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'PaesiExtraUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'BaseGiuridica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"ContitolareId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'ContitolareId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"CategorieDestinatari","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CategorieDestinatari';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataInizioTrattamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"TermineConservazioneGiorni","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TermineConservazioneGiorni';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Registro delle attività di trattamento dati personali ai sensi del GDPR. Riferimento normativo europeo: Reg. UE 2016/679 (GDPR) art. 30 — obbligo per titolari con più di 250 dipendenti (e in ogni caso per trattamenti non occasionali) di tenere un registro delle attività di trattamento con: finalità, categorie di interessati/dati, destinatari, trasferimenti verso paesi terzi, misure di sicurezza. ACCREDIA come titolare tratta dati di persone fisiche (ispettori, referenti OdC, dipendenti).', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TermineConservazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"NomeTrattamento","data_type":"nvarchar","max_length":400,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"PII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'NomeTrattamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'BaseGiuridica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'NomeTrattamento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'PaesiExtraUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'PaesiExtraUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'RegistroTrattamentiId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"TrasferimentoExtraUE","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TrasferimentoExtraUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'GaranzieExtraUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DPONotificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'ResponsabileTrattamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CategorieInteressati';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"Codice","data_type":"nvarchar","max_length":60,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CategorieDestinatari';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TermineConservazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CategorieDati';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DatiGiudiziari';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataInizioTrattamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TermineConservazioneGiorni';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'ContitolareId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"MisureSicurezza","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'MisureSicurezza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TipoFinalitaTrattamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"DPONotificato","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DPONotificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DatiParticolari';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Base giuridica del trattamento. GDPR art. 6 — liceità del trattamento: ogni trattamento deve avere una base giuridica esplicita tra: a) consenso, b) esecuzione contratto, c) obbligo legale, d) interesse vitale, e) compito pubblico, f) legittimo interesse. Art. 30 §1 lett. b: la base giuridica deve essere documentata nel registro. Valorizzare con codice standard: CONSENSO / CONTRATTO / OBBLIGO_LEGALE / INTERESSE_VITALE / COMPITO_PUBBLICO / LEGITTIMO_INTERESSE.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'BaseGiuridica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;NotNull;PII', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'NomeTrattamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'RegistroTrattamentiId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'ResponsabileTrattamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataInizioTrattamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'PaesiExtraUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CategorieInteressati';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataFineTrattamento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CategorieDati';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'NomeTrattamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'MisureSicurezza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag che indica se il trattamento include dati particolari (categorie speciali). GDPR art. 9: dati particolari = origine razziale/etnica, opinioni politiche, credenze religiose/filosofiche, appartenenza sindacale, dati genetici, biometrici, sanitari, vita/orientamento sessuale. Il trattamento richiede una delle condizioni ex art. 9 §2 (es. consenso esplicito, obbligo legale, interesse pubblico rilevante).', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DatiParticolari';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'RegistroTrattamentiId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DPONotificato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"ResponsabileTrattamentoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'ResponsabileTrattamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TipoFinalitaTrattamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DatiParticolari';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"TermineConservazione","data_type":"nvarchar","max_length":200,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TermineConservazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataInizioTrattamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'ContitolareId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"BaseGiuridica","data_type":"nvarchar","max_length":60,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'BaseGiuridica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"CategorieInteressati","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CategorieInteressati';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CategorieDestinatari';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'PaesiExtraUE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataFineTrattamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TrasferimentoExtraUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'GaranzieExtraUE';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CategorieDestinatari';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TermineConservazioneGiorni';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"Stato","data_type":"nvarchar","max_length":40,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'NomeTrattamento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'RegistroTrattamentiId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"Descrizione","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'persone;anagrafica;audit;compliance', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"DatiGiudiziari","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DatiGiudiziari';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Termine di conservazione in giorni (valore numerico per calcoli automatici). GDPR art. 5 §1 lett. e. Usato dal sistema per calcolare la data di scadenza dei dati e triggherare i processi di cancellazione/anonimizzazione automatica. NULL = termine non quantificabile in giorni (es. "fino alla revoca del consenso").', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TermineConservazioneGiorni';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'TipoFinalitaTrattamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'CategorieDati';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'ContitolareId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataInizioTrattamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RegistroTrattamenti","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DatiParticolari';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'DataFineTrattamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RegistroTrattamenti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RegistroTrattamenti', @level2type = N'COLUMN', @level2name = N'MisureSicurezza';


GO

