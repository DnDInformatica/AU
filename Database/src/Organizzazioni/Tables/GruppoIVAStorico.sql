CREATE TABLE [Organizzazioni].[GruppoIVAStorico] (
    [GruppoIVAId]                INT              NOT NULL,
    [PartitaIVAGruppo]           NVARCHAR (11)    NOT NULL,
    [Denominazione]              NVARCHAR (255)   NOT NULL,
    [CodiceGruppo]               NVARCHAR (50)    NULL,
    [DataCostituzione]           DATE             NOT NULL,
    [DataApprovazione]           DATE             NULL,
    [ProtocolloAgenziaEntrate]   NVARCHAR (50)    NULL,
    [NumeroProvvedimento]        NVARCHAR (50)    NULL,
    [StatoGruppo]                NVARCHAR (20)    NOT NULL,
    [DataCessazione]             DATE             NULL,
    [MotivoCessazione]           NVARCHAR (500)   NULL,
    [OrganizzazioneCapogruppoId] INT              NULL,
    [Note]                       NVARCHAR (MAX)   NULL,
    [DocumentazioneRiferimento]  NVARCHAR (500)   NULL,
    [DataCreazione]              DATETIME2 (7)    NOT NULL,
    [CreatoDa]                   INT              NULL,
    [DataModifica]               DATETIME2 (7)    NULL,
    [ModificatoDa]               INT              NULL,
    [DataCancellazione]          DATETIME2 (7)    NULL,
    [CancellatoDa]               INT              NULL,
    [UniqueRowId]                UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]         DATETIME2 (7)    NOT NULL,
    [DataFineValidita]           DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_GruppoIVAStorico]
    ON [Organizzazioni].[GruppoIVAStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

