CREATE TABLE [Accreditamento].[EnteAccreditamentoReteStorico] (
    [EnteAccreditamentoReteId] INT              NOT NULL,
    [EnteAccreditamentoId]     INT              NOT NULL,
    [TipoRete]                 NVARCHAR (20)    NOT NULL,
    [TipoMembership]           NVARCHAR (30)    NOT NULL,
    [DataAdesione]             DATE             NOT NULL,
    [DataCessazione]           DATE             NULL,
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

CREATE CLUSTERED INDEX [ix_EnteAccreditamentoReteStorico]
    ON [Accreditamento].[EnteAccreditamentoReteStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

