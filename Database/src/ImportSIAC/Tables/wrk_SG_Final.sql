CREATE TABLE [ImportSIAC].[wrk_SG_Final] (
    [ChiaveBusinessHash]      BINARY (32)    NULL,
    [NumeroCertificato]       NVARCHAR (200) NULL,
    [OrganizzazioneODCId]     INT            NULL,
    [DataPrimoRilascio]       DATE           NULL,
    [OrganizzazioneClienteId] INT            NULL,
    [AmbitoIta]               NVARCHAR (MAX) NULL,
    [AmbitoEng]               NVARCHAR (MAX) NULL,
    [DataUltimoRinnovo]       DATE           NULL,
    [DataInizioValiditaSG]    DATETIME2 (7)  NULL,
    [DataFineValiditaSG]      DATETIME2 (7)  NULL,
    [IsCorrente]              INT            NOT NULL
);


GO

CREATE CLUSTERED INDEX [CX_SG_Final]
    ON [ImportSIAC].[wrk_SG_Final]([ChiaveBusinessHash] ASC, [DataInizioValiditaSG] ASC);


GO

