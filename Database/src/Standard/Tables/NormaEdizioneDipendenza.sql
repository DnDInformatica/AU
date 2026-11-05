CREATE TABLE [Standard].[NormaEdizioneDipendenza] (
    [NormaEdizioneDipendenzaId] INT                                                IDENTITY (1, 1) NOT NULL,
    [NormaEdizioneOrigineId]    INT                                                NOT NULL,
    [NormaEdizioneDipendenteId] INT                                                NOT NULL,
    [TipoDipendenzaNormaId]     INT                                                NOT NULL,
    [Obbligatoria]              BIT                                                DEFAULT ((1)) NOT NULL,
    [Note]                      NVARCHAR (1000)                                    NULL,
    [Attivo]                    BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]             DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                  INT                                                NULL,
    [DataModifica]              DATETIME2 (7)                                      NULL,
    [ModificatoDa]              INT                                                NULL,
    [DataCancellazione]         DATETIME2 (7)                                      NULL,
    [CancellatoDa]              INT                                                NULL,
    [UniqueRowId]               UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]        DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]          DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_NormaEdizioneDipendenza] PRIMARY KEY CLUSTERED ([NormaEdizioneDipendenzaId] ASC),
    CONSTRAINT [CK_NormaEdizioneDipendenza_NoSelf] CHECK ([NormaEdizioneOrigineId]<>[NormaEdizioneDipendenteId]),
    CONSTRAINT [FK_NormaEdizioneDipendenza_Dipendente] FOREIGN KEY ([NormaEdizioneDipendenteId]) REFERENCES [Standard].[NormaEdizione] ([NormaEdizioneId]),
    CONSTRAINT [FK_NormaEdizioneDipendenza_Origine] FOREIGN KEY ([NormaEdizioneOrigineId]) REFERENCES [Standard].[NormaEdizione] ([NormaEdizioneId]),
    CONSTRAINT [FK_NormaEdizioneDipendenza_TipoDipendenzaNorma] FOREIGN KEY ([TipoDipendenzaNormaId]) REFERENCES [Standard].[TipoDipendenzaNorma] ([TipoDipendenzaNormaId]),
    CONSTRAINT [UQ_NormaEdizioneDipendenza_CoppiaTipo] UNIQUE NONCLUSTERED ([NormaEdizioneOrigineId] ASC, [NormaEdizioneDipendenteId] ASC, [TipoDipendenzaNormaId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[NormaEdizioneDipendenzaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneDipendenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Utente o processo che ha creato la relazione normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneDipendenza', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note descrittive o motivazione della dipendenza normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneDipendenza', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Edizione normativa dipendente, richiamata o richiesta insieme all''edizione origine.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneDipendenza', @level2type = N'COLUMN', @level2name = N'NormaEdizioneDipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se la relazione normativa è attiva.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneDipendenza', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo di dipendenza normativa, ad esempio corequisito, requisito complementare, documento applicativo o requisito di schema.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneDipendenza', @level2type = N'COLUMN', @level2name = N'TipoDipendenzaNormaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data UTC di cancellazione logica della relazione normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneDipendenza', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata della dipendenza funzionale fra edizioni normative.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneDipendenza', @level2type = N'COLUMN', @level2name = N'NormaEdizioneDipendenzaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se la dipendenza e obbligatoria per applicare correttamente l''edizione origine nel contesto SIDAC.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneDipendenza', @level2type = N'COLUMN', @level2name = N'Obbligatoria';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Utente o processo che ha cancellato logicamente la relazione normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneDipendenza', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Edizione normativa principale o origine della dipendenza.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneDipendenza', @level2type = N'COLUMN', @level2name = N'NormaEdizioneOrigineId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data UTC dell’ultima modifica della relazione normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneDipendenza', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneDipendenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo univoco globale della relazione normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneDipendenza', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Utente o processo che ha modificato la relazione normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneDipendenza', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dipendenze normative tra edizioni: norme integrate, richiamate, applicate congiuntamente o collegate.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneDipendenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneDipendenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data UTC di creazione della relazione normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneDipendenza', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

