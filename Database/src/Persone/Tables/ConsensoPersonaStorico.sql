CREATE TABLE [Persone].[ConsensoPersonaStorico] (
    [ConsensoPersonaId]         INT              NOT NULL,
    [PersonaId]                 INT              NOT NULL,
    [TipoFinalitaTrattamentoId] INT              NOT NULL,
    [Consenso]                  BIT              NOT NULL,
    [DataConsenso]              DATETIME2 (7)    NOT NULL,
    [DataScadenza]              DATE             NULL,
    [DataRevoca]                DATETIME2 (7)    NULL,
    [ModalitaAcquisizione]      NVARCHAR (30)    NOT NULL,
    [RiferimentoDocumento]      NVARCHAR (200)   NULL,
    [IPAddress]                 NVARCHAR (45)    NULL,
    [UserAgent]                 NVARCHAR (500)   NULL,
    [MotivoRevoca]              NVARCHAR (500)   NULL,
    [ModalitaRevoca]            NVARCHAR (30)    NULL,
    [VersioneInformativa]       NVARCHAR (20)    NULL,
    [DataInformativa]           DATE             NULL,
    [Note]                      NVARCHAR (MAX)   NULL,
    [DataCreazione]             DATETIME2 (7)    NOT NULL,
    [CreatoDa]                  INT              NULL,
    [DataModifica]              DATETIME2 (7)    NULL,
    [ModificatoDa]              INT              NULL,
    [DataCancellazione]         DATETIME2 (7)    NULL,
    [CancellatoDa]              INT              NULL,
    [UniqueRowId]               UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]        DATETIME2 (7)    NOT NULL,
    [DataFineValidita]          DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ConsensoPersonaStorico]
    ON [Persone].[ConsensoPersonaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

