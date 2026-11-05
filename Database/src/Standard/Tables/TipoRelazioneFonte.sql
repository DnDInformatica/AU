CREATE TABLE [Standard].[TipoRelazioneFonte] (
    [TipoRelazioneFonteId] INT                                                IDENTITY (1, 1) NOT NULL,
    [Codice]               VARCHAR (50)                                       NOT NULL,
    [Descrizione]          NVARCHAR (200)                                     NOT NULL,
    [Attivo]               BIT                                                CONSTRAINT [DF_TipoRelazioneFonte_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]        DATETIME2 (7)                                      CONSTRAINT [DF_TipoRelazioneFonte_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]             INT                                                NULL,
    [DataModifica]         DATETIME2 (7)                                      NULL,
    [ModificatoDa]         INT                                                NULL,
    [DataCancellazione]    DATETIME2 (7)                                      NULL,
    [CancellatoDa]         INT                                                NULL,
    [UniqueRowId]          UNIQUEIDENTIFIER                                   CONSTRAINT [DF_TipoRelazioneFonte_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_TipoRelazioneFonte_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]     DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_TipoRelazioneFonte_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_TipoRelazioneFonte] PRIMARY KEY CLUSTERED ([TipoRelazioneFonteId] ASC),
    CONSTRAINT [CK_TipoRelazioneFonte_Cancellazione] CHECK ([DataCancellazione] IS NULL AND [CancellatoDa] IS NULL OR [DataCancellazione] IS NOT NULL),
    CONSTRAINT [CK_TipoRelazioneFonte_Codice] CHECK (len(ltrim(rtrim([Codice])))>(0)),
    CONSTRAINT [UQ_TipoRelazioneFonte_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    CONSTRAINT [UQ_TipoRelazioneFonte_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[TipoRelazioneFonteStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata della voce di tipologica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoRelazioneFonte', @level2type = N'COLUMN', @level2name = N'TipoRelazioneFonteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoRelazioneFonte', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice mnemonico univoco della voce di tipologica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoRelazioneFonte', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante tecnico iniziale della versione della riga, gestito automaticamente da SQL Server.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoRelazioneFonte', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo globale univoco e stabile della riga, utilizzabile per integrazioni e sincronizzazioni.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoRelazioneFonte', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoRelazioneFonte';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoRelazioneFonte', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipologia delle relazioni tra fonti legislative: modifica, abroga, integra, rettifica, sostituisce, attua, rinvia.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoRelazioneFonte';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoRelazioneFonte';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC della cancellazione logica del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoRelazioneFonte', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoRelazioneFonte', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoRelazioneFonte';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC dell''ultima modifica applicativa del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoRelazioneFonte', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante tecnico finale della versione della riga, gestito automaticamente da SQL Server.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoRelazioneFonte', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione della voce di tipologica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoRelazioneFonte', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC di creazione del record applicativo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoRelazioneFonte', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se la voce è utilizzabile nei processi applicativi.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoRelazioneFonte', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

