CREATE TABLE [Standard].[NormaFamigliaRelazioneStorico] (
    [NormaFamigliaRelazioneId]    INT              NOT NULL,
    [NormaFamigliaOrigineId]      INT              NOT NULL,
    [NormaFamigliaDestinazioneId] INT              NOT NULL,
    [TipoRelazione]               VARCHAR (30)     NOT NULL,
    [Ordine]                      SMALLINT         NULL,
    [Gerarchica]                  BIT              NOT NULL,
    [DescrizioneRelazione]        NVARCHAR (1000)  NULL,
    [Attivo]                      BIT              NOT NULL,
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

CREATE CLUSTERED INDEX [ix_NormaFamigliaRelazioneStorico]
    ON [Standard].[NormaFamigliaRelazioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

