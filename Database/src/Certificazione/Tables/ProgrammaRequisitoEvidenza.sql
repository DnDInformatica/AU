CREATE TABLE [Certificazione].[ProgrammaRequisitoEvidenza] (
    [ProgrammaRequisitoEvidenzaId] INT                                                IDENTITY (1, 1) NOT NULL,
    [ProgrammaRequisitoId]         INT                                                NOT NULL,
    [TipoEvidenzaProgrammaId]      INT                                                NOT NULL,
    [CodiceEvidenza]               NVARCHAR (50)                                      NOT NULL,
    [Titolo]                       NVARCHAR (255)                                     NOT NULL,
    [Descrizione]                  NVARCHAR (MAX)                                     NULL,
    [Obbligatoria]                 BIT                                                DEFAULT ((1)) NOT NULL,
    [RichiedeDocumento]            BIT                                                DEFAULT ((1)) NOT NULL,
    [RichiedeValidazione]          BIT                                                DEFAULT ((1)) NOT NULL,
    [FormatoAmmesso]               NVARCHAR (255)                                     NULL,
    [ValiditaMesi]                 SMALLINT                                           NULL,
    [NoteValidazione]              NVARCHAR (MAX)                                     NULL,
    [Ordine]                       SMALLINT                                           DEFAULT ((1)) NOT NULL,
    [Attivo]                       BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]                DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                     INT                                                NULL,
    [DataModifica]                 DATETIME2 (7)                                      NULL,
    [ModificatoDa]                 INT                                                NULL,
    [DataCancellazione]            DATETIME2 (7)                                      NULL,
    [CancellatoDa]                 INT                                                NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]           DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]             DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_ProgrammaRequisitoEvidenza] PRIMARY KEY CLUSTERED ([ProgrammaRequisitoEvidenzaId] ASC),
    CONSTRAINT [CK_ProgrammaRequisitoEvidenza_ValiditaMesi] CHECK ([ValiditaMesi] IS NULL OR [ValiditaMesi]>(0)),
    CONSTRAINT [FK_ProgrammaRequisitoEvidenza_ProgrammaRequisito] FOREIGN KEY ([ProgrammaRequisitoId]) REFERENCES [Certificazione].[ProgrammaRequisito] ([ProgrammaRequisitoId]),
    CONSTRAINT [FK_ProgrammaRequisitoEvidenza_TipoEvidenzaProgramma] FOREIGN KEY ([TipoEvidenzaProgrammaId]) REFERENCES [Certificazione].[TipoEvidenzaProgramma] ([TipoEvidenzaProgrammaId]),
    CONSTRAINT [UQ_ProgrammaRequisitoEvidenza_Requisito_Codice] UNIQUE NONCLUSTERED ([ProgrammaRequisitoId] ASC, [CodiceEvidenza] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Certificazione].[ProgrammaRequisitoEvidenzaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco dell’evidenza richiesta dal requisito di programma.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'ProgrammaRequisitoEvidenzaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ordine di presentazione e valutazione dell’evidenza nell’ambito del requisito.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Validità massima dell’evidenza espressa in mesi. Se NULL, la validità non è determinata dal programma.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'ValiditaMesi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione estesa dell’evidenza richiesta, comprensiva di contenuto atteso, fonte, modalità di produzione o note operative.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Certificazione.TipoEvidenzaProgramma. Classifica la natura dell’evidenza richiesta.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'TipoEvidenzaProgrammaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Elenco o descrizione dei formati ammessi per l’evidenza, ad esempio PDF, XML, immagine, documento firmato o registro esportato.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'FormatoAmmesso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'DOMINIO', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se l’evidenza deve essere supportata da un documento caricato o collegato al repository documentale.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'RichiedeDocumento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note operative o criteri specifici da applicare durante la validazione dell’evidenza.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'NoteValidazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Evidenze richieste per dimostrare la conformità a un requisito di programma certificativo. La tabella definisce tipo evidenza, obbligatorietà, necessità di documento, criteri di validazione, formati ammessi, validità temporale e ordine di valutazione. Temporal table con audit, soft-delete e system-versioning.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se l’evidenza è obbligatoria per dimostrare la conformità al requisito.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'Obbligatoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Certificazione","table":"ProgrammaRequisitoEvidenza","temporal":true,"temporal_type":2,"history_table":"Certificazione.ProgrammaRequisitoEvidenzaStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Titolo sintetico dell’evidenza richiesta.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record, usato per tracciamento tecnico e integrazioni.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice dell’evidenza all’interno del requisito. Deve essere univoco per requisito.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'CodiceEvidenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Certificazione.ProgrammaRequisito. Identifica il requisito di programma a cui l’evidenza è associata.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'ProgrammaRequisitoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di attività: 1 = evidenza utilizzabile, 0 = evidenza disattivata.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se l’evidenza richiede validazione formale da parte di un valutatore, auditor, reviewer o figura autorizzata.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaRequisitoEvidenza', @level2type = N'COLUMN', @level2name = N'RichiedeValidazione';


GO

