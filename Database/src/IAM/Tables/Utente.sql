CREATE TABLE [IAM].[Utente] (
    [UtenteId]           INT                                                IDENTITY (1, 1) NOT NULL,
    [EntraObjectId]      NVARCHAR (36)                                      NOT NULL,
    [EntraProvider]      NVARCHAR (50)                                      NOT NULL,
    [Email]              NVARCHAR (256)                                     NOT NULL,
    [DisplayName]        NVARCHAR (256)                                     NULL,
    [UltimoLoginUtc]     DATETIME2 (7)                                      NULL,
    [Attivo]             BIT                                                CONSTRAINT [DF_Utente_Attivo] DEFAULT ((1)) NOT NULL,
    [Note]               NVARCHAR (MAX)                                     NULL,
    [DataCreazione]      DATETIME2 (7)                                      CONSTRAINT [DF_Utente_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]           INT                                                NULL,
    [DataModifica]       DATETIME2 (7)                                      NULL,
    [ModificatoDa]       INT                                                NULL,
    [DataCancellazione]  DATETIME2 (7)                                      NULL,
    [CancellatoDa]       INT                                                NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER                                   CONSTRAINT [DF_Utente_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_Utente_DataInizio] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_Utente_DataFine] DEFAULT (CONVERT([datetime2],'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_Utente] PRIMARY KEY CLUSTERED ([UtenteId] ASC),
    CONSTRAINT [CK_Utente_EntraProvider] CHECK ([EntraProvider]='ENTRA_EXTERNAL' OR [EntraProvider]='ENTRA_AZIENDALE'),
    CONSTRAINT [UQ_Utente_EntraObjectId] UNIQUE NONCLUSTERED ([EntraObjectId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[IAM].[UtenteStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_Utente_Email]
    ON [IAM].[Utente]([Email] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_Utente_Provider]
    ON [IAM].[Utente]([EntraProvider] ASC, [Attivo] ASC) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'Utente';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tutti gli utenti umani del sistema SIGAD: dipendenti ACCREDIA (Entra ID aziendale), referenti OdC e ispettori esterni (Entra External ID). EntraObjectId e il GUID del token JWT. Non contiene password: autenticazione delegata a Microsoft Entra.', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'Utente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:IAM;TemporalCurrent;SoftDelete;Audit;Entra', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'Utente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.06', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'Utente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'Utente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"IAM","table":"Utente","temporal":true,"temporal_type":2,"history_table":"IAM.UtenteStorico","soft_delete":true,"audit":true,"entra_provider":["ENTRA_AZIENDALE","ENTRA_EXTERNAL"]}', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'Utente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'Utente';


GO

