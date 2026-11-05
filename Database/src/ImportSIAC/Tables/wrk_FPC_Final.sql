CREATE TABLE [ImportSIAC].[wrk_FPC_Final] (
    [ChiaveBusinessHash]             BINARY (32)     NULL,
    [NumeroCertificato]              NVARCHAR (200)  NULL,
    [OrganizzazioneODCId]            INT             NULL,
    [DataPrimoRilascio]              DATE            NULL,
    [TipoQualificaId]                INT             NULL,
    [Settore]                        NVARCHAR (MAX)  NULL,
    [DataEmissioneCorrente]          DATE            NULL,
    [Straniero]                      BIT             NULL,
    [CodicePersonaODC]               NVARCHAR (150)  NULL,
    [SiacId]                         INT             NULL,
    [fpc_fiscal_code]                NVARCHAR (100)  NULL,
    [first_name]                     NVARCHAR (400)  NULL,
    [last_name]                      NVARCHAR (400)  NULL,
    [birth_date]                     DATE            NULL,
    [birth_place]                    NVARCHAR (400)  NULL,
    [ProfiloProfessionaleCodice]     NVARCHAR (4000) NULL,
    [ProfiloProfessionaleVersioneId] INT             NULL,
    [LivelloDigCompId]               TINYINT         NULL,
    [ProgrammaCertificazioneId]      INT             NULL,
    [DataInizioValiditaFPC]          DATETIME2 (7)   NULL,
    [DataFineValiditaFPC]            DATETIME2 (7)   NULL,
    [IsCorrente]                     INT             NOT NULL
);


GO

CREATE CLUSTERED INDEX [CX_FPC_Final]
    ON [ImportSIAC].[wrk_FPC_Final]([ChiaveBusinessHash] ASC, [DataInizioValiditaFPC] ASC);


GO

