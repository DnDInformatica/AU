/*
    20261103_platform_documento_storicizzazione.sql
    Database di destinazione: **Accredia_SIDAC**

    Storicizzazione e versioni dei documenti del Portale (WebDirectory e
    Struttura CAB).

    PERCHE'. Nel Portale la cancellazione di un documento era fisica: il file
    spariva dallo storage e la riga da Platform.Documento, senza traccia. Era il
    rischio principale gia' del vecchio portale Anthesi (Struttura CAB: il CAB
    poteva cancellare documenti e struttura senza traccia). Non esistevano
    nemmeno le versioni: ogni caricamento era un documento nuovo, scollegato
    dal precedente.

    COSA FA
    1. Platform.Documento:
       - VersionNumber (parte da 1, cresce a ogni sostituzione del file);
       - CreatedBy, UpdatedBy, DeletedBy (IAM.Utente.UtenteId, senza FK come
         CreatoDa/ModificatoDa nel resto di SIDAC);
       - DeletedAtUtc per la cancellazione logica;
       - storicizzazione di sistema su Platform.DocumentoStorico.
    2. Platform.Cartella: CreatedBy, UpdatedBy, DeletedBy e storicizzazione su
       Platform.CartellaStorico. DeletedAtUtc esisteva gia'.

    VERSIONI. Una nuova versione aggiorna la stessa riga con un nuovo file e una
    nuova StorageKey; la riga precedente, con la sua StorageKey, resta nello
    storico. I file delle versioni precedenti non vengono mai sovrascritti.

    LIMITE NOTO. La storicizzazione registra quando, non chi: per questo le
    colonne *By. Le righe gia' presenti (2 + 2 il 2026-11-03) restano con
    VersionNumber 1 e autore NULL.

    Le definizioni allineate sono in Database/src/Platform/Tables.
    Da eseguire in SSMS, non tramite MCP. Rieseguibile.
*/

SET XACT_ABORT ON;
SET NOCOUNT ON;
GO

IF DB_NAME() <> N'Accredia_SIDAC'
BEGIN
    DECLARE @dbCorrente SYSNAME = DB_NAME();
    RAISERROR (N'Script destinato ad Accredia_SIDAC, eseguito su %s. Interrotto.', 16, 1, @dbCorrente);
    RETURN;
END
GO

/* ── 1. Platform.Documento: colonne di versione, autore e cancellazione logica ── */
IF DB_NAME() <> N'Accredia_SIDAC' RETURN;

IF COL_LENGTH(N'Platform.Documento', N'VersionNumber') IS NULL
    ALTER TABLE [Platform].[Documento] ADD
        [VersionNumber] INT           CONSTRAINT [DF_Documento_VersionNumber] DEFAULT ((1)) NOT NULL,
        [CreatedBy]     INT           NULL,
        [UpdatedBy]     INT           NULL,
        [DeletedAtUtc]  DATETIME2 (7) NULL,
        [DeletedBy]     INT           NULL;
GO

IF DB_NAME() <> N'Accredia_SIDAC' RETURN;

IF OBJECT_ID(N'Platform.CK_Documento_VersionNumber', N'C') IS NULL
    ALTER TABLE [Platform].[Documento] ADD CONSTRAINT [CK_Documento_VersionNumber] CHECK ([VersionNumber] >= 1);
GO

/* ── 2. Platform.Documento: periodo e storicizzazione ── */
IF DB_NAME() <> N'Accredia_SIDAC' RETURN;

IF COL_LENGTH(N'Platform.Documento', N'DataInizioValidita') IS NULL
    ALTER TABLE [Platform].[Documento] ADD
        [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN
            CONSTRAINT [DF_Documento_DataInizio] DEFAULT (sysutcdatetime()) NOT NULL,
        [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN
            CONSTRAINT [DF_Documento_DataFine] DEFAULT (CONVERT([datetime2], '9999-12-31 23:59:59.9999999')) NOT NULL,
        PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita]);
GO

IF DB_NAME() <> N'Accredia_SIDAC' RETURN;

