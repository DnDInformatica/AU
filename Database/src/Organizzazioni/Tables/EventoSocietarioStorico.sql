CREATE TABLE [Organizzazioni].[EventoSocietarioStorico] (
    [EventoSocietarioId]        INT              NOT NULL,
    [TipoEventoSocietarioId]    INT              NOT NULL,
    [CodiceEvento]              NVARCHAR (100)   NULL,
    [StatoEvento]               NVARCHAR (40)    NOT NULL,
    [OrganizzazioneTargetId]    INT              NOT NULL,
    [OrganizzazionePreId]       INT              NULL,
    [OrganizzazionePostId]      INT              NULL,
    [DataAtto]                  DATE             NOT NULL,
    [DataEffettoGiuridico]      DATE             NULL,
    [FonteNormativa]            NVARCHAR (500)   NULL,
    [ProtocolloRegistroImprese] NVARCHAR (100)   NULL,
    [NumeroRepertorio]          NVARCHAR (100)   NULL,
    [NumeroRaccolta]            NVARCHAR (100)   NULL,
    [AutoritaProcedente]        NVARCHAR (400)   NULL,
    [TribunaleCompetente]       NVARCHAR (200)   NULL,
    [NumeroProcedura]           NVARCHAR (100)   NULL,
    [DataAperturaProcedura]     DATE             NULL,
    [DataChiusuraProcedura]     DATE             NULL,
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

CREATE CLUSTERED INDEX [ix_EventoSocietarioStorico]
    ON [Organizzazioni].[EventoSocietarioStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

