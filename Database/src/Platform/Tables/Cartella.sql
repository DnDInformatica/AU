CREATE TABLE [Platform].[Cartella] (
    [CartellaId]   UNIQUEIDENTIFIER CONSTRAINT [DF_Cartella_Id] DEFAULT (newsequentialid()) NOT NULL,
    [OdcId]        INT              NOT NULL,
    [Nome]         NVARCHAR (200)   NOT NULL,
    [ParentId]     UNIQUEIDENTIFIER NULL,
    [CreatedAtUtc] DATETIME2 (7)    CONSTRAINT [DF_Cartella_Created] DEFAULT (sysutcdatetime()) NOT NULL,
    [UpdatedAtUtc] DATETIME2 (7)    CONSTRAINT [DF_Cartella_Updated] DEFAULT (sysutcdatetime()) NOT NULL,
    [DeletedAtUtc] DATETIME2 (7)    NULL,
    [CreatedBy]    INT              NULL,
    [UpdatedBy]    INT              NULL,
    [DeletedBy]    INT              NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_Cartella_DataInizio] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_Cartella_DataFine] DEFAULT (CONVERT([datetime2],'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_Cartella] PRIMARY KEY CLUSTERED ([CartellaId] ASC),
    CONSTRAINT [FK_Cartella_Parent] FOREIGN KEY ([ParentId]) REFERENCES [Platform].[Cartella] ([CartellaId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Platform].[CartellaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_Cartella_OdcId]
    ON [Platform].[Cartella]([OdcId] ASC) WHERE ([DeletedAtUtc] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''ODC/CAB proprietario o destinatario della cartella. Verificare il collegamento fisico al modello organizzazioni/CAB quando diventa criterio autorizzativo.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Cartella', @level2type = N'COLUMN', @level2name = N'OdcId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica della cartella. Le query operative devono filtrare DeletedAtUtc IS NULL dove richiesto.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Cartella', @level2type = N'COLUMN', @level2name = N'DeletedAtUtc';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK autoreferenziale verso la cartella padre. Consente gerarchie di cartelle; controllare assenza di cicli a livello applicativo o con regole dedicate.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Cartella', @level2type = N'COLUMN', @level2name = N'ParentId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nome della cartella visualizzata nella piattaforma. Non deve contenere dati strutturali non rappresentati altrove.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Cartella', @level2type = N'COLUMN', @level2name = N'Nome';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione della cartella.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Cartella', @level2type = N'COLUMN', @level2name = N'CreatedAtUtc';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'GUID tecnico della cartella logica nella piattaforma.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Cartella', @level2type = N'COLUMN', @level2name = N'CartellaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultimo aggiornamento della cartella.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Cartella', @level2type = N'COLUMN', @level2name = N'UpdatedAtUtc';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Albero logico di cartelle per CAB/ODC nella piattaforma. Serve all''organizzazione documentale operativa e non rappresenta una pratica, uno scopo o una pubblicazione.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Cartella';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IAM.Utente.UtenteId di chi ha creato la cartella. NULL per identita non IAM (sviluppo, demo) e per righe precedenti alla storicizzazione.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Cartella', @level2type = N'COLUMN', @level2name = N'CreatedBy';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IAM.Utente.UtenteId di chi ha eseguito l ultima modifica (ridenominazione, spostamento).', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Cartella', @level2type = N'COLUMN', @level2name = N'UpdatedBy';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IAM.Utente.UtenteId di chi ha cancellato logicamente la cartella.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Cartella', @level2type = N'COLUMN', @level2name = N'DeletedBy';


GO

