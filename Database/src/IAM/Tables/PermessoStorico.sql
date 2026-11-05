CREATE TABLE [IAM].[PermessoStorico] (
    [PermessoId]         INT              NOT NULL,
    [Codice]             NVARCHAR (200)   NOT NULL,
    [Descrizione]        NVARCHAR (500)   NOT NULL,
    [Modulo]             NVARCHAR (100)   NOT NULL,
    [Ambito]             NVARCHAR (100)   NOT NULL,
    [Attivo]             BIT              NOT NULL,
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

CREATE CLUSTERED INDEX [CIX_PermessoStorico_Periodo]
    ON [IAM].[PermessoStorico]([DataInizioValidita] ASC, [DataFineValidita] ASC);


GO

