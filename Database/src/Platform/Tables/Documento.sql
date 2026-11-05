CREATE TABLE [Platform].[Documento] (
    [DocumentId]      UNIQUEIDENTIFIER NOT NULL,
    [FileName]        NVARCHAR (500)   NOT NULL,
    [ContentType]     NVARCHAR (200)   NOT NULL,
    [Length]          BIGINT           NOT NULL,
    [StorageProvider] NVARCHAR (50)    NOT NULL,
    [StorageKey]      NVARCHAR (1000)  NOT NULL,
    [Checksum]        NVARCHAR (100)   NULL,
    [VisibilityScope] NVARCHAR (50)    NOT NULL,
    [Module]          NVARCHAR (100)   NOT NULL,
    [OwnerType]       NVARCHAR (100)   NOT NULL,
    [OwnerId]         NVARCHAR (200)   NOT NULL,
    [CreatedAtUtc]    DATETIME2 (7)    NOT NULL,
    [StoredAtUtc]     DATETIME2 (7)    NULL,
    [CartellaId]      UNIQUEIDENTIFIER NULL,
    [UpdatedAtUtc]    DATETIME2 (7)    CONSTRAINT [DF_Documento_Updated] DEFAULT (sysutcdatetime()) NOT NULL,
    [VersionNumber]   INT              CONSTRAINT [DF_Documento_VersionNumber] DEFAULT ((1)) NOT NULL,
    [CreatedBy]       INT              NULL,
    [UpdatedBy]       INT              NULL,
    [DeletedAtUtc]    DATETIME2 (7)    NULL,
    [DeletedBy]       INT              NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_Documento_DataInizio] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_Documento_DataFine] DEFAULT (CONVERT([datetime2],'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_Documento] PRIMARY KEY CLUSTERED ([DocumentId] ASC),
    CONSTRAINT [CK_Documento_VersionNumber] CHECK ([VersionNumber] >= 1),
    CONSTRAINT [FK_Documento_Cartella] FOREIGN KEY ([CartellaId]) REFERENCES [Platform].[Cartella] ([CartellaId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Platform].[DocumentoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_Documento_Owner]
    ON [Platform].[Documento]([OwnerType] ASC, [OwnerId] ASC) WHERE ([StoredAtUtc] IS NOT NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Registro tecnico dei file gestiti dalla piattaforma, con storage provider, storage key, owner e visibilita. E uno strato operativo di storage e non sostituisce Documentale.DocumentoVersione quando serve una versione documentale formale e tracciabile.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del proprietario/oggetto interpretato secondo OwnerType. Campo testuale per compatibilita operativa, non FK business deterministica.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'OwnerId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Provider o backend di storage usato per conservare il file.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'StorageProvider';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC in cui il contenuto e stato effettivamente salvato nello storage. NULL indica file non ancora archiviato o processo incompleto.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'StoredAtUtc';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Checksum/hash del file quando disponibile. Serve a integrita e riconciliazione; per versioni formali privilegiare HashSha256 in Documentale.DocumentoVersione.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Checksum';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'GUID tecnico del file gestito dallo storage di piattaforma. Identifica il record storage, non necessariamente la versione documentale formale in Documentale.DocumentoVersione.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DocumentId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record file nella piattaforma.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'CreatedAtUtc';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave fisica/logica del file nel backend di storage. Deve essere stabile e non contenere significati business non controllati.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'StorageKey';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'MIME type del file. Dato tecnico di storage, non classificazione funzionale del documento.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'ContentType';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK opzionale verso Platform.Cartella per collocazione logica del file.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'CartellaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ambito di visibilita tecnica/applicativa del file, ad esempio interno, CAB o pubblico. Non sostituisce un registro di pubblicazione approvata.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'VisibilityScope';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nome file ricevuto o generato dalla piattaforma. Informazione di presentazione e riconciliazione.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'FileName';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo proprietario/oggetto del file espresso come testo. Relazione polimorfica operativa: richiede controlli applicativi per evitare riferimenti orfani.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'OwnerType';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dimensione del file in byte. Dato tecnico per integrita, quota e diagnostica.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Length';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultimo aggiornamento tecnico del record storage.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'UpdatedAtUtc';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Modulo applicativo che ha prodotto o gestisce il file. Aiuta routing e ownership tecnica, non definisce il dominio normativo.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'Module';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero della versione corrente del file. Parte da 1 e cresce a ogni sostituzione del contenuto: nuovo file, nuova StorageKey, stessa riga. Le versioni precedenti restano in Platform.DocumentoStorico e i loro file non vengono sovrascritti.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'VersionNumber';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IAM.Utente.UtenteId di chi ha caricato la prima versione. NULL per identita non IAM (sviluppo, demo) e per righe precedenti alla storicizzazione.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'CreatedBy';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IAM.Utente.UtenteId di chi ha eseguito l ultima modifica: nuova versione, spostamento o cancellazione.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'UpdatedBy';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica. Il file resta nello storage: la cancellazione non e fisica, per conservare la traccia. Le query operative filtrano DeletedAtUtc IS NULL.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DeletedAtUtc';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IAM.Utente.UtenteId di chi ha cancellato logicamente il documento.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'Documento', @level2type = N'COLUMN', @level2name = N'DeletedBy';


GO

