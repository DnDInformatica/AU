CREATE TABLE [Standard].[NormaFamigliaRelazione] (
    [NormaFamigliaRelazioneId]    INT                                                IDENTITY (1, 1) NOT NULL,
    [NormaFamigliaOrigineId]      INT                                                NOT NULL,
    [NormaFamigliaDestinazioneId] INT                                                NOT NULL,
    [TipoRelazione]               VARCHAR (30)                                       NOT NULL,
    [Ordine]                      SMALLINT                                           NULL,
    [Gerarchica]                  BIT                                                CONSTRAINT [DF_NormaFamigliaRelazione_Gerarchica] DEFAULT ((0)) NOT NULL,
    [DescrizioneRelazione]        NVARCHAR (1000)                                    NULL,
    [Attivo]                      BIT                                                CONSTRAINT [DF_NormaFamigliaRelazione_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]               DATETIME2 (7)                                      CONSTRAINT [DF_NormaFamigliaRelazione_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                    INT                                                NULL,
    [DataModifica]                DATETIME2 (7)                                      NULL,
    [ModificatoDa]                INT                                                NULL,
    [DataCancellazione]           DATETIME2 (7)                                      NULL,
    [CancellatoDa]                INT                                                NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER                                   CONSTRAINT [DF_NormaFamigliaRelazione_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita]          DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_NormaFamigliaRelazione_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]            DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_NormaFamigliaRelazione_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_NormaFamigliaRelazione] PRIMARY KEY CLUSTERED ([NormaFamigliaRelazioneId] ASC),
    CONSTRAINT [CK_NormaFamigliaRelazione_Cancellazione] CHECK ([DataCancellazione] IS NULL AND [CancellatoDa] IS NULL OR [DataCancellazione] IS NOT NULL),
    CONSTRAINT [CK_NormaFamigliaRelazione_DataCancellazione] CHECK ([DataCancellazione] IS NULL OR [DataCancellazione]>=[DataCreazione]),
    CONSTRAINT [CK_NormaFamigliaRelazione_DataModifica] CHECK ([DataModifica] IS NULL OR [DataModifica]>=[DataCreazione]),
    CONSTRAINT [CK_NormaFamigliaRelazione_Gerarchica] CHECK ([Gerarchica]=(0) OR ([TipoRelazione]='PARTE_DI' OR [TipoRelazione]='SOTTOFAMIGLIA_DI' OR [TipoRelazione]='COMPRENDE')),
    CONSTRAINT [CK_NormaFamigliaRelazione_NoAutoRelazione] CHECK ([NormaFamigliaOrigineId]<>[NormaFamigliaDestinazioneId]),
    CONSTRAINT [CK_NormaFamigliaRelazione_Ordine] CHECK ([Ordine] IS NULL OR [Ordine]>(0)),
    CONSTRAINT [CK_NormaFamigliaRelazione_TipoRelazione] CHECK ([TipoRelazione]='RECEPISCE' OR [TipoRelazione]='SOSTITUISCE' OR [TipoRelazione]='DERIVA_DA' OR [TipoRelazione]='COLLEGATA_A' OR [TipoRelazione]='INTEGRA' OR [TipoRelazione]='SPECIALIZZA' OR [TipoRelazione]='PARTE_DI' OR [TipoRelazione]='SOTTOFAMIGLIA_DI' OR [TipoRelazione]='COMPRENDE'),
    CONSTRAINT [FK_NormaFamigliaRelazione_Destinazione] FOREIGN KEY ([NormaFamigliaDestinazioneId]) REFERENCES [Standard].[NormaFamiglia] ([NormaFamigliaId]),
    CONSTRAINT [FK_NormaFamigliaRelazione_Origine] FOREIGN KEY ([NormaFamigliaOrigineId]) REFERENCES [Standard].[NormaFamiglia] ([NormaFamigliaId]),
    CONSTRAINT [UQ_NormaFamigliaRelazione] UNIQUE NONCLUSTERED ([NormaFamigliaOrigineId] ASC, [NormaFamigliaDestinazioneId] ASC, [TipoRelazione] ASC),
    CONSTRAINT [UQ_NormaFamigliaRelazione_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[NormaFamigliaRelazioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_NormaFamigliaRelazione_Origine]
    ON [Standard].[NormaFamigliaRelazione]([NormaFamigliaOrigineId] ASC, [TipoRelazione] ASC, [Attivo] ASC)
    INCLUDE([NormaFamigliaDestinazioneId], [Ordine], [Gerarchica]);


GO

CREATE NONCLUSTERED INDEX [IX_NormaFamigliaRelazione_Destinazione]
    ON [Standard].[NormaFamigliaRelazione]([NormaFamigliaDestinazioneId] ASC, [TipoRelazione] ASC, [Attivo] ASC)
    INCLUDE([NormaFamigliaOrigineId], [Ordine], [Gerarchica]);


GO

CREATE NONCLUSTERED INDEX [IX_NormaFamigliaRelazione_Gerarchica]
    ON [Standard].[NormaFamigliaRelazione]([Gerarchica] ASC, [Attivo] ASC)
    INCLUDE([NormaFamigliaOrigineId], [NormaFamigliaDestinazioneId], [TipoRelazione], [Ordine]);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC di creazione della relazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo globale univoco e stabile della relazione, utilizzabile per integrazioni e sincronizzazioni.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC della cancellazione logica della relazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante tecnico iniziale della versione della relazione, gestito automaticamente da SQL Server. Non rappresenta una data normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Relazioni tipizzate, direzionali e versionate tra famiglie normative. La tabella consente di rappresentare gerarchie, sottofamiglie, integrazioni, specializzazioni, derivazioni e altri collegamenti semantici.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se la relazione può essere utilizzata per costruire una gerarchia navigabile. È ammessa per COMPRENDE, SOTTOFAMIGLIA_DI e PARTE_DI.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione', @level2type = N'COLUMN', @level2name = N'Gerarchica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Famiglia verso la quale è diretta la relazione semantica. La relazione si legge: Origine -- TipoRelazione --> Destinazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione', @level2type = N'COLUMN', @level2name = N'NormaFamigliaDestinazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante tecnico finale della versione della relazione, gestito automaticamente da SQL Server. Non rappresenta una data normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata della relazione tra famiglie normative.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione', @level2type = N'COLUMN', @level2name = N'NormaFamigliaRelazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione esplicativa della relazione e del significato attribuito al collegamento tra le due famiglie.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione', @level2type = N'COLUMN', @level2name = N'DescrizioneRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo della relazione direzionale: COMPRENDE, SOTTOFAMIGLIA_DI, PARTE_DI, SPECIALIZZA, INTEGRA, COLLEGATA_A, DERIVA_DA, SOSTITUISCE oppure RECEPISCE.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione', @level2type = N'COLUMN', @level2name = N'TipoRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha creato la relazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Famiglia dalla quale parte la relazione semantica. La relazione si legge: Origine -- TipoRelazione --> Destinazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione', @level2type = N'COLUMN', @level2name = N'NormaFamigliaOrigineId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se la relazione è utilizzabile nei processi applicativi.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ordine di visualizzazione o sequenza della famiglia destinazione all''interno dell''aggregazione o gerarchia di origine.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC dell''ultima modifica applicativa della relazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaRelazione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

