CREATE TABLE [Certificazione].[ProgrammaCertificazione] (
    [ProgrammaCertificazioneId]   INT                                                IDENTITY (1, 1) NOT NULL,
    [Codice]                      NVARCHAR (50)                                      NOT NULL,
    [Nome]                        NVARCHAR (255)                                     NOT NULL,
    [Descrizione]                 NVARCHAR (1000)                                    NULL,
    [NormaAccreditamentoSchemaId] INT                                                NOT NULL,
    [ProprietarioSchema]          NVARCHAR (100)                                     NULL,
    [CodiceSchemaProprietario]    NVARCHAR (100)                                     NULL,
    [TipoProgramma]               NVARCHAR (50)                                      NOT NULL,
    [Attivo]                      BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]               DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                    INT                                                NULL,
    [DataModifica]                DATETIME2 (7)                                      NULL,
    [ModificatoDa]                INT                                                NULL,
    [DataCancellazione]           DATETIME2 (7)                                      NULL,
    [CancellatoDa]                INT                                                NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]          DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_ProgrammaCertificazione_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]            DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_ProgrammaCertificazione_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    [SchemaCertificazioneId]      INT                                                NULL,
    CONSTRAINT [PK_ProgrammaCertificazione] PRIMARY KEY CLUSTERED ([ProgrammaCertificazioneId] ASC),
    CONSTRAINT [CK_ProgrammaCertificazione_TipoProgramma] CHECK ([TipoProgramma]='ALTRO' OR [TipoProgramma]='SISTEMA' OR [TipoProgramma]='SERVIZIO' OR [TipoProgramma]='PRODOTTO' OR [TipoProgramma]='PERSONE' OR [TipoProgramma]='FORMAZIONE'),
    CONSTRAINT [FK_ProgrammaCertificazione_NormaAccreditamentoSchema] FOREIGN KEY ([NormaAccreditamentoSchemaId]) REFERENCES [Standard].[NormaAccreditamentoSchema] ([NormaAccreditamentoSchemaId]),
    CONSTRAINT [FK_ProgrammaCertificazione_SchemaCertificazione] FOREIGN KEY ([SchemaCertificazioneId]) REFERENCES [Standard].[SchemaCertificazione] ([SchemaCertificazioneId]),
    CONSTRAINT [UQ_ProgrammaCertificazione_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Certificazione].[ProgrammaCertificazioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_ProgrammaCertificazione_SchemaCertificazione]
    ON [Certificazione].[ProgrammaCertificazione]([SchemaCertificazioneId] ASC) WHERE ([SchemaCertificazioneId] IS NOT NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente che ha effettuato l ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK (nullable) verso Standard.SchemaCertificazione: identita'' autorevole stabile dello schema di cui questo programma e'' l''uso operativo. Sostituisce progressivamente le colonne testuali ProprietarioSchema/CodiceSchemaProprietario per l''identita'' dello schema; la revisione ufficiale applicabile sta su ProgrammaCertificazioneVersione.SchemaCertificazioneVersioneId.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione', @level2type = N'COLUMN', @level2name = N'SchemaCertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ProgrammaCertificazione","temporal":true,"temporal_type":2,"history_table":"Certificazione.ProgrammaCertificazioneStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogate autoincrementante. Referenziata da ProgrammaRequisito, ProgrammaCertificazioneWorkflow, CertificazioneFPC e CertificazioneSG.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione', @level2type = N'COLUMN', @level2name = N'ProgrammaCertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nome esteso e leggibile del programma. Esempi: "DigComp 2.2 - Pekit Expert rev. 3 Novembre 2024", "ENEL2 - ADpc Addetto ai lavori". Usato nelle interfacce utente e nei documenti di accreditamento.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione', @level2type = N'COLUMN', @level2name = N'Nome';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo legacy del Modello A: FK verso Standard.NormaAccreditamentoSchema, cioe coppia norma-schema di accreditamento. Descrive il quadro di accreditamento applicabile al programma, ad esempio ISO/IEC 17024 + PRS. Non rappresenta necessariamente la norma/schema certificabile rilasciata al cliente o alla persona. Nel modello target deve migrare verso NormaEdizioneSchemaAccreditamentoId e deve essere distinto dalle norme/schemi certificabili collegati al programma.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione', @level2type = N'COLUMN', @level2name = N'NormaAccreditamentoSchemaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice, sigla o denominazione breve dello schema secondo il proprietario dello schema. Identifica il programma operativo rispetto alla fonte esterna. Deve essere distinto dalla norma di accreditamento del CAB e dalla NormaEdizioneCertificazioneId target.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione', @level2type = N'COLUMN', @level2name = N'CodiceSchemaProprietario';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di stato del programma. 1 = programma corrente e applicabile a nuove certificazioni. 0 = programma storico, superato da una versione successiva dello schema (es. rev_2 superata da rev_3). I record con Attivo = 0 vengono conservati per garantire la tracciabilità delle certificazioni storiche collegate.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente (FK su Persone.Utente) che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete). Il record rimane fisicamente in tabella ma viene escluso da tutte le query operative tramite filtro WHERE DataCancellazione IS NULL.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale (GUID) del record. Usato per tracciamento tecnico, sincronizzazione con sistemi esterni e integrazioni API.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC - Dipartimento Certificazione e Ispezione', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'DOMINIO', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Anagrafica dei programmi di certificazione operativi gestiti da ACCREDIA. Ogni record specializza una coppia norma-schema accreditata (FK su NormaAccreditamentoSchema) e definisce le regole applicative del ciclo certificativo: tipo di programma, schema proprietario dell OdC, durata del ciclo, flag di processo (esame, sorveglianza, delibera, campo prova, docenti qualificati) e periodo di validità. Attualmente contiene i programmi DigComp 2.2 (12 schemi proprietari PRS/ISO 17024) ed è predisposta per i programmi ENEL2, TERNA e altri schemi FPC, PRD, SGA. Tabella pivot del sottosistema certificazione: a valle riceve ProgrammaRequisito, ProgrammaRequisitoEvidenza, ProgrammaCertificazioneWorkflow e, tramite FK, CertificazioneFPC e CertificazioneSG.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice univoco del programma certificativo, ad esempio ENEL_APR_037 o TERNA_NT005RE.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione estesa opzionale del programma. Può contenere note operative, riferimenti normativi aggiuntivi, contesto di accreditamento o restrizioni applicative (es. limitazione al livello 5 o 6 per alcuni schemi DigComp).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Soggetto proprietario, gestore o regolatore dello schema certificativo/proprietario gestito dal programma. Esempi: organismo proprietario dello schema, ente regolatore, proprietario tecnico. Campo informativo; non sostituisce il collegamento strutturato alle norme/edizioni applicabili.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione', @level2type = N'COLUMN', @level2name = N'ProprietarioSchema';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Classificazione funzionale del programma certificativo. Determina il dominio di dettaglio atteso: PERSONE/FPC, SISTEMA/SG, PRODOTTO/PRD, SERVIZIO, PROCESSO, ALTRO. Non deve essere usato come surrogato dello schema di accreditamento o della norma certificabile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione', @level2type = N'COLUMN', @level2name = N'TipoProgramma';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record. Valorizzato automaticamente da SYSUTCDATETIME().', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

