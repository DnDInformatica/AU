CREATE TABLE [ImportSIAC].[CatalogoCanonicoFPC_Staging] (
    [RigaId]                    INT             IDENTITY (1, 1) NOT NULL,
    [DesignazioneBase]          NVARCHAR (400)  NOT NULL,
    [CodiceFamiglia]            NVARCHAR (200)  NOT NULL,
    [NumeroFamiglia]            NVARCHAR (100)  NOT NULL,
    [TipoAggregazione]          VARCHAR (30)    NOT NULL,
    [AnnoEdizione]              SMALLINT        NOT NULL,
    [Riferimento]               NVARCHAR (600)  NOT NULL,
    [StatoNormaId]              INT             NOT NULL,
    [TipoNormaAccreditamentoId] INT             NOT NULL,
    [CategoriaFonteNormaId]     INT             NOT NULL,
    [TitoloIta]                 NVARCHAR (2000) NULL,
    [NumeroParte]               NVARCHAR (40)   NULL,
    [DataPubblicazione]         DATE            NULL,
    [DataRitiro]                DATE            NULL,
    [DataInizioTransizione]     DATE            NULL,
    [DataFineTransizione]       DATE            NULL,
    [TipoDesignazione]          NVARCHAR (100)  NOT NULL,
    PRIMARY KEY CLUSTERED ([RigaId] ASC)
);


GO

