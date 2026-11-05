CREATE TABLE [ImportSIAC].[BuildHistory_ScartaOrganizzazione] (
    [ScartaOrganizzazioneId] INT            IDENTITY (1, 1) NOT NULL,
    [BuildHistoryLogId]      INT            NOT NULL,
    [Dominio]                NVARCHAR (10)  NOT NULL,
    [Codente]                NVARCHAR (20)  NULL,
    [ODCRagioneSociale]      NVARCHAR (500) NULL,
    [FiscalCodeRaw]          NVARCHAR (100) NULL,
    [VatNumberRaw]           NVARCHAR (100) NULL,
    [MotivoScarto]           NVARCHAR (100) NOT NULL,
    [NCertificatiImpattati]  INT            NOT NULL,
    [DataCreazione]          DATETIME2 (7)  CONSTRAINT [DF_BHSO_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_BH_ScartaOrganizzazione] PRIMARY KEY CLUSTERED ([ScartaOrganizzazioneId] ASC)
);


GO

