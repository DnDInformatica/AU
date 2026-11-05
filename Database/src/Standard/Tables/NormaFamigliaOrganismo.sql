CREATE TABLE [Standard].[NormaFamigliaOrganismo] (
    [NormaFamigliaOrganismoId] INT                                                IDENTITY (1, 1) NOT NULL,
    [NormaFamigliaId]          INT                                                NOT NULL,
    [OrganismoDiNormazioneId]  INT                                                NOT NULL,
    [Ruolo]                    VARCHAR (30)                                       NOT NULL,
    [OrdineDesignazione]       SMALLINT                                           NULL,
    [Attivo]                   BIT                                                CONSTRAINT [DF_NormaFamigliaOrganismo_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]            DATETIME2 (7)                                      CONSTRAINT [DF_NormaFamigliaOrganismo_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                 INT                                                NULL,
    [DataModifica]             DATETIME2 (7)                                      NULL,
    [ModificatoDa]             INT                                                NULL,
    [DataCancellazione]        DATETIME2 (7)                                      NULL,
    [CancellatoDa]             INT                                                NULL,
    [UniqueRowId]              UNIQUEIDENTIFIER                                   CONSTRAINT [DF_NormaFamigliaOrganismo_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_NormaFamigliaOrganismo_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]         DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_NormaFamigliaOrganismo_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_NormaFamigliaOrganismo] PRIMARY KEY CLUSTERED ([NormaFamigliaOrganismoId] ASC),
    CONSTRAINT [CK_NormaFamigliaOrganismo_Ordine] CHECK ([OrdineDesignazione] IS NULL OR [OrdineDesignazione]>(0)),
    CONSTRAINT [CK_NormaFamigliaOrganismo_Ruolo] CHECK ([Ruolo]='PUBBLICATORE' OR [Ruolo]='ADOTTANTE_NAZIONALE' OR [Ruolo]='ADOTTANTE_EUROPEO' OR [Ruolo]='CO_ORIGINARIO' OR [Ruolo]='ORIGINARIO'),
    CONSTRAINT [FK_NormaFamigliaOrganismo_OrganismoDiNormazione] FOREIGN KEY ([OrganismoDiNormazioneId]) REFERENCES [Standard].[OrganismoDiNormazione] ([OrganismoDiNormazioneId]),
    CONSTRAINT [UQ_NormaFamigliaOrganismo] UNIQUE NONCLUSTERED ([NormaFamigliaId] ASC, [OrganismoDiNormazioneId] ASC, [Ruolo] ASC),
    CONSTRAINT [UQ_NormaFamigliaOrganismo_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[NormaFamigliaOrganismoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC dell''ultima modifica applicativa del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaOrganismo', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se la relazione è utilizzabile nei processi applicativi.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaOrganismo', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.OrganismoDiNormazione. Organismo associato alla famiglia.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaOrganismo', @level2type = N'COLUMN', @level2name = N'OrganismoDiNormazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tabella associativa molti-a-molti tra famiglie normative e organismi di normazione. Consente di rappresentare designazioni composte (ISO/IEC, CEN/CENELEC) e ruoli distinti (originario, co-originario, adottante, pubblicatore) per la stessa famiglia.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaOrganismo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaOrganismo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante tecnico finale della versione della riga, gestito automaticamente da SQL Server.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaOrganismo', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaOrganismo', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ruolo dell''organismo rispetto alla famiglia: ORIGINARIO, CO_ORIGINARIO, ADOTTANTE_EUROPEO, ADOTTANTE_NAZIONALE, PUBBLICATORE.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaOrganismo', @level2type = N'COLUMN', @level2name = N'Ruolo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata della relazione famiglia-organismo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaOrganismo', @level2type = N'COLUMN', @level2name = N'NormaFamigliaOrganismoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaOrganismo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo globale univoco e stabile della riga, utilizzabile per integrazioni e sincronizzazioni.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaOrganismo', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaOrganismo', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC di creazione del record applicativo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaOrganismo', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante tecnico iniziale della versione della riga, gestito automaticamente da SQL Server.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaOrganismo', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC della cancellazione logica del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaOrganismo', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaOrganismo', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ordine con cui la sigla dell''organismo compare nella designazione. Esempio: ISO=1, IEC=2 per ISO/IEC; CEN=1, CENELEC=2.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaOrganismo', @level2type = N'COLUMN', @level2name = N'OrdineDesignazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.NormaFamiglia. Famiglia normativa coinvolta nella relazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaOrganismo', @level2type = N'COLUMN', @level2name = N'NormaFamigliaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaOrganismo';


GO

