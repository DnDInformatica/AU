CREATE TABLE [Accreditamento].[PraticaAltroSchemaSQStorico] (
    [PraticaAltroSchemaSQId]  INT              NOT NULL,
    [PraticaAccreditamentoId] INT              NOT NULL,
    [AltroSchemaSQId]         INT              NOT NULL,
    [LimitazioneIta]          NVARCHAR (MAX)   NULL,
    [LimitazioneEng]          NVARCHAR (MAX)   NULL,
    [DataCreazione]           DATETIME2 (7)    NOT NULL,
    [CreatoDa]                INT              NULL,
    [DataModifica]            DATETIME2 (7)    NULL,
    [ModificatoDa]            INT              NULL,
    [DataCancellazione]       DATETIME2 (7)    NULL,
    [CancellatoDa]            INT              NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER NOT NULL,
    [UltimaReleaseId]         INT              NULL,
    [ChecksumSemantico]       BIGINT           NULL,
    [SchemaAccreditamentoId]  INT              NOT NULL,
    [DataInizioValidita]      DATETIME2 (7)    NOT NULL,
    [DataFineValidita]        DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_PraticaAltroSchemaSQStorico]
    ON [Accreditamento].[PraticaAltroSchemaSQStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

