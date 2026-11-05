CREATE TABLE [IAM].[RuoloSistemaStorico] (
    [RuoloSistemaId]     INT              NOT NULL,
    [CodiceRuolo]        NVARCHAR (100)   NOT NULL,
    [Descrizione]        NVARCHAR (500)   NULL,
    [Attivo]             BIT              NOT NULL,
    [DataCreazione]      DATETIME2 (7)    NOT NULL,
    [CreatoDa]           INT              NULL,
    [DataModifica]       DATETIME2 (7)    NULL,
    [ModificatoDa]       INT              NULL,
    [DataCancellazione]  DATETIME2 (7)    NULL,
    [CancellatoDa]       INT              NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita] DATETIME2 (7)    NOT NULL,
    [DataFineValidita]   DATETIME2 (7)    NOT NULL,
    [AmbitoRuolo]        NVARCHAR (20)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [CIX_RuoloSistemaStorico_Periodo]
    ON [IAM].[RuoloSistemaStorico]([DataInizioValidita] ASC, [DataFineValidita] ASC);


GO

