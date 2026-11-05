CREATE TABLE [Standard].[NormaFamiglia] (
    [NormaFamigliaId]    INT                                                IDENTITY (1, 1) NOT NULL,
    [CodiceFamiglia]     NVARCHAR (100)                                     NOT NULL,
    [NumeroFamiglia]     NVARCHAR (50)                                      NOT NULL,
    [DesignazioneBase]   NVARCHAR (200)                                     NOT NULL,
    [TitoloBaseIta]      NVARCHAR (1000)                                    NULL,
    [TitoloBaseEng]      NVARCHAR (1000)                                    NULL,
    [TipoAggregazione]   VARCHAR (30)                                       CONSTRAINT [DF_NormaFamiglia_TipoAggregazione] DEFAULT ('FAMIGLIA') NOT NULL,
    [Descrizione]        NVARCHAR (2000)                                    NULL,
    [Attivo]             BIT                                                CONSTRAINT [DF_NormaFamiglia_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]      DATETIME2 (7)                                      CONSTRAINT [DF_NormaFamiglia_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]           INT                                                NULL,
    [DataModifica]       DATETIME2 (7)                                      NULL,
    [ModificatoDa]       INT                                                NULL,
    [DataCancellazione]  DATETIME2 (7)                                      NULL,
    [CancellatoDa]       INT                                                NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER                                   CONSTRAINT [DF_NormaFamiglia_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_NormaFamiglia_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_NormaFamiglia_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_NormaFamiglia] PRIMARY KEY CLUSTERED ([NormaFamigliaId] ASC),
    CONSTRAINT [CK_NormaFamiglia_Cancellazione] CHECK ([DataCancellazione] IS NULL AND [CancellatoDa] IS NULL OR [DataCancellazione] IS NOT NULL),
    CONSTRAINT [CK_NormaFamiglia_CodiceFamiglia] CHECK (len(ltrim(rtrim([CodiceFamiglia])))>(0)),
    CONSTRAINT [CK_NormaFamiglia_DataCancellazione] CHECK ([DataCancellazione] IS NULL OR [DataCancellazione]>=[DataCreazione]),
    CONSTRAINT [CK_NormaFamiglia_DataModifica] CHECK ([DataModifica] IS NULL OR [DataModifica]>=[DataCreazione]),
    CONSTRAINT [CK_NormaFamiglia_DesignazioneBase] CHECK (len(ltrim(rtrim([DesignazioneBase])))>(0)),
    CONSTRAINT [CK_NormaFamiglia_NumeroFamiglia] CHECK (len(ltrim(rtrim([NumeroFamiglia])))>(0)),
    CONSTRAINT [CK_NormaFamiglia_TipoAggregazione] CHECK ([TipoAggregazione]='SERIE_MULTIPART' OR [TipoAggregazione]='SERIE' OR [TipoAggregazione]='FAMIGLIA'),
    CONSTRAINT [UQ_NormaFamiglia_CodiceFamiglia] UNIQUE NONCLUSTERED ([CodiceFamiglia] ASC),
    CONSTRAINT [UQ_NormaFamiglia_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[NormaFamigliaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_NormaFamiglia_DesignazioneBase]
    ON [Standard].[NormaFamiglia]([DesignazioneBase] ASC)
    INCLUDE([CodiceFamiglia], [NumeroFamiglia], [TitoloBaseIta], [Attivo]);


GO

CREATE NONCLUSTERED INDEX [IX_NormaFamiglia_Attivo]
    ON [Standard].[NormaFamiglia]([Attivo] ASC)
    INCLUDE([CodiceFamiglia], [NumeroFamiglia], [DesignazioneBase], [TipoAggregazione]);


GO

CREATE NONCLUSTERED INDEX [IX_NormaFamiglia_NumeroFamiglia]
    ON [Standard].[NormaFamiglia]([NumeroFamiglia] ASC)
    INCLUDE([CodiceFamiglia], [DesignazioneBase], [TipoAggregazione], [Attivo]);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo globale univoco e stabile della riga, utilizzabile per integrazioni e sincronizzazioni.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Designazione editoriale convenzionale della famiglia utilizzata per ricerca e visualizzazione. Può includere le sigle degli organismi, ma non costituisce la relazione strutturale con gli organismi di normazione. Esempi: ISO 9000, ISO/IEC 27000.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia', @level2type = N'COLUMN', @level2name = N'DesignazioneBase';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Classificazione strutturale dell''aggregato normativo: FAMIGLIA, SERIE oppure SERIE_MULTIPART.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia', @level2type = N'COLUMN', @level2name = N'TipoAggregazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC di creazione del record applicativo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata della famiglia normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia', @level2type = N'COLUMN', @level2name = N'NormaFamigliaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC della cancellazione logica del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante tecnico iniziale della versione della riga, gestito automaticamente da SQL Server. Non rappresenta l''entrata in vigore della famiglia normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice applicativo stabile della famiglia, indipendente dalle singole norme, dalle edizioni e dai recepimenti. Esempi: ISO-9000, ISOIEC-27000, ISOIEC-20000.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia', @level2type = N'COLUMN', @level2name = N'CodiceFamiglia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Titolo generale in lingua italiana attribuito alla famiglia o alla serie normativa. Non sostituisce il titolo ufficiale delle singole norme o edizioni.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia', @level2type = N'COLUMN', @level2name = N'TitoloBaseIta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione funzionale e semantica della famiglia normativa, del dominio trattato e delle finalità generali.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Anagrafica delle famiglie e delle serie normative. Una famiglia rappresenta un aggregato concettuale stabile, indipendente dai singoli documenti, dalle edizioni, dai recepimenti e dagli organismi di normazione associati.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero o codice-base della famiglia, privo delle sigle degli organismi e dell''anno di edizione. Esempi: 9000, 27000, 20000, 17021.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia', @level2type = N'COLUMN', @level2name = N'NumeroFamiglia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Titolo generale in lingua inglese attribuito alla famiglia o alla serie normativa. Non sostituisce il titolo ufficiale delle singole norme o edizioni.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia', @level2type = N'COLUMN', @level2name = N'TitoloBaseEng';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se la famiglia è utilizzabile nei processi applicativi. Non determina la vigenza delle singole norme o delle relative edizioni.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC dell''ultima modifica applicativa del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante tecnico finale della versione della riga, gestito automaticamente da SQL Server. Non rappresenta la cessazione o il ritiro della famiglia normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamiglia', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

