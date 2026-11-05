CREATE TABLE [Organizzazioni].[OrganizzazioneDenominazioneStoricaStorico] (
    [OrganizzazioneDenominazioneStoricaId] INT              NOT NULL,
    [OrganizzazioneId]                     INT              NOT NULL,
    [EventoSocietarioId]                   INT              NULL,
    [RagioneSociale]                       NVARCHAR (1100)  NOT NULL,
    [Denominazione]                        NVARCHAR (1100)  NOT NULL,
    [DataInizioEffetto]                    DATE             NOT NULL,
    [DataFineEffetto]                      DATE             NULL,
    [Fonte]                                NVARCHAR (80)    NOT NULL,
    [DataCreazione]                        DATETIME2 (7)    NOT NULL,
    [CreatoDa]                             INT              NULL,
    [DataModifica]                         DATETIME2 (7)    NULL,
    [ModificatoDa]                         INT              NULL,
    [DataCancellazione]                    DATETIME2 (7)    NULL,
    [CancellatoDa]                         INT              NULL,
    [UniqueRowId]                          UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                   DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                     DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_OrganizzazioneDenominazioneStoricaStorico]
    ON [Organizzazioni].[OrganizzazioneDenominazioneStoricaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

