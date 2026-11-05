CREATE TABLE [Standard].[ClassificazioneGovernance] (
    [ClassificazioneId]            INT                                         NOT NULL,
    [TipoSistemaClassificatorio]   NVARCHAR (80)                               NOT NULL,
    [FonteCanonicaSoggettoFonteId] INT                                         NULL,
    [VersionabileFlag]             BIT                                         CONSTRAINT [DF_ClassificazioneGovernance_VersionabileFlag] DEFAULT ((1)) NOT NULL,
    [ConsenteGerarchia]            BIT                                         CONSTRAINT [DF_ClassificazioneGovernance_ConsenteGerarchia] DEFAULT ((0)) NOT NULL,
    [ConsenteCorrispondenze]       BIT                                         CONSTRAINT [DF_ClassificazioneGovernance_ConsenteCorrispondenze] DEFAULT ((1)) NOT NULL,
    [ConsenteVoceTecnica]          BIT                                         CONSTRAINT [DF_ClassificazioneGovernance_ConsenteVoceTecnica] DEFAULT ((1)) NOT NULL,
    [NoteGovernance]               NVARCHAR (2000)                             NULL,
    [Attivo]                       BIT                                         CONSTRAINT [DF_ClassificazioneGovernance_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                DATETIME2 (7)                               CONSTRAINT [DF_ClassificazioneGovernance_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                     INT                                         NULL,
    [DataModifica]                 DATETIME2 (7)                               NULL,
    [ModificatoDa]                 INT                                         NULL,
    [DataCancellazione]            DATETIME2 (7)                               NULL,
    [CancellatoDa]                 INT                                         NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER                            CONSTRAINT [DF_ClassificazioneGovernance_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]           DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]             DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    [ConsentePiuPadri]             BIT                                         NULL,
    CONSTRAINT [PK_ClassificazioneGovernance] PRIMARY KEY CLUSTERED ([ClassificazioneId] ASC),
    CONSTRAINT [CK_ClassificazioneGovernance_PiuPadri] CHECK ([ConsenteGerarchia]=(0) AND [ConsentePiuPadri] IS NULL OR [ConsenteGerarchia]=(1) AND [ConsentePiuPadri] IS NOT NULL),
    CONSTRAINT [CK_ClassificazioneGovernance_Tipo] CHECK ([TipoSistemaClassificatorio]=N'TIPOLOGIA_OPERATIVA' OR [TipoSistemaClassificatorio]=N'SETTORIALE_ACCREDITAMENTO' OR [TipoSistemaClassificatorio]=N'ECONOMICO_STATISTICO'),
    CONSTRAINT [FK_ClassificazioneGovernance_Classificazione] FOREIGN KEY ([ClassificazioneId]) REFERENCES [Standard].[Classificazione] ([ClassificazioneId]),
    CONSTRAINT [FK_ClassificazioneGovernance_SoggettoFonte] FOREIGN KEY ([FonteCanonicaSoggettoFonteId]) REFERENCES [Standard].[SoggettoFonte] ([SoggettoFonteId]),
    CONSTRAINT [UQ_ClassificazioneGovernance_Corrispondenze] UNIQUE NONCLUSTERED ([ClassificazioneId] ASC, [ConsenteCorrispondenze] ASC),
    CONSTRAINT [UQ_ClassificazioneGovernance_Gerarchia] UNIQUE NONCLUSTERED ([ClassificazioneId] ASC, [ConsenteGerarchia] ASC),
    CONSTRAINT [UQ_ClassificazioneGovernance_GerarchiaPadri] UNIQUE NONCLUSTERED ([ClassificazioneId] ASC, [ConsenteGerarchia] ASC, [ConsentePiuPadri] ASC),
    CONSTRAINT [UQ_ClassificazioneGovernance_Versionabile] UNIQUE NONCLUSTERED ([ClassificazioneId] ASC, [VersionabileFlag] ASC),
    CONSTRAINT [UQ_ClassificazioneGovernance_VoceTecnica] UNIQUE NONCLUSTERED ([ClassificazioneId] ASC, [ConsenteVoceTecnica] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[ClassificazioneGovernanceStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore GUID stabile della riga.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneGovernance', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Capacita della classificazione di avere versioni distinte. Predisposto per gate dichiarativo tramite FK composta.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneGovernance', @level2type = N'COLUMN', @level2name = N'VersionabileFlag';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell ultima modifica applicativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneGovernance', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note motivate sulla fonte, sul perimetro e sulle decisioni di governance della classificazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneGovernance', @level2type = N'COLUMN', @level2name = N'NoteGovernance';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneGovernance', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se una voce puo avere piu padri diretti. NULL quando la classificazione non consente gerarchia.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneGovernance', @level2type = N'COLUMN', @level2name = N'ConsentePiuPadri';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK al soggetto produttore, custode o responsabile operativo della classificazione; non implica che il soggetto sia l emittente giuridico di ogni documento.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneGovernance', @level2type = N'COLUMN', @level2name = N'FonteCanonicaSoggettoFonteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneGovernance', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Capacita di ammettere voci di TipoVoce Tecnica; non governa le voci canoniche, di raggruppamento o sentinella.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneGovernance', @level2type = N'COLUMN', @level2name = N'ConsenteVoceTecnica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PK e FK a Standard.Classificazione; garantisce al massimo una governance corrente per classificazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneGovernance', @level2type = N'COLUMN', @level2name = N'ClassificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica; NULL per il record corrente non cancellato.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneGovernance', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine del periodo di system-versioning gestito da Azure SQL.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneGovernance', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Capacita della classificazione di partecipare a corrispondenze con altre versioni o classificazioni.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneGovernance', @level2type = N'COLUMN', @level2name = N'ConsenteCorrispondenze';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Attributo legacy di macro-tipizzazione del sistema classificatorio. Non rappresenta il dominio semantico ne l''applicabilita, modellati rispettivamente da ClassificazioneDominioSemantico e ClassificazioneSchemaAccreditamento. Il vocabolario e congelato: non aggiungere valori per i contenuti DL/DT. Dopo la modellazione degli scopi tecnici verificare i consumer e decidere la rimozione o la sostituzione con un asse realmente ortogonale.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneGovernance', @level2type = N'COLUMN', @level2name = N'TipoSistemaClassificatorio';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneGovernance', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Estensione 1:1 della classificazione con responsabilita, fonte canonica e capacita del sistema classificatorio. La totalita rispetto a Classificazione e controllata dalla vista di conformita.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneGovernance';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio del periodo di system-versioning gestito da Azure SQL.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneGovernance', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Capacita della classificazione di ammettere relazioni gerarchiche tra voci.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneGovernance', @level2type = N'COLUMN', @level2name = N'ConsenteGerarchia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di attivazione della governance; la coerenza con Classificazione.Attivo e controllata dalla vista di conformita.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneGovernance', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente che ha effettuato l ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneGovernance', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

