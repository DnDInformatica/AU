CREATE TABLE [Reporting].[NISI_BuildLog] (
    [LogId]        INT             IDENTITY (1, 1) NOT NULL,
    [StartedAtUtc] DATETIME2 (3)   CONSTRAINT [DF_NISI_BuildLog_StartedAtUtc] DEFAULT (sysutcdatetime()) NOT NULL,
    [EndedAtUtc]   DATETIME2 (3)   NULL,
    [FromPeriod]   NVARCHAR (7)    NOT NULL,
    [ToPeriod]     NVARCHAR (7)    NOT NULL,
    [RowsWritten]  BIGINT          CONSTRAINT [DF_NISI_BuildLog_RowsWritten] DEFAULT ((0)) NOT NULL,
    [Status]       NVARCHAR (20)   CONSTRAINT [DF_NISI_BuildLog_Status] DEFAULT (N'RUNNING') NOT NULL,
    [Note]         NVARCHAR (4000) NULL,
    CONSTRAINT [PK_NISI_BuildLog] PRIMARY KEY CLUSTERED ([LogId] ASC),
    CONSTRAINT [CK_NISI_BuildLog_Status] CHECK ([Status]=N'FAILED' OR [Status]=N'SUCCESS' OR [Status]=N'RUNNING')
);


GO

CREATE NONCLUSTERED INDEX [IX_NISI_BuildLog_Status_StartedAtUtc]
    ON [Reporting].[NISI_BuildLog]([Status] ASC, [StartedAtUtc] DESC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Log tecnico di costruzione degli snapshot/export NISI, con periodo, stato, durata e righe scritte. Supporta tracciabilita del processo di reporting, ma non e da solo prova del contenuto pubblico.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_BuildLog';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata del log di costruzione snapshot/export NISI.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_BuildLog', @level2type = N'COLUMN', @level2name = N'LogId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di avvio della costruzione snapshot/export NISI.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_BuildLog', @level2type = N'COLUMN', @level2name = N'StartedAtUtc';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di fine della costruzione snapshot/export NISI. NULL se il processo e in corso o non concluso correttamente.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_BuildLog', @level2type = N'COLUMN', @level2name = N'EndedAtUtc';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stato tecnico del processo di build, ad esempio RUNNING, SUCCESS o FAILED. Se guida retry e audit dovrebbe essere vincolato a valori ammessi.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_BuildLog', @level2type = N'COLUMN', @level2name = N'Status';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note tecniche o diagnostiche del processo di build. Non sostituiscono un dettaglio strutturato degli errori se serve audit puntuale.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_BuildLog', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Periodo iniziale incluso nella costruzione snapshot, nel formato operativo usato dal processo. Da normalizzare o validare se usato per controlli deterministici.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_BuildLog', @level2type = N'COLUMN', @level2name = N'FromPeriod';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Periodo finale incluso nella costruzione snapshot, nel formato operativo usato dal processo.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_BuildLog', @level2type = N'COLUMN', @level2name = N'ToPeriod';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero di righe scritte nello snapshot/export dal processo. Serve a controllo di completezza tecnica.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_BuildLog', @level2type = N'COLUMN', @level2name = N'RowsWritten';


GO

