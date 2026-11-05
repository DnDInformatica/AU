CREATE TABLE [Standard].[NormaClassificazioneAccrediaStorico] (
    [NormaClassificazioneAccrediaId] INT              NOT NULL,
    [NormaEdizioneId]                INT              NOT NULL,
    [RiferimentoEA]                  NVARCHAR (100)   NULL,
    [RiferimentoIAF]                 NVARCHAR (100)   NULL,
    [RiferimentoILAC]                NVARCHAR (100)   NULL,
    [CodiceIAF]                      NVARCHAR (50)    NULL,
    [CodiceEA]                       NVARCHAR (50)    NULL,
    [Note]                           NVARCHAR (1000)  NULL,
    [Attivo]                         BIT              NOT NULL,
    [DataCreazione]                  DATETIME2 (7)    NOT NULL,
    [CreatoDa]                       INT              NULL,
    [DataModifica]                   DATETIME2 (7)    NULL,
    [ModificatoDa]                   INT              NULL,
    [DataCancellazione]              DATETIME2 (7)    NULL,
    [CancellatoDa]                   INT              NULL,
    [UniqueRowId]                    UNIQUEIDENTIFIER NOT NULL,
    [DipartimentoAccrediaId]         INT              NULL,
    [SettoreAccrediaId]              INT              NOT NULL,
    [DataInizioValidita]             DATETIME2 (7)    NOT NULL,
    [DataFineValidita]               DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_NormaClassificazioneAccrediaStorico]
    ON [Standard].[NormaClassificazioneAccrediaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

