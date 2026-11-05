CREATE TABLE [IAM].[UtenteOdCStorico] (
    [UtenteOdCId]         INT              NOT NULL,
    [UtenteId]            INT              NOT NULL,
    [OrganizzazioneOdCId] INT              NOT NULL,
    [ScopoSchemaId]       INT              NULL,
    [DataScadenza]        DATE             NULL,
    [Attivo]              BIT              NOT NULL,
    [Note]                NVARCHAR (500)   NULL,
    [DataCreazione]       DATETIME2 (7)    NOT NULL,
    [CreatoDa]            INT              NULL,
    [DataModifica]        DATETIME2 (7)    NULL,
    [ModificatoDa]        INT              NULL,
    [DataCancellazione]   DATETIME2 (7)    NULL,
    [CancellatoDa]        INT              NULL,
    [UniqueRowId]         UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]  DATETIME2 (7)    NOT NULL,
    [DataFineValidita]    DATETIME2 (7)    NOT NULL,
    [RuoloSistemaId]      INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [CIX_UtenteOdCStorico_Periodo]
    ON [IAM].[UtenteOdCStorico]([DataInizioValidita] ASC, [DataFineValidita] ASC);


GO

