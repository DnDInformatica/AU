CREATE TABLE [Eventi].[EventoPartecipanteStorico] (
    [EventoPartecipanteId]            INT              NOT NULL,
    [EventoId]                        INT              NOT NULL,
    [PersonaId]                       INT              NOT NULL,
    [Presente]                        BIT              NULL,
    [DelegatoDaPersonaId]             INT              NULL,
    [DataInvito]                      DATETIME2 (7)    NULL,
    [DataRisposta]                    DATETIME2 (7)    NULL,
    [Note]                            NVARCHAR (1000)  NULL,
    [DataCreazione]                   DATETIME2 (7)    NOT NULL,
    [CreatoDa]                        INT              NULL,
    [DataModifica]                    DATETIME2 (7)    NULL,
    [ModificatoDa]                    INT              NULL,
    [DataCancellazione]               DATETIME2 (7)    NULL,
    [CancellatoDa]                    INT              NULL,
    [UniqueRowId]                     UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]              DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                DATETIME2 (7)    NOT NULL,
    [TipoRuoloPartecipazioneEventoId] INT              NOT NULL,
    [StatoInvitoEventoId]             INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_EventoPartecipanteStorico]
    ON [Eventi].[EventoPartecipanteStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

