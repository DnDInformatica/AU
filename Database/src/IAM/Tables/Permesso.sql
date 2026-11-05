CREATE TABLE [IAM].[Permesso] (
    [PermessoId]         INT                                                IDENTITY (1, 1) NOT NULL,
    [Codice]             NVARCHAR (200)                                     NOT NULL,
    [Descrizione]        NVARCHAR (500)                                     NOT NULL,
    [Modulo]             NVARCHAR (100)                                     NOT NULL,
    [Ambito]             NVARCHAR (100)                                     NOT NULL,
    [Attivo]             BIT                                                CONSTRAINT [DF_Permesso_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]      DATETIME2 (7)                                      CONSTRAINT [DF_Permesso_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]           INT                                                NULL,
    [DataModifica]       DATETIME2 (7)                                      NULL,
    [ModificatoDa]       INT                                                NULL,
    [DataCancellazione]  DATETIME2 (7)                                      NULL,
    [CancellatoDa]       INT                                                NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER                                   CONSTRAINT [DF_Permesso_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_Permesso_DataInizio] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_Permesso_DataFine] DEFAULT (CONVERT([datetime2],'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_Permesso] PRIMARY KEY CLUSTERED ([PermessoId] ASC),
    CONSTRAINT [UQ_Permesso_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[IAM].[PermessoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

