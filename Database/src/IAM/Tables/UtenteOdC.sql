CREATE TABLE [IAM].[UtenteOdC] (
    [UtenteOdCId]         INT                                                IDENTITY (1, 1) NOT NULL,
    [UtenteId]            INT                                                NOT NULL,
    [OrganizzazioneOdCId] INT                                                NOT NULL,
    [ScopoSchemaId]       INT                                                NULL,
    [DataScadenza]        DATE                                               NULL,
    [Attivo]              BIT                                                CONSTRAINT [DF_UtenteOdC_Attivo] DEFAULT ((1)) NOT NULL,
    [Note]                NVARCHAR (500)                                     NULL,
    [DataCreazione]       DATETIME2 (7)                                      CONSTRAINT [DF_UtenteOdC_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]            INT                                                NULL,
    [DataModifica]        DATETIME2 (7)                                      NULL,
    [ModificatoDa]        INT                                                NULL,
    [DataCancellazione]   DATETIME2 (7)                                      NULL,
    [CancellatoDa]        INT                                                NULL,
    [UniqueRowId]         UNIQUEIDENTIFIER                                   CONSTRAINT [DF_UtenteOdC_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita]  DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_UtenteOdC_DataInizio] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]    DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_UtenteOdC_DataFine] DEFAULT (CONVERT([datetime2],'9999-12-31 23:59:59.9999999')) NOT NULL,
    [RuoloSistemaId]      INT                                                NOT NULL,
    CONSTRAINT [PK_UtenteOdC] PRIMARY KEY CLUSTERED ([UtenteOdCId] ASC),
    CONSTRAINT [FK_UtenteOdC_RuoloSistema] FOREIGN KEY ([RuoloSistemaId]) REFERENCES [IAM].[RuoloSistema] ([RuoloSistemaId]),
    CONSTRAINT [FK_UtenteOdC_Organizzazione] FOREIGN KEY ([OrganizzazioneOdCId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId]),
    CONSTRAINT [FK_UtenteOdC_Utente] FOREIGN KEY ([UtenteId]) REFERENCES [IAM].[Utente] ([UtenteId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[IAM].[UtenteOdCStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_UtenteOdC_OdC]
    ON [IAM].[UtenteOdC]([OrganizzazioneOdCId] ASC, [RuoloSistemaId] ASC) WHERE ([DataCancellazione] IS NULL AND [Attivo]=(1));


GO

CREATE NONCLUSTERED INDEX [IX_UtenteOdC_Utente]
    ON [IAM].[UtenteOdC]([UtenteId] ASC) WHERE ([DataCancellazione] IS NULL AND [Attivo]=(1));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_UtenteOdC_Assegnazione]
    ON [IAM].[UtenteOdC]([UtenteId] ASC, [OrganizzazioneOdCId] ASC, [RuoloSistemaId] ASC, [ScopoSchemaId] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE   TRIGGER IAM.TR_UtenteOdC_Ambito ON IAM.UtenteOdC AFTER INSERT,UPDATE AS
BEGIN SET NOCOUNT ON; IF EXISTS(SELECT 1 FROM inserted i JOIN IAM.RuoloSistema r ON r.RuoloSistemaId=i.RuoloSistemaId WHERE r.AmbitoRuolo<>N'ODC') THROW 52301,N'Ruolo non assegnabile su un organismo: AmbitoRuolo deve essere ODC.',1; END;

GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'UtenteOdC';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"IAM","table":"UtenteOdC","temporal":true,"temporal_type":2,"history_table":"IAM.UtenteOdCStorico","soft_delete":true,"audit":true,"ruoli":"IAM.RuoloSistema con AmbitoRuolo=ODC","scope_fk_logica":"Standard.SchemaAccreditamento.SchemaAccreditamentoId"}', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'UtenteOdC';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'UtenteOdC';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'UtenteOdC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Associazione utente esterno con OdC e ruolo di accesso. RuoloSistemaId punta a un ruolo con AmbitoRuolo=ODC: i permessi validi sull organismo sono quelli del ruolo in IAM.RuoloPermesso. ScopoSchemaId restringe la delega a uno schema di accreditamento specifico (NULL = tutti gli schemi).', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'UtenteOdC';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.06', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'UtenteOdC';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:IAM;TemporalCurrent;SoftDelete;Audit;RBAC;OdC', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'UtenteOdC';


GO

