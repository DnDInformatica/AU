CREATE TABLE [Standard].[CooperazioneAccreditamentoStorico] (
    [CooperazioneAccreditamentoId] INT              NOT NULL,
    [OrganizzazioneId]             INT              NOT NULL,
    [Codice]                       NVARCHAR (50)    NOT NULL,
    [Denominazione]                NVARCHAR (400)   NOT NULL,
    [Ambito]                       NVARCHAR (40)    NOT NULL,
    [Attivo]                       BIT              NOT NULL,
    [DataCreazione]                DATETIME2 (7)    NOT NULL,
    [CreatoDa]                     INT              NULL,
    [DataModifica]                 DATETIME2 (7)    NULL,
    [ModificatoDa]                 INT              NULL,
    [DataCancellazione]            DATETIME2 (7)    NULL,
    [CancellatoDa]                 INT              NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]           DATETIME2 (7)    NOT NULL,
    [DataFineValidita]             DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_CooperazioneAccreditamentoStorico]
    ON [Standard].[CooperazioneAccreditamentoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

