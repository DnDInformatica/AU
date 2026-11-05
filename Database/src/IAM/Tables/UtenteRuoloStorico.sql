CREATE TABLE [IAM].[UtenteRuoloStorico] (
    [UtenteRuoloId]      INT              NOT NULL,
    [UtenteId]           INT              NOT NULL,
    [RuoloSistemaId]     INT              NOT NULL,
    [DataCreazione]      DATETIME2 (7)    NOT NULL,
    [CreatoDa]           INT              NULL,
    [DataCancellazione]  DATETIME2 (7)    NULL,
    [CancellatoDa]       INT              NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita] DATETIME2 (7)    NOT NULL,
    [DataFineValidita]   DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [CIX_UtenteRuoloStorico_Periodo]
    ON [IAM].[UtenteRuoloStorico]([DataInizioValidita] ASC, [DataFineValidita] ASC);


GO

