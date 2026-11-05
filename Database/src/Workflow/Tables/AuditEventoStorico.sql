CREATE TABLE [Workflow].[AuditEventoStorico] (
    [AuditEventoId]        INT              NOT NULL,
    [OggettoId]            INT              NOT NULL,
    [Azione]               NVARCHAR (100)   NOT NULL,
    [Descrizione]          NVARCHAR (1000)  NULL,
    [AutorePersonaId]      INT              NULL,
    [DataEvento]           DATETIME2 (7)    NOT NULL,
    [PayloadJson]          NVARCHAR (MAX)   NULL,
    [DataCreazione]        DATETIME2 (7)    NOT NULL,
    [CreatoDa]             INT              NULL,
    [DataModifica]         DATETIME2 (7)    NULL,
    [ModificatoDa]         INT              NULL,
    [DataCancellazione]    DATETIME2 (7)    NULL,
    [CancellatoDa]         INT              NULL,
    [UniqueRowId]          UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]   DATETIME2 (7)    NOT NULL,
    [DataFineValidita]     DATETIME2 (7)    NOT NULL,
    [TipoOggettoDominioId] INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_AuditEventoStorico]
    ON [Workflow].[AuditEventoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

