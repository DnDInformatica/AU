CREATE TABLE [Standard].[NormaAccreditamento] (
    [NormaAccreditamentoId]   INT                                                IDENTITY (1, 1) NOT NULL,
    [Codice]                  NVARCHAR (100)                                     NOT NULL,
    [CodiceVersione]          NVARCHAR (20)                                      NULL,
    [Riferimento]             NVARCHAR (200)                                     NOT NULL,
    [TitoloIta]               NVARCHAR (1000)                                    NULL,
    [TitoloEng]               NVARCHAR (1000)                                    NULL,
    [Attivo]                  BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]           DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                INT                                                NULL,
    [DataModifica]            DATETIME2 (7)                                      NULL,
    [ModificatoDa]            INT                                                NULL,
    [DataCancellazione]       DATETIME2 (7)                                      NULL,
    [CancellatoDa]            INT                                                NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [StatoNormaId]            INT                                                DEFAULT ((1)) NOT NULL,
    [TipoNorma]               NVARCHAR (30)                                      DEFAULT ('SchemaCertificazione') NOT NULL,
    [CategoriaFonte]          NVARCHAR (30)                                      DEFAULT ('StandardInternazionale') NOT NULL,
    [DataScadenzaTransizione] DATE                                               NULL,
    [SchemeOwner]             NVARCHAR (200)                                     NULL,
    [DataInizioValidita]      DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]        DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_NormaAccreditamento] PRIMARY KEY CLUSTERED ([NormaAccreditamentoId] ASC),
    CONSTRAINT [CK_NormaAccreditamento_CategoriaFonte] CHECK ([CategoriaFonte]='SchemaPropietario' OR [CategoriaFonte]='QuadroNormativoRiferimento' OR [CategoriaFonte]='NormativaEuropea' OR [CategoriaFonte]='NormativaItaliana' OR [CategoriaFonte]='StandardInternazionale'),
    CONSTRAINT [CK_NormaAccreditamento_Riferimento] CHECK (len(ltrim(rtrim([Riferimento])))>(0)),
    CONSTRAINT [CK_NormaAccreditamento_TipoNorma] CHECK ([TipoNorma]=N'CoRequisitoAccreditamento' OR [TipoNorma]=N'AccreditamentoEnte' OR [TipoNorma]=N'Duplice' OR [TipoNorma]=N'SchemaCertificazione' OR [TipoNorma]=N'AccreditamentoOdC' OR [TipoNorma]=N'NormaProfessionale'),
    CONSTRAINT [FK_NormaAccreditamento_StatoNorma] FOREIGN KEY ([StatoNormaId]) REFERENCES [Standard].[StatoNorma] ([StatoNormaId]),
    CONSTRAINT [UQ_NormaAccreditamento_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[NormaAccreditamentoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamento","column":"TitoloEng","data_type":"nvarchar","max_length":2000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'TitoloEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'StatoNormaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Titolo completo della norma in italiano.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'TitoloIta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Proprietario dello schema di certificazione (Scheme Owner) come definito in ACCREDIA LS-15. NULL per norme pubbliche ISO/UNI/EN senza proprietario specifico. Esempi: AGID (eIDAS/SPID), INVEO (ISDP/SGCMF), ITALCERT (EUSOMA), Commissione Europea (End of Waste).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'SchemeOwner';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stato della norma nel Modello A legacy. Nel target lo stato normativo da usare nei processi deve essere quello di Standard.NormaEdizione.StatoNormaId.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'StatoNormaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine validita business del record legacy nel Modello A. Non deve essere usata come data di ritiro normativo se NormaEdizione.DataRitiro e disponibile.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'TitoloEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamento;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'NormaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'NormaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Titolo completo della norma in inglese.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'TitoloEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'accreditamento,norme,ISO,IEC,UNI,CEN,master-data,versioning', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'NormaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamento","temporal":true,"temporal_type":2,"history_table":"Standard.NormaAccreditamentoStorico","reference":"ISO/IEC/UNI/CEN standards","business_rules":{"riferimento_unique":true,"stato_norma_values":["Vigente","InTransizione","Ritirata"],"governance":"external","versioning":"Standard.NormaAccreditamentoGerarchia"}}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamento;NotNull', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamento","column":"TipoNorma","data_type":"nvarchar","max_length":60,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'TipoNorma';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamento","column":"Attivo","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'CodiceVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamento","column":"CodiceVersione","data_type":"nvarchar","max_length":40,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'CodiceVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamento;NotNull', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice legacy della norma/famiglia nel Modello A. Puo raggruppare piu record che rappresentano edizioni diverse della stessa famiglia normativa. Nel target il concetto equivalente e NormaFamiglia.CodiceFamiglia.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamento","column":"Riferimento","data_type":"nvarchar","max_length":400,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'Riferimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamento;NotNull', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'TipoNorma';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice legacy dell''edizione/versione nel Modello A. Nel target l''edizione deve essere rappresentata da Standard.NormaEdizione, con anno, stato, transizione, ritiro e relazioni normative.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'CodiceVersione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Categoria della fonte normativa/documentale. Valori: QuadroNormativoRiferimento = norme ISO 17000-series che governano i requisiti degli OdC e dell''ente di accreditamento, più i co-requisiti di schema del quadro "come accreditarsi" (ISO/IEC 17011, 17020, 17021, 17024, 17025, 17029, 17034, 17043, 17065 + ISO 14025, 14065, 15189, 15195, 20387) — colonna TipoNorma AccreditamentoOdC, Duplice, AccreditamentoEnte o CoRequisitoAccreditamento; NormativaEuropea = Direttive UE e Regolamenti CE/UE che impongono la certificazione come requisito cogente (es. Dir. 2014/33/UE Ascensori, Dir. 2014/68/UE PED, Reg. CE 1221/2009 EMAS); NormativaItaliana = decreti ministeriali e prassi di riferimento italiane (D.M., UNI/PdR); StandardInternazionale = norme oggetto di certificazione volontaria o cogente da parte degli OdC (ISO 9001, ISO 14001, EN 9100, FSSC 22000, PEFC, ecc.). Referenza sito ACCREDIA: sezione Schemi di Accreditamento — Quadro Normativo di Riferimento vs Standard vs Normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'CategoriaFonte';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento leggibile legacy della norma o schema, spesso comprensivo di edizione. Utile per riconciliazione e pubblicazione, ma non deve sostituire la FK target verso NormaEdizione quando serve determinismo su edizione e transizione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'Riferimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamento","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamento;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'Riferimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamento;NotNull', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'TitoloIta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamento","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamento","column":"StatoNormaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Standard.StatoNorma.StatoNormaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'StatoNormaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamento","column":"TitoloIta","data_type":"nvarchar","max_length":2000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'TitoloIta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Validita business del record legacy nel Modello A. Non coincide necessariamente con data di pubblicazione, entrata in vigore, transizione o ritiro della norma; tali date appartengono al Modello B in NormaEdizione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'TitoloEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamento;Nullable', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'TitoloIta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'StatoNormaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamento;Nullable', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'TitoloEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamento","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'TitoloEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamento;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'StatoNormaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamento","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'NormaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'TipoNorma';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamento","column":"NormaAccreditamentoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'NormaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Catalogo norme e standard tecnici utilizzati negli accreditamenti. Ogni versione è un''entità distinta con proprio stato e ciclo di vita. Riferimento normativo europeo: Reg. CE 765/2008 art. 5 — l''accreditamento si basa su norme armonizzate EN ISO/IEC 17000-series; Reg. CE 1221/2009 (EMAS III) artt. 4–5 — norma specifica per verificatori EMAS (ISO 14065 + EA-6/03); Reg. UE 2021/1119 (European Climate Law) art. 10 — V&V inventari GHG; Dir. 2003/87/CE art. 15 — verifica emissioni EU ETS (ISO 14065, ISO 14064-3). La colonna TipoNorma distingue: AccreditamentoOdC (norme orizzontali ISO 17000-series), SchemaCertificazione (norme oggetto di certificazione), Duplice (entrambi i ruoli).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'LOOKUP', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'TipoNorma';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamento","column":"Codice","data_type":"nvarchar","max_length":200,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata del Modello A legacy. In questa tabella ogni record puo rappresentare una specifica versione/edizione di norma o schema. Il target normalizzato e Standard.NormaFamiglia -> Standard.NormaEdizione; usare questa chiave solo per compatibilita, mapping, migrazione e sorgenti legacy.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'NormaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'CodiceVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'TipoNorma';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di attività: 1 = norma selezionabile, 0 = disattivata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamento","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamento","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'CodiceVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'Riferimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Standard","table":"NormaAccreditamento","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'Riferimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamento;Nullable', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'CodiceVersione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'TitoloIta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'StatoNormaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Standard;Table:NormaAccreditamento;NotNull', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'Riferimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Classifica la norma in base al suo ruolo nell''ecosistema di accreditamento. AccreditamentoOdC = norma orizzontale IAF che disciplina i requisiti dell''organismo accreditato (es. ISO/IEC 17021-1 per OdC sistemi di gestione, ISO/IEC 17020 per organismi di ispezione); SchemaCertificazione = norma oggetto dell''attività di certificazione/ispezione dell''OdC accreditato (es. ISO 9001, ISO 14001); Duplice = norma che svolge entrambi i ruoli simultaneamente, tipica dei laboratori (es. ISO/IEC 17025 è sia norma di accreditamento LAB/LT sia standard tecnico operativo); AccreditamentoEnte = norma che disciplina i requisiti dell''ente di accreditamento stesso, livello L1 del modello ACC24001 (es. ISO/IEC 17011): non è una norma contro cui ACCREDIA accredita i CAB, ma quella rispetto alla quale ACCREDIA opera ed è valutata nei peer assessment EA/IAF/ILAC; CoRequisitoAccreditamento = documento normativo che integra la norma di accreditamento principale per uno specifico schema, senza essere esso stesso norma di accreditamento dell''organismo (es. ISO 14025 co-requisito di ISO/IEC 17065 per lo schema EPD); il legame con la norma principale è registrato in NormaAccreditamentoRelazione con tipo ''corequisito''.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'TipoNorma';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'TitoloIta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ultimo giorno entro cui un OdC può emettere certificati sulla versione in transizione, secondo calendario IAF. NULL per norme Vigenti e Ritirate. Valorizzato solo quando StatoNormaId=2 (InTransizione). Dopo questa data la norma viene impostata a Ritirata (StatoNormaId=3). Esempio: ISO 55001:2014 → 2027-07-31.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataScadenzaTransizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

