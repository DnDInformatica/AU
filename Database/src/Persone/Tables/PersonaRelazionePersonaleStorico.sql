CREATE TABLE [Persone].[PersonaRelazionePersonaleStorico] (
    [PersonaRelazionePersonaleId] INT              NOT NULL,
    [PersonaId]                   INT              NOT NULL,
    [PersonaCollegataId]          INT              NOT NULL,
    [TipoRelazionePersonaleId]    INT              NOT NULL,
    [Note]                        NVARCHAR (500)   NULL,
    [DataCreazione]               DATETIME2 (7)    NOT NULL,
    [CreatoDa]                    INT              NULL,
    [DataModifica]                DATETIME2 (7)    NULL,
    [ModificatoDa]                INT              NULL,
    [DataCancellazione]           DATETIME2 (7)    NULL,
    [CancellatoDa]                INT              NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]          DATETIME2 (7)    NOT NULL,
    [DataFineValidita]            DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_PersonaRelazionePersonaleStorico]
    ON [Persone].[PersonaRelazionePersonaleStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

