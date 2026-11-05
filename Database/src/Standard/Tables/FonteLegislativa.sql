CREATE TABLE [Standard].[FonteLegislativa] (
    [FonteLegislativaId]      INT                                                IDENTITY (1, 1) NOT NULL,
    [TipoFonteLegislativaId]  INT                                                NOT NULL,
    [CodiceFonte]             VARCHAR (100)                                      NOT NULL,
    [Titolo]                  NVARCHAR (1000)                                    NOT NULL,
    [TitoloBreve]             NVARCHAR (200)                                     NULL,
    [Giurisdizione]           VARCHAR (10)                                       NOT NULL,
    [Numero]                  VARCHAR (50)                                       NOT NULL,
    [Anno]                    SMALLINT                                           NOT NULL,
    [DataAdozione]            DATE                                               NULL,
    [DataPubblicazione]       DATE                                               NULL,
    [DataEntrataInVigore]     DATE                                               NULL,
    [DataApplicazione]        DATE                                               NULL,
    [DataAbrogazione]         DATE                                               NULL,
    [StatoFonteLegislativaId] INT                                                NOT NULL,
    [AutoritaEmittente]       NVARCHAR (300)                                     NULL,
    [FonteUfficialeUrl]       NVARCHAR (1000)                                    NULL,
    [IdentificativoUfficiale] NVARCHAR (200)                                     NULL,
    [Celex]                   VARCHAR (30)                                       NULL,
    [EliUri]                  NVARCHAR (500)                                     NULL,
    [GuriNumero]              VARCHAR (50)                                       NULL,
    [GuriData]                DATE                                               NULL,
    [Note]                    NVARCHAR (2000)                                    NULL,
    [DataCreazione]           DATETIME2 (7)                                      CONSTRAINT [DF_FonteLegislativa_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                INT                                                NULL,
    [DataModifica]            DATETIME2 (7)                                      NULL,
    [ModificatoDa]            INT                                                NULL,
    [DataCancellazione]       DATETIME2 (7)                                      NULL,
    [CancellatoDa]            INT                                                NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER                                   CONSTRAINT [DF_FonteLegislativa_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita]      DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_FonteLegislativa_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]        DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_FonteLegislativa_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_FonteLegislativa] PRIMARY KEY CLUSTERED ([FonteLegislativaId] ASC),
    CONSTRAINT [CK_FonteLegislativa_Anno] CHECK ([Anno]>=(1900) AND [Anno]<=(2100)),
    CONSTRAINT [CK_FonteLegislativa_Cancellazione] CHECK ([DataCancellazione] IS NULL AND [CancellatoDa] IS NULL OR [DataCancellazione] IS NOT NULL),
    CONSTRAINT [CK_FonteLegislativa_CodiceFonte] CHECK (len(ltrim(rtrim([CodiceFonte])))>(0)),
    CONSTRAINT [CK_FonteLegislativa_Giurisdizione] CHECK ([Giurisdizione]='ALTRO' OR [Giurisdizione]='IT' OR [Giurisdizione]='UE'),
    CONSTRAINT [CK_FonteLegislativa_Numero] CHECK (len(ltrim(rtrim([Numero])))>(0)),
    CONSTRAINT [CK_FonteLegislativa_Titolo] CHECK (len(ltrim(rtrim([Titolo])))>(0)),
    CONSTRAINT [FK_FonteLegislativa_StatoFonteLegislativa] FOREIGN KEY ([StatoFonteLegislativaId]) REFERENCES [Standard].[StatoFonteLegislativa] ([StatoFonteLegislativaId]),
    CONSTRAINT [FK_FonteLegislativa_TipoFonteLegislativa] FOREIGN KEY ([TipoFonteLegislativaId]) REFERENCES [Standard].[TipoFonteLegislativa] ([TipoFonteLegislativaId]),
    CONSTRAINT [UQ_FonteLegislativa_CodiceFonte] UNIQUE NONCLUSTERED ([CodiceFonte] ASC),
    CONSTRAINT [UQ_FonteLegislativa_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[FonteLegislativaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_FonteLegislativa_Celex]
    ON [Standard].[FonteLegislativa]([Celex] ASC) WHERE ([Celex] IS NOT NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_FonteLegislativa_Celex]
    ON [Standard].[FonteLegislativa]([Celex] ASC) WHERE ([Celex] IS NOT NULL);


GO

CREATE NONCLUSTERED INDEX [IX_FonteLegislativa_TipoAnno]
    ON [Standard].[FonteLegislativa]([TipoFonteLegislativaId] ASC, [Anno] ASC)
    INCLUDE([CodiceFonte], [Numero], [TitoloBreve], [StatoFonteLegislativaId]);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di inizio applicazione, se differita rispetto alla vigenza.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'DataApplicazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo globale univoco e stabile della riga, utilizzabile per integrazioni e sincronizzazioni.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di adozione dell''atto.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'DataAdozione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Autorità o organo emittente (Ministero, organo UE). Candidato futuro a FK verso Organizzazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'AutoritaEmittente';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo CELEX dell''atto dell''Unione Europea.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'Celex';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data della Gazzetta Ufficiale della Repubblica Italiana.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'GuriData';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata della fonte legislativa/regolatoria.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'FonteLegislativaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo ufficiale generico, usato quando non tipizzato in Celex/EliUri/Guri.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'IdentificativoUfficiale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante tecnico finale della versione della riga, gestito automaticamente da SQL Server.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.StatoFonteLegislativa. Stato corrente dell''atto.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'StatoFonteLegislativaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero della Gazzetta Ufficiale della Repubblica Italiana.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'GuriNumero';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice interno stabile della fonte. Esempi: REG-UE-910-2014, DM-152-2022.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'CodiceFonte';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC di creazione del record applicativo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identità giuridica di una fonte cogente o regolatoria (regolamento, direttiva, decreto, legge). Dato di riferimento trasversale richiamabile da accreditamento, certificazione, ispezione e programmi. Non contiene il testo, né rappresenta norme tecniche (che restano in NormaFamiglia/NormaEdizione) o schemi proprietari (Certificazione.ProgrammaCertificazione).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ordinamento giuridico di appartenenza: UE, IT o ALTRO.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'Giurisdizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'European Legislation Identifier (ELI) dell''atto.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'EliUri';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Denominazione sintetica o acronimo. Esempio: eIDAS.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'TitoloBreve';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.TipoFonteLegislativa. Tipo di atto (regolamento, direttiva, decreto...).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'TipoFonteLegislativaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note libere sulla fonte.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Anno di riferimento dell''atto.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'Anno';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC dell''ultima modifica applicativa del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di entrata in vigore.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'DataEntrataInVigore';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero identificativo dell''atto (testuale: ammette numerazioni composte).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'Numero';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Titolo ufficiale completo dell''atto.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC della cancellazione logica del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di pubblicazione ufficiale.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'DataPubblicazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante tecnico iniziale della versione della riga, gestito automaticamente da SQL Server.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di abrogazione (denormalizzazione comoda; la relazione autoritativa è in FonteLegislativaRelazione).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'DataAbrogazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'URL della fonte ufficiale di pubblicazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativa', @level2type = N'COLUMN', @level2name = N'FonteUfficialeUrl';


GO

