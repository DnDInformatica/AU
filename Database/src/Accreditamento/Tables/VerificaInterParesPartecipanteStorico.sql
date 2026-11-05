CREATE TABLE [Accreditamento].[VerificaInterParesPartecipanteStorico] (
    [VerificaInterParesPartecipanteId] INT              NOT NULL,
    [VerificaInterParesId]             INT              NOT NULL,
    [EnteAccreditamentoId]             INT              NOT NULL,
    [RuoloNelTeam]                     NVARCHAR (30)    NOT NULL,
    [NumeroAssessor]                   INT              NULL,
    [DataCreazione]                    DATETIME2 (7)    NOT NULL,
    [CreatoDa]                         INT              NULL,
    [DataModifica]                     DATETIME2 (7)    NULL,
    [ModificatoDa]                     INT              NULL,
    [DataCancellazione]                DATETIME2 (7)    NULL,
    [CancellatoDa]                     INT              NULL,
    [UniqueRowId]                      UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]               DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                 DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_VerificaInterParesPartecipanteStorico]
    ON [Accreditamento].[VerificaInterParesPartecipanteStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

