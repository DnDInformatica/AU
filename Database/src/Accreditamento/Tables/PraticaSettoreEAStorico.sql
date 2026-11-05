CREATE TABLE [Accreditamento].[PraticaSettoreEAStorico] (
    [PraticaSettoreEAId]      INT              NOT NULL,
    [PraticaAccreditamentoId] INT              NOT NULL,
    [SettoreEAId]             INT              NOT NULL,
    [LimitazioneIta]          NVARCHAR (MAX)   NULL,
    [LimitazioneEng]          NVARCHAR (MAX)   NULL,
    [SospDataInizio]          DATE             NULL,
    [SospDataFine]            DATE             NULL,
    [DerogaSospFlag]          BIT              NOT NULL,
    [DerogaSospTesto]         NVARCHAR (MAX)   NULL,
    [DataCreazione]           DATETIME2 (7)    NOT NULL,
    [CreatoDa]                INT              NULL,
    [DataModifica]            DATETIME2 (7)    NULL,
    [ModificatoDa]            INT              NULL,
    [DataCancellazione]       DATETIME2 (7)    NULL,
    [CancellatoDa]            INT              NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER NOT NULL,
    [UltimaReleaseId]         INT              NULL,
    [ChecksumSemantico]       BIGINT           NULL,
    [DataInizioValidita]      DATETIME2 (7)    NOT NULL,
    [DataFineValidita]        DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_PraticaSettoreEAStorico]
    ON [Accreditamento].[PraticaSettoreEAStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

