CREATE TABLE [IAM].[UtenteRuolo] (
    [UtenteRuoloId]      INT                                                IDENTITY (1, 1) NOT NULL,
    [UtenteId]           INT                                                NOT NULL,
    [RuoloSistemaId]     INT                                                NOT NULL,
    [DataCreazione]      DATETIME2 (7)                                      CONSTRAINT [DF_UtenteRuolo_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]           INT                                                NULL,
    [DataCancellazione]  DATETIME2 (7)                                      NULL,
    [CancellatoDa]       INT                                                NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER                                   CONSTRAINT [DF_UtenteRuolo_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_UtenteRuolo_DataInizio] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_UtenteRuolo_DataFine] DEFAULT (CONVERT([datetime2],'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_UtenteRuolo] PRIMARY KEY CLUSTERED ([UtenteRuoloId] ASC),
    CONSTRAINT [FK_UtenteRuolo_Ruolo] FOREIGN KEY ([RuoloSistemaId]) REFERENCES [IAM].[RuoloSistema] ([RuoloSistemaId]),
    CONSTRAINT [FK_UtenteRuolo_Utente] FOREIGN KEY ([UtenteId]) REFERENCES [IAM].[Utente] ([UtenteId]),
    CONSTRAINT [UQ_UtenteRuolo] UNIQUE NONCLUSTERED ([UtenteId] ASC, [RuoloSistemaId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[IAM].[UtenteRuoloStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE   TRIGGER IAM.TR_UtenteRuolo_Ambito ON IAM.UtenteRuolo AFTER INSERT,UPDATE AS
BEGIN SET NOCOUNT ON; IF EXISTS(SELECT 1 FROM inserted i JOIN IAM.RuoloSistema r ON r.RuoloSistemaId=i.RuoloSistemaId WHERE r.AmbitoRuolo<>N'GLOBALE') THROW 52302,N'Ruolo con ambito ODC: va assegnato per organismo in IAM.UtenteOdC.',1; END;

GO
