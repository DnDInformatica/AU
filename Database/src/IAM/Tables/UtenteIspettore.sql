CREATE TABLE [IAM].[UtenteIspettore] (
    [UtenteIspettoreId]  INT                                                IDENTITY (1, 1) NOT NULL,
    [UtenteId]           INT                                                NOT NULL,
    [IspettoreId]        INT                                                NOT NULL,
    [Attivo]             BIT                                                CONSTRAINT [DF_UtenteIspettore_Attivo] DEFAULT ((1)) NOT NULL,
    [Note]               NVARCHAR (500)                                     NULL,
    [DataCreazione]      DATETIME2 (7)                                      CONSTRAINT [DF_UtenteIspettore_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]           INT                                                NULL,
    [DataModifica]       DATETIME2 (7)                                      NULL,
    [ModificatoDa]       INT                                                NULL,
    [DataCancellazione]  DATETIME2 (7)                                      NULL,
    [CancellatoDa]       INT                                                NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER                                   CONSTRAINT [DF_UtenteIspettore_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_UtenteIspettore_DataInizio] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_UtenteIspettore_DataFine] DEFAULT (CONVERT([datetime2],'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_UtenteIspettore] PRIMARY KEY CLUSTERED ([UtenteIspettoreId] ASC),
    CONSTRAINT [FK_UtenteIspettore_Ispettore] FOREIGN KEY ([IspettoreId]) REFERENCES [Ispettori].[Ispettore] ([IspettoreId]),
    CONSTRAINT [FK_UtenteIspettore_Utente] FOREIGN KEY ([UtenteId]) REFERENCES [IAM].[Utente] ([UtenteId]),
    CONSTRAINT [UQ_UtenteIspettore] UNIQUE NONCLUSTERED ([UtenteId] ASC, [IspettoreId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[IAM].[UtenteIspettoreStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_UtenteIspettore_Ispettore]
    ON [IAM].[UtenteIspettore]([IspettoreId] ASC) WHERE ([DataCancellazione] IS NULL AND [Attivo]=(1));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.06', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'UtenteIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:IAM;TemporalCurrent;SoftDelete;Audit;Ispettori;RowLevelSecurity', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'UtenteIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"IAM","table":"UtenteIspettore","temporal":true,"temporal_type":2,"history_table":"IAM.UtenteIspettoreStorico","soft_delete":true,"audit":true,"row_level_filter":"IspettoreId"}', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'UtenteIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'UtenteIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'UtenteIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'UtenteIspettore';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Associazione utente esterno con anagrafica ispettore per accesso al portale ispettori. Consente row-level access filtering: l ispettore vede solo disponibilita, assegnazioni e monitoraggi riferiti al proprio IspettoreId.', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'UtenteIspettore';


GO

