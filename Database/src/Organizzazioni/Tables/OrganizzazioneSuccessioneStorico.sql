CREATE TABLE [Organizzazioni].[OrganizzazioneSuccessioneStorico] (
    [OrganizzazioneSuccessioneId] INT              NOT NULL,
    [OrganizzazionePreId]         INT              NOT NULL,
    [OrganizzazionePostId]        INT              NOT NULL,
    [TipoEventoSocietarioId]      INT              NOT NULL,
    [DataAtto]                    DATE             NOT NULL,
    [DataEffettoGiuridico]        DATE             NOT NULL,
    [NumeroRepertorio]            NVARCHAR (50)    NULL,
    [NumeroRaccolta]              NVARCHAR (50)    NULL,
    [Notaio]                      NVARCHAR (200)   NULL,
    [ProtocolloRegistroImprese]   NVARCHAR (50)    NULL,
    [Note]                        NVARCHAR (MAX)   NULL,
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

CREATE CLUSTERED INDEX [ix_OrganizzazioneSuccessioneStorico]
    ON [Organizzazioni].[OrganizzazioneSuccessioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