IF OBJECT_ID(N'Platform.DocumentoStorico', N'U') IS NULL
BEGIN
    CREATE TABLE [Platform].[DocumentoStorico] (
        [DocumentId]         UNIQUEIDENTIFIER NOT NULL,
        [FileName]           NVARCHAR (500)   NOT NULL,
        [ContentType]        NVARCHAR (200)   NOT NULL,
        [Length]             BIGINT           NOT NULL,
        [StorageProvider]    NVARCHAR (50)    NOT NULL,
        [StorageKey]         NVARCHAR (1000)  NOT NULL,
        [Checksum]           NVARCHAR (100)   NULL,
        [VisibilityScope]    NVARCHAR (50)    NOT NULL,
        [Module]             NVARCHAR (100)   NOT NULL,
        [OwnerType]          NVARCHAR (100)   NOT NULL,
        [OwnerId]            NVARCHAR (200)   NOT NULL,
        [CreatedAtUtc]       DATETIME2 (7)    NOT NULL,
        [StoredAtUtc]        DATETIME2 (7)    NULL,
        [CartellaId]         UNIQUEIDENTIFIER NULL,
        [UpdatedAtUtc]       DATETIME2 (7)    NOT NULL,
        [VersionNumber]      INT              NOT NULL,
        [CreatedBy]          INT              NULL,
        [UpdatedBy]          INT              NULL,
        [DeletedAtUtc]       DATETIME2 (7)    NULL,
        [DeletedBy]          INT              NULL,
        [DataInizioValidita] DATETIME2 (7)    NOT NULL,
        [DataFineValidita]   DATETIME2 (7)    NOT NULL
    );
    CREATE CLUSTERED INDEX [CIX_DocumentoStorico_Periodo]
        ON [Platform].[DocumentoStorico]([DataInizioValidita] ASC, [DataFineValidita] ASC);
    CREATE NONCLUSTERED INDEX [IX_DocumentoStorico_Documento]
        ON [Platform].[DocumentoStorico]([DocumentId] ASC, [DataFineValidita] ASC);
END
GO

IF DB_NAME() <> N'Accredia_SIDAC' RETURN;

IF (SELECT temporal_type FROM sys.tables WHERE object_id = OBJECT_ID(N'Platform.Documento')) = 0
    ALTER TABLE [Platform].[Documento]
        SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [Platform].[DocumentoStorico], DATA_CONSISTENCY_CHECK = ON));
GO

/* ── 3. Platform.Cartella: autore e storicizzazione ── */
IF DB_NAME() <> N'Accredia_SIDAC' RETURN;

IF COL_LENGTH(N'Platform.Cartella', N'CreatedBy') IS NULL
    ALTER TABLE [Platform].[Cartella] ADD
        [CreatedBy] INT NULL,
        [UpdatedBy] INT NULL,
        [DeletedBy] INT NULL;
GO

IF DB_NAME() <> N'Accredia_SIDAC' RETURN;

IF COL_LENGTH(N'Platform.Cartella', N'DataInizioValidita') IS NULL
    ALTER TABLE [Platform].[Cartella] ADD
        [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN
            CONSTRAINT [DF_Cartella_DataInizio] DEFAULT (sysutcdatetime()) NOT NULL,
        [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN
            CONSTRAINT [DF_Cartella_DataFine] DEFAULT (CONVERT([datetime2], '9999-12-31 23:59:59.9999999')) NOT NULL,
        PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita]);
GO

IF DB_NAME() <> N'Accredia_SIDAC' RETURN;

IF OBJECT_ID(N'Platform.CartellaStorico', N'U') IS NULL
BEGIN
    CREATE TABLE [Platform].[CartellaStorico] (
        [CartellaId]         UNIQUEIDENTIFIER NOT NULL,
        [OdcId]              INT              NOT NULL,
        [Nome]               NVARCHAR (200)   NOT NULL,
        [ParentId]           UNIQUEIDENTIFIER NULL,
        [CreatedAtUtc]       DATETIME2 (7)    NOT NULL,
        [UpdatedAtUtc]       DATETIME2 (7)    NOT NULL,
        [DeletedAtUtc]       DATETIME2 (7)    NULL,
        [CreatedBy]          INT              NULL,
        [UpdatedBy]          INT              NULL,
        [DeletedBy]          INT              NULL,
        [DataInizioValidita] DATETIME2 (7)    NOT NULL,
        [DataFineValidita]   DATETIME2 (7)    NOT NULL
    );
    CREATE CLUSTERED INDEX [CIX_CartellaStorico_Periodo]
        ON [Platform].[CartellaStorico]([DataInizioValidita] ASC, [DataFineValidita] ASC);
END
GO

IF DB_NAME() <> N'Accredia_SIDAC' RETURN;

IF (SELECT temporal_type FROM sys.tables WHERE object_id = OBJECT_ID(N'Platform.Cartella')) = 0
    ALTER TABLE [Platform].[Cartella]
        SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [Platform].[CartellaStorico], DATA_CONSISTENCY_CHECK = ON));
GO

/* ── 4. Descrizioni ── */
IF DB_NAME() <> N'Accredia_SIDAC' RETURN;

