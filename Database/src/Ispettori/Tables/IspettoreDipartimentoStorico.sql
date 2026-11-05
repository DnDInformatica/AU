CREATE TABLE [Ispettori].[IspettoreDipartimentoStorico] (
    [IspettoreDipartimentoId]  INT              NOT NULL,
    [IspettoreId]              INT              NOT NULL,
    [DipartimentoAccrediaId]   INT              NOT NULL,
    [StatoNelDipartimento]     NVARCHAR (20)    NOT NULL,
    [DataInizioCollaborazione] DATE             NOT NULL,
    [DataFineCollaborazione]   DATE             NULL,
    [NumeroConvenzione]        NVARCHAR (50)    NULL,
    [DataFirmaConvenzione]     DATE             NULL,
    [IsDipartimentoPrincipale] BIT              NOT NULL,
    [TariffaGiornaliera]       DECIMAL (10, 2)  NULL,
    [Note]                     NVARCHAR (500)   NULL,
    [DataCreazione]            DATETIME2 (7)    NOT NULL,
    [CreatoDa]                 INT              NULL,
    [DataModifica]             DATETIME2 (7)    NULL,
    [ModificatoDa]             INT              NULL,
    [DataCancellazione]        DATETIME2 (7)    NULL,
    [CancellatoDa]             INT              NULL,
    [UniqueRowId]              UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]       DATETIME2 (7)    NOT NULL,
    [DataFineValidita]         DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_IspettoreDipartimentoStorico]
    ON [Ispettori].[IspettoreDipartimentoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

