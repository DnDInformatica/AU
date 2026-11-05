CREATE TABLE [Standard].[NormaEdizioneStorico] (
    [NormaEdizioneId]           INT              NOT NULL,
    [NormaFamigliaId]           INT              NOT NULL,
    [NormaAccreditamentoId]     INT              NULL,
    [CodiceVersione]            NVARCHAR (50)    NULL,
    [Riferimento]               NVARCHAR (300)   NOT NULL,
    [AnnoEdizione]              SMALLINT         NULL,
    [NumeroParte]               NVARCHAR (30)    NULL,
    [Amendment]                 NVARCHAR (50)    NULL,
    [TitoloIta]                 NVARCHAR (1000)  NULL,
    [TitoloEng]                 NVARCHAR (1000)  NULL,
    [StatoNormaId]              INT              NOT NULL,
    [TipoNormaAccreditamentoId] INT              NOT NULL,
    [CategoriaFonteNormaId]     INT              NOT NULL,
    [Attivo]                    BIT              NOT NULL,
    [DataPubblicazione]         DATE             NULL,
    [DataRitiro]                DATE             NULL,
    [DataInizioTransizione]     DATE             NULL,
    [DataFineTransizione]       DATE             NULL,
    [LineaEditoriale]           NVARCHAR (100)   NULL,
    [TipoRecepimentoNorma]      NVARCHAR (50)    NULL,
    [SequenzaNormativa]         INT              NULL,
    [DataCreazione]             DATETIME2 (7)    NOT NULL,
    [CreatoDa]                  INT              NULL,
    [DataModifica]              DATETIME2 (7)    NULL,
    [ModificatoDa]              INT              NULL,
    [DataCancellazione]         DATETIME2 (7)    NULL,
    [CancellatoDa]              INT              NULL,
    [UniqueRowId]               UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]        DATETIME2 (7)    NOT NULL,
    [DataFineValidita]          DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_NormaEdizioneStorico]
    ON [Standard].[NormaEdizioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

