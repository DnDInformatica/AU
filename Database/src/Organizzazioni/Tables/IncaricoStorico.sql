CREATE TABLE [Organizzazioni].[IncaricoStorico] (
    [IncaricoId]             INT              NOT NULL,
    [PersonaId]              INT              NOT NULL,
    [TipoRuoloId]            INT              NOT NULL,
    [OrganizzazioneId]       INT              NULL,
    [UnitaOrganizzativaId]   INT              NULL,
    [DataInizio]             DATE             NOT NULL,
    [DataFine]               DATE             NULL,
    [FonteNomina]            NVARCHAR (50)    NOT NULL,
    [DataDelibera]           DATE             NULL,
    [NumeroAtto]             NVARCHAR (50)    NULL,
    [NotaioRogante]          NVARCHAR (200)   NULL,
    [RepertorioNotarile]     NVARCHAR (50)    NULL,
    [StatoIncarico]          NVARCHAR (20)    NOT NULL,
    [MotivoCessazione]       NVARCHAR (500)   NULL,
    [DescrizioneEstesa]      NVARCHAR (500)   NULL,
    [IsAdInterim]            BIT              NOT NULL,
    [IncaricoSostituitoId]   INT              NULL,
    [ProtocolloCCIAA]        NVARCHAR (50)    NULL,
    [DataComunicazioneCCIAA] DATE             NULL,
    [Note]                   NVARCHAR (MAX)   NULL,
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

CREATE CLUSTERED INDEX [ix_IncaricoStorico]
    ON [Organizzazioni].[IncaricoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