DECLARE @descrizioni TABLE (Tabella SYSNAME, Colonna SYSNAME NULL, Testo NVARCHAR (1000));
INSERT INTO @descrizioni VALUES
    (N'Documento', N'VersionNumber', N'Numero della versione corrente del file. Parte da 1 e cresce a ogni sostituzione del contenuto: nuovo file, nuova StorageKey, stessa riga. Le versioni precedenti restano in Platform.DocumentoStorico e i loro file non vengono sovrascritti.'),
    (N'Documento', N'CreatedBy', N'IAM.Utente.UtenteId di chi ha caricato la prima versione. NULL per identita non IAM (sviluppo, demo) e per righe precedenti alla storicizzazione.'),
    (N'Documento', N'UpdatedBy', N'IAM.Utente.UtenteId di chi ha eseguito l ultima modifica: nuova versione, spostamento o cancellazione.'),
    (N'Documento', N'DeletedAtUtc', N'Timestamp UTC di cancellazione logica. Il file resta nello storage: la cancellazione non e fisica, per conservare la traccia. Le query operative filtrano DeletedAtUtc IS NULL.'),
    (N'Documento', N'DeletedBy', N'IAM.Utente.UtenteId di chi ha cancellato logicamente il documento.'),
    (N'Cartella', N'CreatedBy', N'IAM.Utente.UtenteId di chi ha creato la cartella. NULL per identita non IAM (sviluppo, demo) e per righe precedenti alla storicizzazione.'),
    (N'Cartella', N'UpdatedBy', N'IAM.Utente.UtenteId di chi ha eseguito l ultima modifica (ridenominazione, spostamento).'),
    (N'Cartella', N'DeletedBy', N'IAM.Utente.UtenteId di chi ha cancellato logicamente la cartella.'),
    (N'DocumentoStorico', NULL, N'Storico di sistema di Platform.Documento: le versioni precedenti dei file, con la StorageKey di ciascuna, e lo stato delle righe prima di ogni modifica o cancellazione logica.'),
    (N'CartellaStorico', NULL, N'Storico di sistema di Platform.Cartella: stato delle cartelle prima di ogni ridenominazione, spostamento o cancellazione logica.');

DECLARE @tabella SYSNAME, @colonna SYSNAME, @testo NVARCHAR (1000);
DECLARE cur CURSOR LOCAL FAST_FORWARD FOR SELECT Tabella, Colonna, Testo FROM @descrizioni;
OPEN cur;
FETCH NEXT FROM cur INTO @tabella, @colonna, @testo;
WHILE @@FETCH_STATUS = 0
BEGIN
    IF EXISTS (
        SELECT 1 FROM sys.extended_properties ep
        WHERE ep.name = N'MS_Description'
          AND ep.major_id = OBJECT_ID(N'Platform.' + @tabella)
          AND ep.minor_id = COALESCE(COLUMNPROPERTY(OBJECT_ID(N'Platform.' + @tabella), @colonna, 'ColumnId'), 0))
    BEGIN
        IF @colonna IS NULL
            EXEC sp_updateextendedproperty N'MS_Description', @testo, N'SCHEMA', N'Platform', N'TABLE', @tabella;
        ELSE
            EXEC sp_updateextendedproperty N'MS_Description', @testo, N'SCHEMA', N'Platform', N'TABLE', @tabella, N'COLUMN', @colonna;
    END
    ELSE
    BEGIN
        IF @colonna IS NULL
            EXEC sp_addextendedproperty N'MS_Description', @testo, N'SCHEMA', N'Platform', N'TABLE', @tabella;
        ELSE
            EXEC sp_addextendedproperty N'MS_Description', @testo, N'SCHEMA', N'Platform', N'TABLE', @tabella, N'COLUMN', @colonna;
    END
    FETCH NEXT FROM cur INTO @tabella, @colonna, @testo;
END
CLOSE cur;
DEALLOCATE cur;
GO

/* ── 5. Verifica ── */
IF DB_NAME() <> N'Accredia_SIDAC' RETURN;

SELECT t.name AS Tabella,
       t.temporal_type_desc AS Storicizzazione,
       OBJECT_NAME(t.history_table_id) AS TabellaStorico,
       (SELECT COUNT(*) FROM sys.columns c WHERE c.object_id = t.object_id) AS Colonne,
       (SELECT SUM(p.rows) FROM sys.partitions p WHERE p.object_id = t.object_id AND p.index_id IN (0, 1)) AS Righe
FROM sys.tables t
WHERE t.object_id IN (OBJECT_ID(N'Platform.Documento'), OBJECT_ID(N'Platform.Cartella'));
GO
