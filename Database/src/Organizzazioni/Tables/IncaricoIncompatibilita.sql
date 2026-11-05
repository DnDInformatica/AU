CREATE TABLE [Organizzazioni].[IncaricoIncompatibilita] (
    [IncaricoIncompatibilitaId]   INT                                                IDENTITY (1, 1) NOT NULL,
    [IncaricoId]                  INT                                                NOT NULL,
    [OrganizzazioneControparteId] INT                                                NOT NULL,
    [TipoIncompatibilitaId]       INT                                                NOT NULL,
    [DipartimentoAccrediaId]      INT                                                NULL,
    [RuoloSorgente]               NVARCHAR (200)                                     NULL,
    [PosizioneOrganizzativa]      NVARCHAR (300)                                     NULL,
    [RelazioneConEnte]            NVARCHAR (200)                                     NULL,
    [DataInizio]                  DATE                                               NOT NULL,
    [DataFine]                    DATE                                               NULL,
    [Fonte]                       NVARCHAR (100)                                     NULL,
    [RiferimentoOrigine]          NVARCHAR (100)                                     NULL,
    [Note]                        NVARCHAR (2000)                                    NULL,
    [DerogaConcessa]              BIT                                                DEFAULT ((0)) NOT NULL,
    [DataDeroga]                  DATE                                               NULL,
    [DataCreazione]               DATETIME2 (7)                                      DEFAULT (getutcdate()) NOT NULL,
    [CreatoDa]                    INT                                                NULL,
    [DataModifica]                DATETIME2 (7)                                      NULL,
    [ModificatoDa]                INT                                                NULL,
    [DataCancellazione]           DATETIME2 (7)                                      NULL,
    [CancellatoDa]                INT                                                NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [PersonaId]                   INT                                                NOT NULL,
    [DataInizioValidita]          DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]            DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_IncaricoIncompatibilita] PRIMARY KEY CLUSTERED ([IncaricoIncompatibilitaId] ASC),
    CONSTRAINT [FK_IncaricoIncompatibilita_Dipartimento] FOREIGN KEY ([DipartimentoAccrediaId]) REFERENCES [Tipologica].[DipartimentoAccredia] ([DipartimentoAccrediaId]),
    CONSTRAINT [FK_IncaricoIncompatibilita_Incarico] FOREIGN KEY ([IncaricoId]) REFERENCES [Organizzazioni].[Incarico] ([IncaricoId]),
    CONSTRAINT [FK_IncaricoIncompatibilita_OrganizzazioneControparte] FOREIGN KEY ([OrganizzazioneControparteId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId]),
    CONSTRAINT [FK_IncaricoIncompatibilita_Persona] FOREIGN KEY ([PersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [FK_IncaricoIncompatibilita_TipoIncompatibilita] FOREIGN KEY ([TipoIncompatibilitaId]) REFERENCES [Tipologica].[TipoIncompatibilita] ([TipoIncompatibilitaId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Organizzazioni].[IncaricoIncompatibilitaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipologia di incompatibilita applicata, normalizzata su Tipologica.TipoIncompatibilita.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'IncaricoIncompatibilita', @level2type = N'COLUMN', @level2name = N'TipoIncompatibilitaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''organizzazione controparte verso cui sussiste l''incompatibilita o il conflitto potenziale.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'IncaricoIncompatibilita', @level2type = N'COLUMN', @level2name = N'OrganizzazioneControparteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dipartimento Accredia di riferimento per la valutazione dell''incompatibilita.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'IncaricoIncompatibilita', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Posizione organizzativa o unita organizzativa rilevante per la valutazione dell''incompatibilita.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'IncaricoIncompatibilita', @level2type = N'COLUMN', @level2name = N'PosizioneOrganizzativa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ruolo o funzione sorgente come acquisito dal legacy o derivato dall''incarico.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'IncaricoIncompatibilita', @level2type = N'COLUMN', @level2name = N'RuoloSorgente';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di inizio validita dell''incompatibilita.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'IncaricoIncompatibilita', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Relazione con l''ente che motiva o qualifica l''incompatibilita, ad esempio consulenza o collaborazione.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'IncaricoIncompatibilita', @level2type = N'COLUMN', @level2name = N'RelazioneConEnte';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Registra le incompatibilita dinamiche legate a una persona e al relativo incarico o funzione, verso una organizzazione controparte, con validita temporale e contesto organizzativo.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'IncaricoIncompatibilita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'CONFIGURAZIONE', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'IncaricoIncompatibilita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''incarico o funzione cui l''incompatibilita e associata. L''incompatibilita nel modello 231 e legata sempre a incarico/funzione.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'IncaricoIncompatibilita', @level2type = N'COLUMN', @level2name = N'IncaricoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo della persona soggetta all''incompatibilita. Rende possibile il controllo operativo di assegnazione mantenendo il legame con l''incarico.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'IncaricoIncompatibilita', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di fine validita dell''incompatibilita.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'IncaricoIncompatibilita', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo o chiave legacy del record di origine.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'IncaricoIncompatibilita', @level2type = N'COLUMN', @level2name = N'RiferimentoOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fonte di origine del dato, ad esempio migrazione legacy, dichiarazione o istruttoria.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'IncaricoIncompatibilita', @level2type = N'COLUMN', @level2name = N'Fonte';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note o motivazione dell''incompatibilita.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'IncaricoIncompatibilita', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di concessione della deroga, se presente.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'IncaricoIncompatibilita', @level2type = N'COLUMN', @level2name = N'DataDeroga';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se e stata concessa una deroga all''incompatibilita.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'IncaricoIncompatibilita', @level2type = N'COLUMN', @level2name = N'DerogaConcessa';


GO

