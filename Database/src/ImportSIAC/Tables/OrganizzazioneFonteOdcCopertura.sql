CREATE TABLE [ImportSIAC].[OrganizzazioneFonteOdcCopertura] (
    [CodEnte]          NVARCHAR (150) NOT NULL,
    [PrimoSnapshot]    INT            NOT NULL,
    [UltimoSnapshot]   INT            NOT NULL,
    [NumeroOccorrenze] BIGINT         NOT NULL,
    [OrganizzazioneId] INT            NULL,
    [Esito]            VARCHAR (30)   NOT NULL,
    [DataVerifica]     DATETIME2 (7)  DEFAULT (sysutcdatetime()) NOT NULL,
    PRIMARY KEY CLUSTERED ([CodEnte] ASC)
);


GO

