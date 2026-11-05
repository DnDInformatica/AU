CREATE TABLE [Persone].[PersonaQualificaStorico] (
    [PersonaQualificaId]      INT              NOT NULL,
    [PersonaId]               INT              NOT NULL,
    [TipoQualificaId]         INT              NOT NULL,
    [EnteRilascioQualificaId] INT              NULL,
    [CodiceAttestato]         NVARCHAR (60)    NULL,
    [DataRilascio]            DATE             NULL,
    [DataScadenza]            DATE             NULL,
    [Valida]                  BIT              NOT NULL,
    [Note]                    NVARCHAR (300)   NULL,
    [DataCreazione]           DATETIME2 (7)    NOT NULL,
    [CreatoDa]                INT              NULL,
    [DataModifica]            DATETIME2 (7)    NULL,
    [ModificatoDa]            INT              NULL,
    [DataCancellazione]       DATETIME2 (7)    NULL,
    [CancellatoDa]            INT              NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]      DATETIME2 (7)    NOT NULL,
    [DataFineValidita]        DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_PersonaQualificaStorico]
    ON [Persone].[PersonaQualificaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

