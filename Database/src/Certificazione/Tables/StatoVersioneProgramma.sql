CREATE TABLE [Certificazione].[StatoVersioneProgramma] (
    [StatoVersioneProgrammaId] INT                                                IDENTITY (1, 1) NOT NULL,
    [Codice]                   VARCHAR (30)                                       NOT NULL,
    [Descrizione]              NVARCHAR (400)                                     NOT NULL,
    [Attivo]                   BIT                                                CONSTRAINT [DF_StatoVersioneProgramma_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]            DATETIME2 (7)                                      CONSTRAINT [DF_StatoVersioneProgramma_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                 INT                                                NULL,
    [DataModifica]             DATETIME2 (7)                                      NULL,
    [ModificatoDa]             INT                                                NULL,
    [DataCancellazione]        DATETIME2 (7)                                      NULL,
    [CancellatoDa]             INT                                                NULL,
    [UniqueRowId]              UNIQUEIDENTIFIER                                   CONSTRAINT [DF_StatoVersioneProgramma_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_StatoVersioneProgramma_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]         DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_StatoVersioneProgramma_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_StatoVersioneProgramma] PRIMARY KEY CLUSTERED ([StatoVersioneProgrammaId] ASC),
    CONSTRAINT [CK_StatoVersioneProgramma_Cancellazione] CHECK ([DataCancellazione] IS NULL AND [CancellatoDa] IS NULL OR [DataCancellazione] IS NOT NULL),
    CONSTRAINT [CK_StatoVersioneProgramma_Codice] CHECK (len(ltrim(rtrim([Codice])))>(0)),
    CONSTRAINT [UQ_StatoVersioneProgramma_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    CONSTRAINT [UQ_StatoVersioneProgramma_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Certificazione].[StatoVersioneProgrammaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'StatoVersioneProgramma';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo univoco tecnico stabile della riga, utile per tracciamento, import e integrazione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'StatoVersioneProgramma', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC dell''ultima modifica applicativa del record, se disponibile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'StatoVersioneProgramma', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione funzionale dello stato versione programma.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'StatoVersioneProgramma', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice stabile dello stato versione programma.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'StatoVersioneProgramma', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'StatoVersioneProgramma';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Colonna tecnica di fine periodo SYSTEM_VERSIONING (hidden). Non rappresenta validità business.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'StatoVersioneProgramma', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''utente o processo che ha cancellato logicamente il record, se disponibile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'StatoVersioneProgramma', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''utente o processo che ha creato il record, se disponibile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'StatoVersioneProgramma', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo tecnico dello stato versione programma.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'StatoVersioneProgramma', @level2type = N'COLUMN', @level2name = N'StatoVersioneProgrammaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'StatoVersioneProgramma';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC di cancellazione logica del record. NULL indica record non cancellato logicamente.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'StatoVersioneProgramma', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC di creazione tecnica del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'StatoVersioneProgramma', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipologica degli stati di ciclo di vita di una versione di programma di certificazione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'StatoVersioneProgramma';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Colonna tecnica di inizio periodo SYSTEM_VERSIONING (hidden). Non rappresenta validità business.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'StatoVersioneProgramma', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''utente o processo che ha modificato il record, se disponibile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'StatoVersioneProgramma', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se il record è attivo nell''uso applicativo corrente. Non rappresenta cancellazione fisica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'StatoVersioneProgramma', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

