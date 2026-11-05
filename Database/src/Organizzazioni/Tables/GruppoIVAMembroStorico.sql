CREATE TABLE [Organizzazioni].[GruppoIVAMembroStorico] (
    [GruppoIVAMembroId]         INT              NOT NULL,
    [GruppoIVAId]               INT              NOT NULL,
    [OrganizzazioneId]          INT              NOT NULL,
    [DataAdesione]              DATE             NOT NULL,
    [DataUscita]                DATE             NULL,
    [MotivoUscita]              NVARCHAR (500)   NULL,
    [ProtocolloUscita]          NVARCHAR (50)    NULL,
    [IsCapogruppo]              BIT              NOT NULL,
    [RuoloNelGruppo]            NVARCHAR (100)   NULL,
    [PercentualePartecipazione] DECIMAL (5, 2)   NULL,
    [StatoMembro]               NVARCHAR (20)    NOT NULL,
    [Note]                      NVARCHAR (MAX)   NULL,
    [DataCreazione]             DATETIME2 (7)    NOT NULL,
    [CreatoDa]                  INT              NULL,
    [DataModifica]              DATETIME2 (7)    NULL,
    [ModificatoDa]              INT              NULL,
    [DataCancellazione]         DATETIME2 (7)    NULL,
    [CancellatoDa]              INT              NULL,
    [UniqueRowId]               UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]        DATETIME2 (7)    NOT NULL,
    [DataFineValidita]          DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_GruppoIVAMembroStorico]
    ON [Organizzazioni].[GruppoIVAMembroStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

