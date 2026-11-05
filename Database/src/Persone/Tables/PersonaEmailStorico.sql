CREATE TABLE [Persone].[PersonaEmailStorico] (
    [PersonaEmailId]     INT              NOT NULL,
    [PersonaId]          INT              NOT NULL,
    [TipoEmailId]        INT              NOT NULL,
    [Email]              NVARCHAR (256)   NOT NULL,
    [Principale]         BIT              NOT NULL,
    [Verificata]         BIT              NOT NULL,
    [DataVerifica]       DATETIME2 (7)    NULL,
    [DataCreazione]      DATETIME2 (7)    NOT NULL,
    [CreatoDa]           INT              NULL,
    [DataModifica]       DATETIME2 (7)    NULL,
    [ModificatoDa]       INT              NULL,
    [DataCancellazione]  DATETIME2 (7)    NULL,
    [CancellatoDa]       INT              NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita] DATETIME2 (7)    NOT NULL,
    [DataFineValidita]   DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_PersonaEmailStorico]
    ON [Persone].[PersonaEmailStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

