CREATE TABLE [Processi].[PraticaStorico] (
    [PraticaId]                  INT              NOT NULL,
    [Codice]                     NVARCHAR (100)   NOT NULL,
    [Oggetto]                    NVARCHAR (1000)  NOT NULL,
    [Descrizione]                NVARCHAR (MAX)   NULL,
    [StatoPraticaId]             TINYINT          NOT NULL,
    [DipartimentoAccrediaId]     INT              NULL,
    [OrganizzazioneId]           INT              NULL,
    [PraticaAccreditamentoId]    INT              NULL,
    [SchemaAccreditamentoId]     INT              NULL,
    [ResponsabilePersonaId]      INT              NULL,
    [DataApertura]               DATETIME2 (7)    NOT NULL,
    [DataChiusura]               DATETIME2 (7)    NULL,
    [DataCreazione]              DATETIME2 (7)    NOT NULL,
    [CreatoDa]                   INT              NULL,
    [DataModifica]               DATETIME2 (7)    NULL,
    [ModificatoDa]               INT              NULL,
    [DataCancellazione]          DATETIME2 (7)    NULL,
    [CancellatoDa]               INT              NULL,
    [UniqueRowId]                UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]         DATETIME2 (7)    NOT NULL,
    [DataFineValidita]           DATETIME2 (7)    NOT NULL,
    [TipoPraticaProcessoId]      INT              NULL,
    [NaturaProceduralePraticaId] INT              NOT NULL,
    [PrioritaLavorazioneId]      INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_PraticaStorico]
    ON [Processi].[PraticaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

