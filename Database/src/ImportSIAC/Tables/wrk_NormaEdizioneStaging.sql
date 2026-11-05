CREATE TABLE [ImportSIAC].[wrk_NormaEdizioneStaging] (
    [NormaAccreditamentoId]     INT             NOT NULL,
    [Codice]                    NVARCHAR (100)  NOT NULL,
    [RifFamiglia]               NVARCHAR (200)  NOT NULL,
    [CodiceVersione]            NVARCHAR (20)   NULL,
    [TitoloIta]                 NVARCHAR (1000) NULL,
    [TitoloEng]                 NVARCHAR (1000) NULL,
    [StatoNormaId]              INT             NOT NULL,
    [TipoNormaAccreditamentoId] INT             NULL,
    [CategoriaFonteNormaId]     INT             NULL,
    [Anno]                      SMALLINT        NULL,
    [RifEdizione]               NVARCHAR (222)  NULL,
    [TipoDesignazione]          NVARCHAR (50)   NULL,
    [PrefRank]                  BIGINT          NULL
);


GO

