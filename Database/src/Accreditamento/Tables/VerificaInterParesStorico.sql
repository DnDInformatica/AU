CREATE TABLE [Accreditamento].[VerificaInterParesStorico] (
    [VerificaInterParesId]         INT              NOT NULL,
    [EnteAccreditamentoValutatoId] INT              NOT NULL,
    [TipoVerifica]                 NVARCHAR (30)    NOT NULL,
    [DataInizio]                   DATE             NOT NULL,
    [DataFine]                     DATE             NULL,
    [OrganoDeliberante]            NVARCHAR (100)   NOT NULL,
    [DataDecisione]                DATE             NULL,
    [EsitoDecisione]               NVARCHAR (50)    NULL,
    [DataProssimaVerifica]         DATE             NULL,
    [Note]                         NVARCHAR (MAX)   NULL,
    [DataCreazione]                DATETIME2 (7)    NOT NULL,
    [CreatoDa]                     INT              NULL,
    [DataModifica]                 DATETIME2 (7)    NULL,
    [ModificatoDa]                 INT              NULL,
    [DataCancellazione]            DATETIME2 (7)    NULL,
    [CancellatoDa]                 INT              NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]           DATETIME2 (7)    NOT NULL,
    [DataFineValidita]             DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_VerificaInterParesStorico]
    ON [Accreditamento].[VerificaInterParesStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

