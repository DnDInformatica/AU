CREATE TABLE [Platform].[WorkerJobConfiguration] (
    [JobKey]                   NVARCHAR (100) NOT NULL,
    [DisplayName]              NVARCHAR (200) NOT NULL,
    [Enabled]                  BIT            CONSTRAINT [DF_WJC_Enabled] DEFAULT ((1)) NOT NULL,
    [CronExpression]           NVARCHAR (100) NULL,
    [PollingIntervalSeconds]   INT            NULL,
    [ProcessingTimeoutMinutes] INT            NULL,
    [RetentionDays]            INT            NULL,
    [BatchSize]                INT            NULL,
    [Notes]                    NVARCHAR (500) NULL,
    [UpdatedAtUtc]             DATETIME2 (7)  CONSTRAINT [DF_WJC_UpdatedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_WorkerJobConfiguration] PRIMARY KEY CLUSTERED ([JobKey] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero di giorni di retention per dati temporanei o log collegati al job, quando applicabile.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerJobConfiguration', @level2type = N'COLUMN', @level2name = N'RetentionDays';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice univoco del job/worker configurato, ad esempio publish-certificates o generate-monthly-export.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerJobConfiguration', @level2type = N'COLUMN', @level2name = N'JobKey';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Configurazione operativa dei job/worker di piattaforma, inclusi schedulazione, batch, timeout e retention. Definisce quando e come un processo gira, ma non registra l''esito sostanziale delle decisioni o delle pubblicazioni.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerJobConfiguration';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timeout massimo di elaborazione in minuti prima che una sessione possa essere considerata stale o fallita.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerJobConfiguration', @level2type = N'COLUMN', @level2name = N'ProcessingTimeoutMinutes';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nome descrittivo del job per interfacce, log e gestione operativa.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerJobConfiguration', @level2type = N'COLUMN', @level2name = N'DisplayName';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dimensione batch usata dal job per ogni ciclo di elaborazione.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerJobConfiguration', @level2type = N'COLUMN', @level2name = N'BatchSize';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Espressione cron di schedulazione periodica del job. NULL se il job usa polling o trigger diverso.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerJobConfiguration', @level2type = N'COLUMN', @level2name = N'CronExpression';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultimo aggiornamento della configurazione del job.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerJobConfiguration', @level2type = N'COLUMN', @level2name = N'UpdatedAtUtc';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note operative sulla configurazione del job. Campo descrittivo, non sostituisce log esecuzione o registro esiti.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerJobConfiguration', @level2type = N'COLUMN', @level2name = N'Notes';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag che abilita o disabilita l''esecuzione del job. Non indica esito o completamento di una pubblicazione.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerJobConfiguration', @level2type = N'COLUMN', @level2name = N'Enabled';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Intervallo di polling in secondi per job continui o worker che processano code/sessioni.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerJobConfiguration', @level2type = N'COLUMN', @level2name = N'PollingIntervalSeconds';


GO

