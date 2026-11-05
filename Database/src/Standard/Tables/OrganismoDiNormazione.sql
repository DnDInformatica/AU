CREATE TABLE [Standard].[OrganismoDiNormazione] (
    [OrganismoDiNormazioneId] INT                                                IDENTITY (1, 1) NOT NULL,
    [OrganizzazioneId]        INT                                                NOT NULL,
    [LivelloNormazioneId]     INT                                                NOT NULL,
    [Codice]                  VARCHAR (20)                                       NOT NULL,
    [Denominazione]           NVARCHAR (250)                                     NOT NULL,
    [AmbitoCompetenza]        NVARCHAR (500)                                     NULL,
    [SitoWeb]                 NVARCHAR (500)                                     NULL,
    [Attivo]                  BIT                                                CONSTRAINT [DF_OrganismoDiNormazione_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]           DATETIME2 (7)                                      CONSTRAINT [DF_OrganismoDiNormazione_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                INT                                                NULL,
    [DataModifica]            DATETIME2 (7)                                      NULL,
    [ModificatoDa]            INT                                                NULL,
    [DataCancellazione]       DATETIME2 (7)                                      NULL,
    [CancellatoDa]            INT                                                NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER                                   CONSTRAINT [DF_OrganismoDiNormazione_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita]      DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_OrganismoDiNormazione_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]        DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_OrganismoDiNormazione_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_OrganismoDiNormazione] PRIMARY KEY CLUSTERED ([OrganismoDiNormazioneId] ASC),
    CONSTRAINT [CK_OrganismoDiNormazione_Cancellazione] CHECK ([DataCancellazione] IS NULL AND [CancellatoDa] IS NULL OR [DataCancellazione] IS NOT NULL),
    CONSTRAINT [CK_OrganismoDiNormazione_Codice] CHECK (len(ltrim(rtrim([Codice])))>(0) AND [Codice]=upper([Codice])),
    CONSTRAINT [CK_OrganismoDiNormazione_Denominazione] CHECK (len(ltrim(rtrim([Denominazione])))>(0)),
    CONSTRAINT [CK_OrganismoDiNormazione_SitoWeb] CHECK ([SitoWeb] IS NULL OR [SitoWeb] like N'http://%' OR [SitoWeb] like N'https://%'),
    CONSTRAINT [FK_OrganismoDiNormazione_LivelloNormazione] FOREIGN KEY ([LivelloNormazioneId]) REFERENCES [Standard].[LivelloNormazione] ([LivelloNormazioneId]),
    CONSTRAINT [FK_OrganismoDiNormazione_Organizzazione] FOREIGN KEY ([OrganizzazioneId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId]),
    CONSTRAINT [UQ_OrganismoDiNormazione_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    CONSTRAINT [UQ_OrganismoDiNormazione_OrganizzazioneId] UNIQUE NONCLUSTERED ([OrganizzazioneId] ASC),
    CONSTRAINT [UQ_OrganismoDiNormazione_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[OrganismoDiNormazioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_OrganismoDiNormazione_LivelloNormazioneId]
    ON [Standard].[OrganismoDiNormazione]([LivelloNormazioneId] ASC)
    INCLUDE([Codice], [Denominazione], [Attivo]);


GO

CREATE NONCLUSTERED INDEX [IX_OrganismoDiNormazione_Attivo]
    ON [Standard].[OrganismoDiNormazione]([Attivo] ASC)
    INCLUDE([Codice], [Denominazione], [LivelloNormazioneId]);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se il record è utilizzabile nei processi applicativi.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata dell''organismo di normazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione', @level2type = N'COLUMN', @level2name = N'OrganismoDiNormazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC dell''ultima modifica applicativa del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice breve e univoco dell''organismo. Esempi: ISO, IEC, UNI, CEI, CEN, CENELEC.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK 1:1 verso Organizzazioni.Organizzazione. Collega la specializzazione all''anagrafica generale dell''organizzazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Denominazione estesa dell''organismo di normazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo globale univoco e stabile della riga, utilizzabile per integrazioni e sincronizzazioni.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC della cancellazione logica del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.LivelloNormazione. Livello dell''organismo: nazionale, europeo, internazionale o sovranazionale.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione', @level2type = N'COLUMN', @level2name = N'LivelloNormazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante tecnico iniziale della versione della riga, gestito automaticamente da SQL Server.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ambito tecnico o settoriale di competenza dell''organismo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione', @level2type = N'COLUMN', @level2name = N'AmbitoCompetenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC di creazione del record applicativo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'URL del sito web istituzionale dell''organismo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione', @level2type = N'COLUMN', @level2name = N'SitoWeb';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Specializzazione degli organismi di normazione: proietta un''Organizzazione nel ruolo di ente emittente di norme e schemi, con il relativo livello di normazione. Relazione 1:1 con Organizzazioni.Organizzazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante tecnico finale della versione della riga, gestito automaticamente da SQL Server.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OrganismoDiNormazione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

