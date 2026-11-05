CREATE TABLE [ImportSIAC].[wrk_CertNorma_Before] (
    [NumeroCertificato]     NVARCHAR (100) NOT NULL,
    [OrganizzazioneODCId]   INT            NOT NULL,
    [NormaAccreditamentoId] INT            NOT NULL
);


GO

CREATE CLUSTERED INDEX [CX_CertNorma_Before]
    ON [ImportSIAC].[wrk_CertNorma_Before]([NumeroCertificato] ASC, [OrganizzazioneODCId] ASC);


GO

