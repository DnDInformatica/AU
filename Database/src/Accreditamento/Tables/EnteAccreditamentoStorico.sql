CREATE TABLE [Accreditamento].[EnteAccreditamentoStorico] (
    [EnteAccreditamentoId] INT              NOT NULL,
    [Denominazione]        NVARCHAR (255)   NOT NULL,
    [Sigla]                NVARCHAR (50)    NULL,
    [Note]                 NVARCHAR (MAX)   NULL,
    [DataFondazione]       DATE             NULL,
    [DataCreazione]        DATETIME2 (7)    NOT NULL,
    [CreatoDa]             INT              NULL,
    [DataModifica]         DATETIME2 (7)    NULL,
    [ModificatoDa]         INT              NULL,
    [DataCancellazione]    DATETIME2 (7)    NULL,
    [CancellatoDa]         INT              NULL,
    [UniqueRowId]          UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]   DATETIME2 (7)    NOT NULL,
    [DataFineValidita]     DATETIME2 (7)    NOT NULL,
    [PaeseCodiceISO]       CHAR (2)         NULL
);


GO

CREATE CLUSTERED INDEX [ix_EnteAccreditamentoStorico]
    ON [Accreditamento].[EnteAccreditamentoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

