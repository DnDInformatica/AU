CREATE TABLE [Accreditamento].[ElencoDettaglioFlessibile] (
    [ElencoDettaglioFlessibileId] INT                                                IDENTITY (1, 1) NOT NULL,
    [PraticaAccreditamentoId]     INT                                                NOT NULL,
    [TipologiaFamiglia]           NVARCHAR (400)                                     NOT NULL,
    [OggettoDettaglio]            NVARCHAR (1000)                                    NOT NULL,
    [DescrizioneEstesa]           NVARCHAR (MAX)                                     NULL,
    [NormaEdizioneId]             INT                                                NULL,
    [CodiceNormaTesto]            NVARCHAR (200)                                     NULL,
    [AnnoRevisioneNorma]          NVARCHAR (40)                                      NULL,
    [DocumentoRegoleRiferimento]  NVARCHAR (500)                                     NULL,
    [DataInserimentoCAB]          DATE                                               NOT NULL,
    [DataModificaCAB]             DATE                                               NULL,
    [DataCancellazioneCAB]        DATE                                               NULL,
    [StatoElementoFlessibileId]   TINYINT                                            CONSTRAINT [DF_ElencoDettFlex_Stato] DEFAULT ((1)) NOT NULL,
    [UrlPubblicazione]            NVARCHAR (1000)                                    NULL,
    [FlagVisibilitaPubblica]      BIT                                                CONSTRAINT [DF_ElencoDettFlex_VisibilitaPubblica] DEFAULT ((1)) NOT NULL,
    [RegistrazioneIstruttoriaCAB] NVARCHAR (MAX)                                     NULL,
    [NoteValidazione]             NVARCHAR (MAX)                                     NULL,
    [DataCreazione]               DATETIME2 (7)                                      CONSTRAINT [DF_ElencoDettFlex_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                    INT                                                NULL,
    [DataModifica]                DATETIME2 (7)                                      NULL,
    [ModificatoDa]                INT                                                NULL,
    [DataCancellazione]           DATETIME2 (7)                                      NULL,
    [CancellatoDa]                INT                                                NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER                                   CONSTRAINT [DF_ElencoDettFlex_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]          DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]            DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [HashBusinessKey]             AS                                                 (CONVERT([binary](32),hashbytes('SHA2_256',(((((CONVERT([nvarchar](20),[PraticaAccreditamentoId])+N'|')+isnull([OggettoDettaglio],N'<NULL>'))+N'|')+isnull([CodiceNormaTesto],N'<NULL>'))+N'|')+isnull(CONVERT([nvarchar](20),[NormaEdizioneId]),N'<NULL>')))) PERSISTED,
    CONSTRAINT [PK_ElencoDettaglioFlessibile] PRIMARY KEY CLUSTERED ([ElencoDettaglioFlessibileId] ASC),
    CONSTRAINT [CK_ElencoDettFlex_NormaRiferimento] CHECK ([NormaEdizioneId] IS NOT NULL OR [CodiceNormaTesto] IS NOT NULL),
    CONSTRAINT [FK_ElencoDettFlex_NormaEdizione] FOREIGN KEY ([NormaEdizioneId]) REFERENCES [Standard].[NormaEdizione] ([NormaEdizioneId]),
    CONSTRAINT [FK_ElencoDettFlex_PraticaAccr] FOREIGN KEY ([PraticaAccreditamentoId]) REFERENCES [Accreditamento].[PraticaAccreditamento] ([PraticaAccreditamentoId]),
    CONSTRAINT [FK_ElencoDettFlex_StatoElemento] FOREIGN KEY ([StatoElementoFlessibileId]) REFERENCES [Tipologica].[StatoElementoFlessibile] ([StatoElementoFlessibileId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Accreditamento].[ElencoDettaglioFlessibileStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_ElencoDettFlex_BusinessKey]
    ON [Accreditamento].[ElencoDettaglioFlessibile]([HashBusinessKey] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ElencoDettFlex_Stato_Data]
    ON [Accreditamento].[ElencoDettaglioFlessibile]([StatoElementoFlessibileId] ASC, [DataInserimentoCAB] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_ElencoDettFlex_SoftDelete]
    ON [Accreditamento].[ElencoDettaglioFlessibile]([DataCancellazione] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ElencoDettFlex_CreatoDa]
    ON [Accreditamento].[ElencoDettaglioFlessibile]([CreatoDa] ASC) WHERE ([CreatoDa] IS NOT NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ElencoDettFlex_Pratica_Oggetto]
    ON [Accreditamento].[ElencoDettaglioFlessibile]([PraticaAccreditamentoId] ASC)
    INCLUDE([OggettoDettaglio], [CodiceNormaTesto], [StatoElementoFlessibileId]);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note di validazione ACCREDIA sulla voce di scopo. Se usate per decisioni, devono essere correlate a workflow, utente, data, esito e provvedimento/delibera.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile', @level2type = N'COLUMN', @level2name = N'NoteValidazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Testo o riferimento istruttorio fornito dal CAB. Campo di supporto; non sostituisce la validazione interna ACCREDIA o la decisione formale.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile', @level2type = N'COLUMN', @level2name = N'RegistrazioneIstruttoriaCAB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento testuale legacy o di migrazione alla norma della voce. Non garantisce univocita, stato, transizione o ritiro; deve essere riconciliato con NormaEdizioneId quando possibile.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile', @level2type = N'COLUMN', @level2name = N'CodiceNormaTesto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio validita business della voce di scopo nel sistema. Distinto da data inserimento CAB, approvazione, decorrenza formale e pubblicazione.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Anno o revisione testuale della norma della voce. Campo ausiliario: non identifica da solo una edizione normativa e non gestisce emendamenti o rettifiche.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile', @level2type = N'COLUMN', @level2name = N'AnnoRevisioneNorma';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine validita business della voce di scopo nel sistema. Non equivale automaticamente a sospensione, revoca o ritiro della pubblicazione.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Elenco controllato (RT-37 § 5.2.1) / Elenco di dettaglio (RT-26 § 5.5.1) gestito dal CAB nell''ambito dello scopo di accreditamento flessibile. Ogni riga e un elemento (prodotto, figura professionale, ambito ispettivo, misurando) inserito dal CAB entro il perimetro di flessibilita concesso.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Documento, regolamento o regola tecnica collegata alla voce. Campo descrittivo da trasformare in relazione documentale/normativa strutturata se usato per controlli o decisioni.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile', @level2type = N'COLUMN', @level2name = N'DocumentoRegoleRiferimento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Hash della business key della voce, usato per deduplicazione e caricamenti incrementali. Non e una chiave funzionale leggibile e non sostituisce le relazioni strutturate.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile', @level2type = N'COLUMN', @level2name = N'HashBusinessKey';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata della voce di dettaglio dello scopo flessibile. La voce rappresenta una specifica attivita/oggetto/norma/limite autorizzato o gestito nel perimetro dello scopo.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile', @level2type = N'COLUMN', @level2name = N'ElencoDettaglioFlessibileId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data dichiarata di modifica della voce da parte del CAB. Non equivale a modifica approvata dello scopo finche non collegata a istruttoria/decisione valida.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile', @level2type = N'COLUMN', @level2name = N'DataModificaCAB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data dichiarata di inserimento della voce da parte del CAB. Distinta da approvazione ACCREDIA, decorrenza formale e pubblicazione esterna.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile', @level2type = N'COLUMN', @level2name = N'DataInserimentoCAB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data dichiarata di cancellazione della voce da parte del CAB. Non equivale automaticamente a riduzione, revoca o ritiro formale dello scopo.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile', @level2type = N'COLUMN', @level2name = N'DataCancellazioneCAB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso la pratica di accreditamento cui appartiene la voce. La pratica non deve essere trattata come sinonimo di scopo: una pratica puo generare o modificare una o piu voci.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile', @level2type = N'COLUMN', @level2name = N'PraticaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stato della singola voce di scopo flessibile. Da usare per gestire approvazione, sospensione, revoca, ritiro o non pubblicazione della voce, distinto dallo stato della pratica.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile', @level2type = N'COLUMN', @level2name = N'StatoElementoFlessibileId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Oggetto specifico della voce di scopo. Deve descrivere l''attivita o oggetto autorizzato; non deve sostituire norme, settori, metodi o classificazioni strutturate quando disponibili.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile', @level2type = N'COLUMN', @level2name = N'OggettoDettaglio';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Classificazione testuale/familiare della voce di scopo. Campo utile per migrazione e presentazione, ma da normalizzare quando diventa criterio di autorizzazione o pubblicazione.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile', @level2type = N'COLUMN', @level2name = N'TipologiaFamiglia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione estesa della voce di scopo. Campo descrittivo, utile per pubblicazione, ma non sufficiente da solo per controlli deterministici di autorizzazione.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile', @level2type = N'COLUMN', @level2name = N'DescrizioneEstesa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'URL o riferimento di pubblicazione della voce/scopo. Campo informativo: la ricostruzione storica del pubblicato deve basarsi su snapshot/versioni pubblicate e documenti versionati.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile', @level2type = N'COLUMN', @level2name = N'UrlPubblicazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK target verso Standard.NormaEdizione. Identifica l''edizione normativa applicabile alla voce di scopo. E il riferimento da preferire rispetto a CodiceNormaTesto e AnnoRevisioneNorma.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile', @level2type = N'COLUMN', @level2name = N'NormaEdizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se la voce e destinata alla visibilita pubblica. Non sostituisce stato approvativo, pubblicazione effettiva o data di pubblicazione.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ElencoDettaglioFlessibile', @level2type = N'COLUMN', @level2name = N'FlagVisibilitaPubblica';


GO

