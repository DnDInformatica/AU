CREATE TABLE [RisorseUmane].[FormazioneObbligatoriaStorico] (
    [FormazioneObbligatoriaId]     INT              NOT NULL,
    [DipendenteId]                 INT              NOT NULL,
    [TipoFormazioneObbligatoriaId] INT              NOT NULL,
    [DataCompletamento]            DATE             NOT NULL,
    [DataScadenza]                 DATE             NULL,
    [EstremiAttestato]             NVARCHAR (200)   NULL,
    [EnteFormatore]                NVARCHAR (200)   NULL,
    [DurataOreCorso]               INT              NULL,
    [Note]                         NVARCHAR (MAX)   NULL,
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

CREATE CLUSTERED INDEX [ix_FormazioneObbligatoriaStorico]
    ON [RisorseUmane].[FormazioneObbligatoriaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

