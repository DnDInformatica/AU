CREATE TABLE [Ispettori].[DisponibilitaIspettoreStorico] (
    [DisponibilitaIspettoreId]   INT              NOT NULL,
    [IspettoreId]                INT              NOT NULL,
    [DataInizio]                 DATE             NOT NULL,
    [DataFine]                   DATE             NOT NULL,
    [TipoDisponibilita]          NVARCHAR (20)    NOT NULL,
    [Motivo]                     NVARCHAR (200)   NULL,
    [GiorniSettimanaDisponibili] NVARCHAR (50)    NULL,
    [OreGiornaliereMax]          INT              NULL,
    [Note]                       NVARCHAR (500)   NULL,
    [DataCreazione]              DATETIME2 (7)    NOT NULL,
    [CreatoDa]                   INT              NULL,
    [DataModifica]               DATETIME2 (7)    NULL,
    [ModificatoDa]               INT              NULL,
    [DataCancellazione]          DATETIME2 (7)    NULL,
    [CancellatoDa]               INT              NULL,
    [UniqueRowId]                UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]         DATETIME2 (7)    NOT NULL,
    [DataFineValidita]           DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_DisponibilitaIspettoreStorico]
    ON [Ispettori].[DisponibilitaIspettoreStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

