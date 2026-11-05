CREATE TABLE [Organizzazioni].[EventoSocietarioImpattoOggettoStorico] (
    [EventoSocietarioImpattoOggettoId] INT              NOT NULL,
    [EventoSocietarioId]               INT              NOT NULL,
    [OggettoTipo]                      NVARCHAR (80)    NOT NULL,
    [OggettoId]                        INT              NOT NULL,
    [Azione]                           NVARCHAR (40)    NOT NULL,
    [Esito]                            NVARCHAR (40)    NOT NULL,
    [Decorrenza]                       DATE             NULL,
    [Dettaglio]                        NVARCHAR (MAX)   NULL,
    [DataCreazione]                    DATETIME2 (7)    NOT NULL,
    [CreatoDa]                         INT              NULL,
    [DataModifica]                     DATETIME2 (7)    NULL,
    [ModificatoDa]                     INT              NULL,
    [DataCancellazione]                DATETIME2 (7)    NULL,
    [CancellatoDa]                     INT              NULL,
    [UniqueRowId]                      UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]               DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                 DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_EventoSocietarioImpattoOggettoStorico]
    ON [Organizzazioni].[EventoSocietarioImpattoOggettoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

