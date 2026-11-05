CREATE TABLE [ImportSIAC].[wrk_PRD_Final] (
    [ChiaveBusinessHash]      BINARY (32)    NULL,
    [NumeroCertificato]       NVARCHAR (200) NULL,
    [OrganizzazioneODCId]     INT            NULL,
    [DataPrimoRilascio]       DATE           NULL,
    [OrganizzazioneClienteId] INT            NULL,
    [ScopoCertificato]        NVARCHAR (MAX) NULL,
    [NomeProdotto]            NVARCHAR (MAX) NULL,
    [SpecificaTecnica]        NVARCHAR (MAX) NULL,
    [DataUltimoRinnovo]       DATE           NULL,
    [DataInizioValiditaPRD]   DATETIME2 (7)  NULL,
    [DataFineValiditaPRD]     DATETIME2 (7)  NULL,
    [IsCorrente]              INT            NOT NULL
);


GO

CREATE CLUSTERED INDEX [CX_PRD_Final]
    ON [ImportSIAC].[wrk_PRD_Final]([ChiaveBusinessHash] ASC, [DataInizioValiditaPRD] ASC);


GO

