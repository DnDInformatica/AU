CREATE TABLE [ImportSIAC].[wrk_All_Final] (
    [ChiaveBusinessHash]    BINARY (32)    NULL,
    [NumeroCertificato]     NVARCHAR (200) NULL,
    [OrganizzazioneODCId]   INT            NULL,
    [TipoCertificazioneId]  INT            NULL,
    [NormaAccreditamentoId] INT            NULL,
    [StatoCertificazioneId] INT            NULL,
    [DataEmissione]         DATE           NULL,
    [DataScadenza]          DATE           NULL,
    [DataRevoca]            DATE           NULL,
    [Privato]               BIT            NULL,
    [DataPrimoRilascio]     DATE           NULL,
    [DataInizioValidita]    DATETIME2 (7)  NULL,
    [DataFineValidita]      DATETIME2 (7)  NULL,
    [IsCorrente]            INT            NOT NULL,
    [Dominio]               NVARCHAR (3)   NULL
);


GO

CREATE CLUSTERED INDEX [CX_All_Final]
    ON [ImportSIAC].[wrk_All_Final]([ChiaveBusinessHash] ASC, [DataInizioValidita] ASC);


GO

