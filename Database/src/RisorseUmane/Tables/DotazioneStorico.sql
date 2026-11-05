CREATE TABLE [RisorseUmane].[DotazioneStorico] (
    [DotazioneId]        INT              NOT NULL,
    [DipendenteId]       INT              NOT NULL,
    [TipoDotazioneId]    INT              NOT NULL,
    [Descrizione]        NVARCHAR (200)   NOT NULL,
    [NumeroInventario]   NVARCHAR (50)    NULL,
    [NumeroSerie]        NVARCHAR (100)   NULL,
    [DataAssegnazione]   DATE             NOT NULL,
    [DataRestituzione]   DATE             NULL,
    [IsRestituito]       BIT              NOT NULL,
    [Note]               NVARCHAR (MAX)   NULL,
    [DataCreazione]      DATETIME2 (7)    NOT NULL,
    [CreatoDa]           INT              NULL,
    [DataModifica]       DATETIME2 (7)    NULL,
    [ModificatoDa]       INT              NULL,
    [DataCancellazione]  DATETIME2 (7)    NULL,
    [CancellatoDa]       INT              NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita] DATETIME2 (7)    NOT NULL,
    [DataFineValidita]   DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_DotazioneStorico]
    ON [RisorseUmane].[DotazioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

