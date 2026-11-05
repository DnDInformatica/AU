CREATE TABLE [Standard].[FonteLegislativaPartizione] (
    [FonteLegislativaPartizioneId] INT                                                IDENTITY (1, 1) NOT NULL,
    [FonteLegislativaId]           INT                                                NOT NULL,
    [ParentPartizioneId]           INT                                                NULL,
    [TipoPartizioneFonteId]        INT                                                NOT NULL,
    [CodicePartizione]             VARCHAR (100)                                      NOT NULL,
    [TitoloPartizione]             NVARCHAR (500)                                     NULL,
    [Descrizione]                  NVARCHAR (2000)                                    NULL,
    [Ordinamento]                  INT                                                NULL,
    [PartizioneInteraFonte]        BIT                                                CONSTRAINT [DF_FonteLegislativaPartizione_Intera] DEFAULT ((0)) NOT NULL,
    [DataCreazione]                DATETIME2 (7)                                      CONSTRAINT [DF_FonteLegislativaPartizione_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                     INT                                                NULL,
    [DataModifica]                 DATETIME2 (7)                                      NULL,
    [ModificatoDa]                 INT                                                NULL,
    [DataCancellazione]            DATETIME2 (7)                                      NULL,
    [CancellatoDa]                 INT                                                NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER                                   CONSTRAINT [DF_FonteLegislativaPartizione_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita]           DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_FonteLegislativaPartizione_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]             DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_FonteLegislativaPartizione_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_FonteLegislativaPartizione] PRIMARY KEY CLUSTERED ([FonteLegislativaPartizioneId] ASC),
    CONSTRAINT [CK_FonteLegislativaPartizione_Cancellazione] CHECK ([DataCancellazione] IS NULL AND [CancellatoDa] IS NULL OR [DataCancellazione] IS NOT NULL),
    CONSTRAINT [CK_FonteLegislativaPartizione_CodicePartizione] CHECK (len(ltrim(rtrim([CodicePartizione])))>(0)),
    CONSTRAINT [CK_FonteLegislativaPartizione_InteraTipo] CHECK ([PartizioneInteraFonte]=(1) AND [TipoPartizioneFonteId]=(1) OR [PartizioneInteraFonte]=(0) AND [TipoPartizioneFonteId]<>(1)),
    CONSTRAINT [CK_FonteLegislativaPartizione_NoSelf] CHECK ([ParentPartizioneId] IS NULL OR [ParentPartizioneId]<>[FonteLegislativaPartizioneId]),
    CONSTRAINT [FK_FonteLegislativaPartizione_FonteLegislativa] FOREIGN KEY ([FonteLegislativaId]) REFERENCES [Standard].[FonteLegislativa] ([FonteLegislativaId]),
    CONSTRAINT [FK_FonteLegislativaPartizione_Parent] FOREIGN KEY ([ParentPartizioneId]) REFERENCES [Standard].[FonteLegislativaPartizione] ([FonteLegislativaPartizioneId]),
    CONSTRAINT [FK_FonteLegislativaPartizione_ParentSameFonte] FOREIGN KEY ([ParentPartizioneId], [FonteLegislativaId]) REFERENCES [Standard].[FonteLegislativaPartizione] ([FonteLegislativaPartizioneId], [FonteLegislativaId]),
    CONSTRAINT [FK_FonteLegislativaPartizione_TipoPartizioneFonte] FOREIGN KEY ([TipoPartizioneFonteId]) REFERENCES [Standard].[TipoPartizioneFonte] ([TipoPartizioneFonteId]),
    CONSTRAINT [UQ_FonteLegislativaPartizione] UNIQUE NONCLUSTERED ([FonteLegislativaId] ASC, [ParentPartizioneId] ASC, [TipoPartizioneFonteId] ASC, [CodicePartizione] ASC),
    CONSTRAINT [UQ_FonteLegislativaPartizione_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[FonteLegislativaPartizioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_FonteLegislativaPartizione_IdFonte]
    ON [Standard].[FonteLegislativaPartizione]([FonteLegislativaPartizioneId] ASC, [FonteLegislativaId] ASC);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_FonteLegislativaPartizione_InteraFonte]
    ON [Standard].[FonteLegislativaPartizione]([FonteLegislativaId] ASC) WHERE ([PartizioneInteraFonte]=(1) AND [DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_FonteLegislativaPartizione_Fonte]
    ON [Standard].[FonteLegislativaPartizione]([FonteLegislativaId] ASC, [ParentPartizioneId] ASC)
    INCLUDE([TipoPartizioneFonteId], [CodicePartizione], [Ordinamento], [PartizioneInteraFonte]);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo globale univoco e stabile della riga, utilizzabile per integrazioni e sincronizzazioni.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento della partizione. Esempi: art. 24, Allegato III, Modulo H.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione', @level2type = N'COLUMN', @level2name = N'CodicePartizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ordine di presentazione stabile tra partizioni di pari livello.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione', @level2type = N'COLUMN', @level2name = N'Ordinamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Partizione di una fonte legislativa (articolo, comma, allegato, modulo...), gerarchica tramite ParentPartizioneId. La partizione canonica "intera fonte" è il target uniforme dei richiami.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante tecnico finale della versione della riga, gestito automaticamente da SQL Server.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC di creazione del record applicativo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.FonteLegislativa. Fonte a cui appartiene la partizione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione', @level2type = N'COLUMN', @level2name = N'FonteLegislativaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC dell''ultima modifica applicativa del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata della partizione della fonte.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione', @level2type = N'COLUMN', @level2name = N'FonteLegislativaPartizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del soggetto applicativo che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.TipoPartizioneFonte. Tipo di partizione (articolo, allegato, modulo...).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione', @level2type = N'COLUMN', @level2name = N'TipoPartizioneFonteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione della partizione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC della cancellazione logica del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK auto-referenziante verso la partizione padre, per l''annidamento (es. Allegato III contiene Modulo H).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione', @level2type = N'COLUMN', @level2name = N'ParentPartizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Titolo o rubrica della partizione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione', @level2type = N'COLUMN', @level2name = N'TitoloPartizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante tecnico iniziale della versione della riga, gestito automaticamente da SQL Server.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag della partizione canonica che rappresenta l''intera fonte; target uniforme dei richiami.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'FonteLegislativaPartizione', @level2type = N'COLUMN', @level2name = N'PartizioneInteraFonte';


GO

