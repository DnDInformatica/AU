CREATE TABLE [Documentale].[DocumentoPermessoStorico] (
    [DocumentoPermessoId]        INT              NOT NULL,
    [DocumentoId]                INT              NOT NULL,
    [DestinatarioId]             INT              NOT NULL,
    [CanRead]                    BIT              NOT NULL,
    [CanWrite]                   BIT              NOT NULL,
    [CanApprove]                 BIT              NOT NULL,
    [CanDelete]                  BIT              NOT NULL,
    [DataCreazione]              DATETIME2 (7)    NOT NULL,
    [CreatoDa]                   INT              NULL,
    [DataModifica]               DATETIME2 (7)    NULL,
    [ModificatoDa]               INT              NULL,
    [DataCancellazione]          DATETIME2 (7)    NULL,
    [CancellatoDa]               INT              NULL,
    [UniqueRowId]                UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]         DATETIME2 (7)    NOT NULL,
    [DataFineValidita]           DATETIME2 (7)    NOT NULL,
    [TipoDestinatarioPermessoId] INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_DocumentoPermessoStorico]
    ON [Documentale].[DocumentoPermessoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

