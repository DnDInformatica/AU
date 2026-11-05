CREATE TABLE [Platform].[CabCartellaTemplate] (
    [Id]           INT            IDENTITY (1, 1) NOT NULL,
    [OdcId]        INT            NULL,
    [Nome]         NVARCHAR (200) NOT NULL,
    [Descrizione]  NVARCHAR (500) NULL,
    [Ordine]       INT            CONSTRAINT [DF_CabTemplate_Ordine] DEFAULT ((0)) NOT NULL,
    [CreatedAtUtc] DATETIME2 (7)  CONSTRAINT [DF_CabTemplate_Created] DEFAULT (sysutcdatetime()) NOT NULL,
    [UpdatedAtUtc] DATETIME2 (7)  CONSTRAINT [DF_CabTemplate_Updated] DEFAULT (sysutcdatetime()) NOT NULL,
    [DeletedAtUtc] DATETIME2 (7)  NULL,
    CONSTRAINT [PK_CabCartellaTemplate] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_CabCartellaTemplate_OdcId]
    ON [Platform].[CabCartellaTemplate]([OdcId] ASC, [Ordine] ASC) WHERE ([DeletedAtUtc] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del template cartella.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'CabCartellaTemplate', @level2type = N'COLUMN', @level2name = N'CreatedAtUtc';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Template delle cartelle da predisporre per un CAB/ODC o come configurazione generale. Serve alla struttura operativa dei documenti; non contiene requisiti di accreditamento o evidenze approvate.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'CabCartellaTemplate';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ordine di presentazione/applicazione del template cartella.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'CabCartellaTemplate', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo opzionale dell''ODC/CAB cui il template si applica. NULL indica template generale o non specifico.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'CabCartellaTemplate', @level2type = N'COLUMN', @level2name = N'OdcId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultimo aggiornamento del template cartella.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'CabCartellaTemplate', @level2type = N'COLUMN', @level2name = N'UpdatedAtUtc';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata del template cartella per CAB/ODC.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'CabCartellaTemplate', @level2type = N'COLUMN', @level2name = N'Id';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nome della cartella prevista dal template.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'CabCartellaTemplate', @level2type = N'COLUMN', @level2name = N'Nome';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica del template cartella.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'CabCartellaTemplate', @level2type = N'COLUMN', @level2name = N'DeletedAtUtc';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione operativa della finalita della cartella prevista dal template.', @level0type = N'SCHEMA', @level0name = N'Platform', @level1type = N'TABLE', @level1name = N'CabCartellaTemplate', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

