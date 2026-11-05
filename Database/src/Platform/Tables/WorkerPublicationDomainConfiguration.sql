CREATE TABLE [Platform].[WorkerPublicationDomainConfiguration] (
    [DomainCode]                      NVARCHAR (50)  NOT NULL,
    [DisplayName]                     NVARCHAR (200) NOT NULL,
    [AutoPublishEnabled]              BIT            CONSTRAINT [DF_WPDC_AutoPublish] DEFAULT ((1)) NOT NULL,
    [MinimumDelayMinutesAfterConfirm] INT            CONSTRAINT [DF_WPDC_MinDelay] DEFAULT ((60)) NOT NULL,
    [AllowedWindowStartLocal]         TIME (7)       NULL,
    [AllowedWindowEndLocal]           TIME (7)       NULL,
    [PublishOnWeekends]               BIT            CONSTRAINT [DF_WPDC_Weekends] DEFAULT ((0)) NOT NULL,
    [MaxSessionsPerRun]               INT            NULL,
    [Notes]                           NVARCHAR (500) NULL,
    [UpdatedAtUtc]                    DATETIME2 (7)  CONSTRAINT [DF_WPDC_UpdatedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_WorkerPublicationDomainConfiguration] PRIMARY KEY CLUSTERED ([DomainCode] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nome descrittivo del dominio di pubblicazione.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerPublicationDomainConfiguration', @level2type = N'COLUMN', @level2name = N'DisplayName';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero massimo di sessioni di pubblicazione trattabili per ciclo del worker nel dominio.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerPublicationDomainConfiguration', @level2type = N'COLUMN', @level2name = N'MaxSessionsPerRun';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag che consente o vieta pubblicazioni automatiche nel fine settimana.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerPublicationDomainConfiguration', @level2type = N'COLUMN', @level2name = N'PublishOnWeekends';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice dominio di pubblicazione, ad esempio FPC, PPC o PRD. Identifica il perimetro operativo del worker, non una norma o uno schema di accreditamento.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerPublicationDomainConfiguration', @level2type = N'COLUMN', @level2name = N'DomainCode';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note operative del dominio di pubblicazione. Campo descrittivo, non registro di esito.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerPublicationDomainConfiguration', @level2type = N'COLUMN', @level2name = N'Notes';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag che abilita la pubblicazione automatica per il dominio. Non dimostra che una specifica certificazione o versione sia stata pubblicata.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerPublicationDomainConfiguration', @level2type = N'COLUMN', @level2name = N'AutoPublishEnabled';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ora locale di inizio finestra consentita per pubblicare. NULL indica assenza di limite iniziale.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerPublicationDomainConfiguration', @level2type = N'COLUMN', @level2name = N'AllowedWindowStartLocal';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultimo aggiornamento della configurazione del dominio di pubblicazione.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerPublicationDomainConfiguration', @level2type = N'COLUMN', @level2name = N'UpdatedAtUtc';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ritardo minimo, in minuti, fra conferma/approvazione e presa in carico della pubblicazione automatica.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerPublicationDomainConfiguration', @level2type = N'COLUMN', @level2name = N'MinimumDelayMinutesAfterConfirm';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ora locale di fine finestra consentita per pubblicare. NULL indica assenza di limite finale.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerPublicationDomainConfiguration', @level2type = N'COLUMN', @level2name = N'AllowedWindowEndLocal';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Configurazione per dominio della pubblicazione automatica, ad esempio FPC, PPC e PRD. Stabilisce regole operative del worker; non e uno snapshot immutabile del contenuto pubblicato.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'WorkerPublicationDomainConfiguration';


GO

