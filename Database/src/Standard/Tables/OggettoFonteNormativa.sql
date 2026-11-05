CREATE TABLE [Standard].[OggettoFonteNormativa] (
    [OggettoFonteNormativaId] INT                                                IDENTITY (1, 1) NOT NULL,
    [OggettoSchema]           NVARCHAR (128)                                     NOT NULL,
    [OggettoNome]             NVARCHAR (256)                                     NOT NULL,
    [OggettoColonna]          NVARCHAR (256)                                     NULL,
    [NormaAccreditamentoId]   INT                                                NULL,
    [FonteEsterna]            NVARCHAR (300)                                     NULL,
    [Clausola]                NVARCHAR (100)                                     NULL,
    [FonteDocumentoCorpus]    NVARCHAR (50)                                      NULL,
    [FonteDocumentoCodice]    NVARCHAR (100)                                     NULL,
    [FonteDocumentoId]        INT                                                NULL,
    [TipoRelazione]           NVARCHAR (30)                                      DEFAULT (N'Riferimento') NOT NULL,
    [Note]                    NVARCHAR (MAX)                                     NULL,
    [DataCreazione]           DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                INT                                                NULL,
    [DataModifica]            DATETIME2 (7)                                      NULL,
    [ModificatoDa]            INT                                                NULL,
    [DataCancellazione]       DATETIME2 (7)                                      NULL,
    [CancellatoDa]            INT                                                NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]      DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_OggettoFonteNormativa_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]        DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_OggettoFonteNormativa_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_OggettoFonteNormativa] PRIMARY KEY CLUSTERED ([OggettoFonteNormativaId] ASC),
    CONSTRAINT [CK_OggettoFonteNormativa_Fonte] CHECK ([NormaAccreditamentoId] IS NOT NULL OR [FonteEsterna] IS NOT NULL OR [FonteDocumentoCodice] IS NOT NULL),
    CONSTRAINT [CK_OggettoFonteNormativa_TipoRelazione] CHECK ([TipoRelazione]=N'Riferimento' OR [TipoRelazione]=N'Vincola' OR [TipoRelazione]=N'Implementa'),
    CONSTRAINT [FK_OggettoFonteNormativa_NormaAccreditamentoId] FOREIGN KEY ([NormaAccreditamentoId]) REFERENCES [Standard].[NormaAccreditamento] ([NormaAccreditamentoId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[OggettoFonteNormativaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_OggettoFonteNormativa_Active]
    ON [Standard].[OggettoFonteNormativa]([DataCancellazione] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_OggettoFonteNormativa_NormaAccreditamentoId]
    ON [Standard].[OggettoFonteNormativa]([NormaAccreditamentoId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete)', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Colonna specifica dell''oggetto; NULL indica riferimento a livello di tabella', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'OggettoColonna';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Colonna tecnica hidden di inizio periodo SYSTEM_VERSIONING SQL Server. Non rappresenta validita'' normativa, applicabilita'' o decorrenza business.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Clausola o punto della fonte; seed per futura estensione a requisiti puntuali', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'Clausola';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Soft-ref al documento_id (chiave stabile di revisione nel corpus AI-expert); nessuna FK cross-DB', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'FonteDocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema": "Standard", "table": "OggettoFonteNormativa", "entity": "OggettoFonteNormativa", "temporal": true, "history_table": "Standard.OggettoFonteNormativaStorico", "soft_delete": true, "audit": true, "doc": "Ponte di tracciabilita oggetto->fonte normativa/documentale", "purpose": "Tracciabilita della fonte normativa/documentale degli oggetti del modello dati SIDAC", "reference": "Framework governance ACCREDIA - convenzione fonte normativa", "integrations": {"norma": "Standard.NormaAccreditamento (FK strutturata)", "corpus": "accredia-ai-expert (soft-ref: Corpus/Codice/Id, senza FK cross-DB)"}, "business_rules": {"almeno_una_fonte": "NormaAccreditamentoId OR FonteEsterna OR FonteDocumentoCodice", "tipo_relazione_values": ["Implementa", "Vincola", "Riferimento"], "corpus_ref_soft": "riferimento debole al corpus documentale, senza integrita referenziale cross-DB"}}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Colonna tecnica hidden di fine periodo SYSTEM_VERSIONING SQL Server. Non rappresenta validita'' normativa, applicabilita'' o decorrenza business.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Soft-ref al corpus documentale AI-expert (es. Accredia.Documento, Cataloghi UNI); nessuna FK cross-DB', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'FonteDocumentoCorpus';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ASSOCIAZIONE', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Natura della relazione oggetto-fonte: Implementa, Vincola oppure Riferimento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'TipoRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria identificativa di oggetto fonte normativa', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'OggettoFonteNormativaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Soft-ref al codice documento nel corpus (es. RG-01, RT-35); nessuna FK cross-DB', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'FonteDocumentoCodice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'governance,tracciabilita,fonte-normativa,requisiti', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note e annotazioni sulla relazione oggetto-fonte', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Schema dell''oggetto SIDAC a cui si riferisce la fonte normativa', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'OggettoSchema';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fonte normativa strutturata: FK a Standard.NormaAccreditamento (norma ISO/IEC/UNI/CEN)', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'NormaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ponte di tracciabilità tra oggetti del modello dati SIDAC (schema/tabella/colonna) e la relativa fonte normativa o documentale (norma di accreditamento, fonte esterna, documento del corpus).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nome dell''oggetto (tabella o vista) a cui si riferisce la fonte normativa', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'OggettoNome';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fonte normativa esterna non catalogata come norma di accreditamento (legge, regolamento UE, GDPR, delibera)', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'FonteEsterna';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'GUID univoco del record per identificazione distribuita', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativa', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

