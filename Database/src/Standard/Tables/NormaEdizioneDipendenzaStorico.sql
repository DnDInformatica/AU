CREATE TABLE [Standard].[NormaEdizioneDipendenzaStorico] (
    [NormaEdizioneDipendenzaId] INT              NOT NULL,
    [NormaEdizioneOrigineId]    INT              NOT NULL,
    [NormaEdizioneDipendenteId] INT              NOT NULL,
    [TipoDipendenzaNormaId]     INT              NOT NULL,
    [Obbligatoria]              BIT              NOT NULL,
    [Note]                      NVARCHAR (1000)  NULL,
    [Attivo]                    BIT              NOT NULL,
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

CREATE CLUSTERED INDEX [ix_NormaEdizioneDipendenzaStorico]
    ON [Standard].[NormaEdizioneDipendenzaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

