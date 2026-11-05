CREATE TABLE [Standard].[FonteLegislativaStorico] (
    [FonteLegislativaId]      INT              NOT NULL,
    [TipoFonteLegislativaId]  INT              NOT NULL,
    [CodiceFonte]             VARCHAR (100)    NOT NULL,
    [Titolo]                  NVARCHAR (1000)  NOT NULL,
    [TitoloBreve]             NVARCHAR (200)   NULL,
    [Giurisdizione]           VARCHAR (10)     NOT NULL,
    [Numero]                  VARCHAR (50)     NOT NULL,
    [Anno]                    SMALLINT         NOT NULL,
    [DataAdozione]            DATE             NULL,
    [DataPubblicazione]       DATE             NULL,
    [DataEntrataInVigore]     DATE             NULL,
    [DataApplicazione]        DATE             NULL,
    [DataAbrogazione]         DATE             NULL,
    [StatoFonteLegislativaId] INT              NOT NULL,
    [AutoritaEmittente]       NVARCHAR (300)   NULL,
    [FonteUfficialeUrl]       NVARCHAR (1000)  NULL,
    [IdentificativoUfficiale] NVARCHAR (200)   NULL,
    [Celex]                   VARCHAR (30)     NULL,
    [EliUri]                  NVARCHAR (500)   NULL,
    [GuriNumero]              VARCHAR (50)     NULL,
    [GuriData]                DATE             NULL,
    [Note]                    NVARCHAR (2000)  NULL,
    [DataCreazione]           DATETIME2 (7)    NOT NULL,
    [CreatoDa]                INT              NULL,
    [DataModifica]            DATETIME2 (7)    NULL,
    [ModificatoDa]            INT              NULL,
    [DataCancellazione]       DATETIME2 (7)    NULL,
    [CancellatoDa]            INT              NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]      DATETIME2 (7)    NOT NULL,
    [DataFineValidita]        DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_FonteLegislativaStorico]
    ON [Standard].[FonteLegislativaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

