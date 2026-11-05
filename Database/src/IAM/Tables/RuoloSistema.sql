CREATE TABLE [IAM].[RuoloSistema] (
    [RuoloSistemaId]     INT                                                IDENTITY (1, 1) NOT NULL,
    [CodiceRuolo]        NVARCHAR (100)                                     NOT NULL,
    [Descrizione]        NVARCHAR (500)                                     NULL,
    [Attivo]             BIT                                                CONSTRAINT [DF_RuoloSistema_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]      DATETIME2 (7)                                      CONSTRAINT [DF_RuoloSistema_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]           INT                                                NULL,
    [DataModifica]       DATETIME2 (7)                                      NULL,
    [ModificatoDa]       INT                                                NULL,
    [DataCancellazione]  DATETIME2 (7)                                      NULL,
    [CancellatoDa]       INT                                                NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER                                   CONSTRAINT [DF_RuoloSistema_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_RuoloSistema_DataInizio] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_RuoloSistema_DataFine] DEFAULT (CONVERT([datetime2],'9999-12-31 23:59:59.9999999')) NOT NULL,
    [AmbitoRuolo]        NVARCHAR (20)                                      CONSTRAINT [DF_RuoloSistema_AmbitoRuolo] DEFAULT (N'GLOBALE') NOT NULL,
    CONSTRAINT [PK_RuoloSistema] PRIMARY KEY CLUSTERED ([RuoloSistemaId] ASC),
    CONSTRAINT [UQ_RuoloSistema_Codice] UNIQUE NONCLUSTERED ([CodiceRuolo] ASC),
    CONSTRAINT [CK_RuoloSistema_AmbitoRuolo] CHECK ([AmbitoRuolo]=N'GLOBALE' OR [AmbitoRuolo]=N'ODC'),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[IAM].[RuoloSistemaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE   TRIGGER IAM.TR_RuoloSistema_Ambito ON IAM.RuoloSistema AFTER UPDATE AS
BEGIN SET NOCOUNT ON; IF UPDATE(AmbitoRuolo) AND (EXISTS(SELECT 1 FROM inserted i JOIN IAM.UtenteOdC uo ON uo.RuoloSistemaId=i.RuoloSistemaId AND uo.DataCancellazione IS NULL WHERE i.AmbitoRuolo<>N'ODC') OR EXISTS(SELECT 1 FROM inserted i JOIN IAM.UtenteRuolo ur ON ur.RuoloSistemaId=i.RuoloSistemaId AND ur.DataCancellazione IS NULL WHERE i.AmbitoRuolo<>N'GLOBALE')) THROW 52303,N'AmbitoRuolo incompatibile con le assegnazioni esistenti del ruolo.',1; END;

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'AmbitoRuolo: GLOBALE si assegna in IAM.UtenteRuolo, ODC si assegna per organismo in IAM.UtenteOdC.', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'RuoloSistema', @level2type = N'COLUMN', @level2name = N'AmbitoRuolo';


GO
