CREATE TABLE [Standard].[NormaEdizioneSettore] (
    [NormaEdizioneSettoreId] INT                                                IDENTITY (1, 1) NOT NULL,
    [NormaEdizioneId]        INT                                                NOT NULL,
    [SettoreAccrediaId]      INT                                                NOT NULL,
    [OrigineDato]            NVARCHAR (50)                                      NOT NULL,
    [Note]                   NVARCHAR (500)                                     NULL,
    [Attivo]                 BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]          DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]               INT                                                NULL,
    [DataModifica]           DATETIME2 (7)                                      NULL,
    [ModificatoDa]           INT                                                NULL,
    [DataCancellazione]      DATETIME2 (7)                                      NULL,
    [CancellatoDa]           INT                                                NULL,
    [UniqueRowId]            UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]     DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_NormaEdizioneSettore] PRIMARY KEY CLUSTERED ([NormaEdizioneSettoreId] ASC),
    CONSTRAINT [CK_NormaEdizioneSettore_OrigineDato] CHECK ([OrigineDato]=N'Migrazione' OR [OrigineDato]=N'Manuale' OR [OrigineDato]=N'NormaEdizioneDipartimento' OR [OrigineDato]=N'NormaClassificazioneAccredia'),
    CONSTRAINT [FK_NormaEdizioneSettore_NormaEdizione] FOREIGN KEY ([NormaEdizioneId]) REFERENCES [Standard].[NormaEdizione] ([NormaEdizioneId]),
    CONSTRAINT [FK_NormaEdizioneSettore_SettoreAccredia] FOREIGN KEY ([SettoreAccrediaId]) REFERENCES [Tipologica].[SettoreAccredia] ([SettoreAccrediaId]),
    CONSTRAINT [UQ_NormaEdizioneSettore] UNIQUE NONCLUSTERED ([NormaEdizioneId] ASC, [SettoreAccrediaId] ASC, [OrigineDato] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[NormaEdizioneSettoreStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Associazione normalizzata tra edizione normativa e settore Accredia.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSettore';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso il settore Accredia applicabile all''edizione normativa. Serve per controlli di scopo, certificazione e pubblicazione evitando settori testuali non normalizzati.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSettore', @level2type = N'COLUMN', @level2name = N'SettoreAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSettore';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio validita business dell''associazione edizione-settore.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSettore', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data UTC dell’ultima modifica dell’associazione norma-settore.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSettore', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine validita business dell''associazione edizione-settore.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSettore', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se l’associazione norma-settore è attiva.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSettore', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data UTC di creazione dell’associazione norma-settore.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSettore', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Utente o processo che ha modificato l’associazione norma-settore.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSettore', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Origine del mapping tra edizione e settore, ad esempio migrazione, classificazione ACCREDIA, mapping manuale o fonte esterna.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSettore', @level2type = N'COLUMN', @level2name = N'OrigineDato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSettore';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata dell''associazione tra edizione normativa e settore Accredia.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSettore', @level2type = N'COLUMN', @level2name = N'NormaEdizioneSettoreId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Utente o processo che ha creato l’associazione norma-settore.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSettore', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.NormaEdizione. Collega la specifica edizione ai settori o ambiti Accredia applicabili.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSettore', @level2type = N'COLUMN', @level2name = N'NormaEdizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note descrittive dell’associazione norma-settore.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSettore', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneSettore';


GO

