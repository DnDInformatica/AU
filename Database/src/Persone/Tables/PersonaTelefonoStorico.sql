CREATE TABLE [Persone].[PersonaTelefonoStorico] (
    [PersonaTelefonoId]      INT              NOT NULL,
    [PersonaId]              INT              NOT NULL,
    [TipoTelefonoId]         INT              NOT NULL,
    [PrefissoInternazionale] NVARCHAR (10)    NULL,
    [Numero]                 NVARCHAR (50)    NOT NULL,
    [Estensione]             NVARCHAR (10)    NULL,
    [Principale]             BIT              NOT NULL,
    [Verificato]             BIT              NOT NULL,
    [DataVerifica]           DATETIME2 (7)    NULL,
    [DataCreazione]          DATETIME2 (7)    NOT NULL,
    [CreatoDa]               INT              NULL,
    [DataModifica]           DATETIME2 (7)    NULL,
    [ModificatoDa]           INT              NULL,
    [DataCancellazione]      DATETIME2 (7)    NULL,
    [CancellatoDa]           INT              NULL,
    [UniqueRowId]            UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]     DATETIME2 (7)    NOT NULL,
    [DataFineValidita]       DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_PersonaTelefonoStorico]
    ON [Persone].[PersonaTelefonoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

