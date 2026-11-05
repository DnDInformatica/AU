CREATE TABLE [Certificazione].[ProgrammaCertificazioneWorkflow] (
    [ProgrammaCertificazioneWorkflowId] INT                                                IDENTITY (1, 1) NOT NULL,
    [ProgrammaCertificazioneId]         INT                                                NOT NULL,
    [WorkflowDefinizioneId]             INT                                                NOT NULL,
    [TipoProcessoCertificativoId]       INT                                                NOT NULL,
    [Obbligatorio]                      BIT                                                DEFAULT ((1)) NOT NULL,
    [Ordine]                            SMALLINT                                           DEFAULT ((1)) NOT NULL,
    [SLA_Giorni]                        INT                                                NULL,
    [RichiedeDelibera]                  BIT                                                DEFAULT ((1)) NOT NULL,
    [Note]                              NVARCHAR (1000)                                    NULL,
    [Attivo]                            BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]                     DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                          INT                                                NULL,
    [DataModifica]                      DATETIME2 (7)                                      NULL,
    [ModificatoDa]                      INT                                                NULL,
    [DataCancellazione]                 DATETIME2 (7)                                      NULL,
    [CancellatoDa]                      INT                                                NULL,
    [UniqueRowId]                       UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_ProgrammaCertificazioneWorkflow_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]                  DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_ProgrammaCertificazioneWorkflow_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_ProgrammaCertificazioneWorkflow] PRIMARY KEY CLUSTERED ([ProgrammaCertificazioneWorkflowId] ASC),
    CONSTRAINT [CK_ProgrammaCertificazioneWorkflow_SLA] CHECK ([SLA_Giorni] IS NULL OR [SLA_Giorni]>(0)),
    CONSTRAINT [FK_ProgrammaCertificazioneWorkflow_ProgrammaCertificazione] FOREIGN KEY ([ProgrammaCertificazioneId]) REFERENCES [Certificazione].[ProgrammaCertificazione] ([ProgrammaCertificazioneId]),
    CONSTRAINT [FK_ProgrammaCertificazioneWorkflow_TipoProcessoCertificativo] FOREIGN KEY ([TipoProcessoCertificativoId]) REFERENCES [Certificazione].[TipoProcessoCertificativo] ([TipoProcessoCertificativoId]),
    CONSTRAINT [FK_ProgrammaCertificazioneWorkflow_WorkflowDefinizione] FOREIGN KEY ([WorkflowDefinizioneId]) REFERENCES [Workflow].[WorkflowDefinizione] ([WorkflowDefinizioneId]),
    CONSTRAINT [UQ_ProgrammaCertificazioneWorkflow_Programma_Tipo] UNIQUE NONCLUSTERED ([ProgrammaCertificazioneId] ASC, [TipoProcessoCertificativoId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Certificazione].[ProgrammaCertificazioneWorkflowStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se l esecuzione del workflow è obbligatoria per il tipo di processo nel programma. Se 0, il workflow è opzionale o alternativo.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow', @level2type = N'COLUMN', @level2name = N'Obbligatorio';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC - Dipartimento Certificazione e Ispezione', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogate autoincrementante.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow', @level2type = N'COLUMN', @level2name = N'ProgrammaCertificazioneWorkflowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente che ha effettuato l ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Workflow.WorkflowDefinizione. Identifica il modello di workflow da applicare (sequenza di task, assegnazioni, transizioni di stato) per il tipo di processo specificato.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow', @level2type = N'COLUMN', @level2name = N'WorkflowDefinizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'DOMINIO', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record. Valorizzato automaticamente da SYSUTCDATETIME().', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Associazione tra un programma di certificazione e i workflow di processo applicabili. Ogni record lega un ProgrammaCertificazione a una WorkflowDefinizione per un determinato TipoProcessoCertificativo (INIZIALE, SORVEGLIANZA, RINNOVO, ESTENSIONE, REVOCA, SOSPENSIONE). Definisce ordine di esecuzione, obbligatorietà, SLA in giorni e necessità di delibera per ogni combinazione programma-processo. Permette di configurare percorsi differenziati per programmi con requisiti di processo diversi (es. DigComp 2.2 vs ENEL2).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Service Level Agreement in giorni lavorativi per il completamento del workflow. Usato per il monitoraggio dei tempi di processo e per la generazione di alert. NULL se non è definito un SLA per il programma e il tipo di processo.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow', @level2type = N'COLUMN', @level2name = N'SLA_Giorni';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note operative libere relative alla configurazione del workflow per il programma. Può contenere istruzioni per i valutatori, condizioni particolari o riferimenti a disposizioni interne ACCREDIA.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica. Il record rimane fisicamente in tabella. Filtrare con WHERE DataCancellazione IS NULL per i dati attivi.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Certificazione.TipoProcessoCertificativo. Specifica il tipo di processo a cui il workflow si applica: INIZIALE, SORVEGLIANZA, RINNOVO, ESTENSIONE, REVOCA, SOSPENSIONE o REINTEGRO. Insieme a ProgrammaCertificazioneId forma una coppia logicamente univoca.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow', @level2type = N'COLUMN', @level2name = N'TipoProcessoCertificativoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ordine di esecuzione del workflow nell ambito del tipo di processo per il programma. Usato quando più workflow si applicano allo stesso tipo di processo (es. workflow di valutazione seguito da workflow di delibera).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale (GUID) del record per tracciamento tecnico e integrazioni.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Certificazione.ProgrammaCertificazione. Identifica il programma a cui il workflow è associato.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow', @level2type = N'COLUMN', @level2name = N'ProgrammaCertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di stato. 1 = configurazione attiva e utilizzata dal motore workflow. 0 = configurazione disattivata (es. workflow sostituito da una versione aggiornata).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ProgrammaCertificazioneWorkflow","temporal":true,"temporal_type":2,"history_table":"Certificazione.ProgrammaCertificazioneWorkflowStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se questo specifico workflow richiede una delibera formale al termine dell esecuzione. Può sovrascrivere il flag omonimo di ProgrammaCertificazione per processi specifici (es. delibera obbligatoria al rinnovo ma non alla sorveglianza).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow', @level2type = N'COLUMN', @level2name = N'RichiedeDelibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflow';


GO

