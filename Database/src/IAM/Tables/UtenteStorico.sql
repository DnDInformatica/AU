CREATE TABLE [IAM].[UtenteStorico] (
    [UtenteId]           INT              NOT NULL,
    [EntraObjectId]      NVARCHAR (36)    NOT NULL,
    [EntraProvider]      NVARCHAR (50)    NOT NULL,
    [Email]              NVARCHAR (256)   NOT NULL,
    [DisplayName]        NVARCHAR (256)   NULL,
    [UltimoLoginUtc]     DATETIME2 (7)    NULL,
    [Attivo]             BIT              NOT NULL,
    [Note]               NVARCHAR (MAX)   NULL,
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

CREATE CLUSTERED INDEX [CIX_UtenteStorico_Periodo]
    ON [IAM].[UtenteStorico]([DataInizioValidita] ASC, [DataFineValidita] ASC);


GO

