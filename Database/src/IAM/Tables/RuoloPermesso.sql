CREATE TABLE [IAM].[RuoloPermesso] (
    [RuoloSistemaId]     INT                                                NOT NULL,
    [PermessoId]         INT                                                NOT NULL,
    [DataCreazione]      DATETIME2 (7)                                      CONSTRAINT [DF_RuoloPermesso_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]           INT                                                NULL,
    [DataCancellazione]  DATETIME2 (7)                                      NULL,
    [CancellatoDa]       INT                                                NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_RuoloPermesso_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_RuoloPermesso_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_RuoloPermesso] PRIMARY KEY CLUSTERED ([RuoloSistemaId] ASC, [PermessoId] ASC),
    CONSTRAINT [FK_RuoloPermesso_Permesso] FOREIGN KEY ([PermessoId]) REFERENCES [IAM].[Permesso] ([PermessoId]),
    CONSTRAINT [FK_RuoloPermesso_Ruolo] FOREIGN KEY ([RuoloSistemaId]) REFERENCES [IAM].[RuoloSistema] ([RuoloSistemaId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[IAM].[RuoloPermessoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

