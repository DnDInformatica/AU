CREATE TABLE [IAM].[UtenteIspettoreStorico] (
    [UtenteIspettoreId]  INT              NOT NULL,
    [UtenteId]           INT              NOT NULL,
    [IspettoreId]        INT              NOT NULL,
    [Attivo]             BIT              NOT NULL,
    [Note]               NVARCHAR (500)   NULL,
    [DataCreazione]      DATETIME2 (7)    NOT NULL,
    [CreatoDa]           INT              NULL,
    [DataModifica]       DATETIME2 (7)    NULL,
    [ModificatoDa]       INT              NULL,
    [DataCancellazione]  DATETIME2 (7)    NULL,
    [CancellatoDa]       INT              NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita] DATETIME2 (7)    NOT NULL,
    [DataFineValidita]   DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [CIX_UtenteIspettoreStorico_Periodo]
    ON [IAM].[UtenteIspettoreStorico]([DataInizioValidita] ASC, [DataFineValidita] ASC);


GO

