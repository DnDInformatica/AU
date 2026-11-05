CREATE TABLE [Organizzazioni].[AttoSocietarioStorico] (
    [AttoSocietarioId]            INT              NOT NULL,
    [OrganizzazioneId]            INT              NOT NULL,
    [TipoAtto]                    NVARCHAR (50)    NOT NULL,
    [Titolo]                      NVARCHAR (300)   NOT NULL,
    [DataAtto]                    DATE             NOT NULL,
    [DataDepositoRegistroImprese] DATE             NULL,
    [Notaio]                      NVARCHAR (200)   NULL,
    [NumeroRepertorio]            NVARCHAR (50)    NULL,
    [NumeroRaccolta]              NVARCHAR (50)    NULL,
    [VersioneAtto]                NVARCHAR (40)    NULL,
    [OggettoSintetico]            NVARCHAR (1000)  NULL,
    [DocumentoId]                 INT              NULL,
    [Fonte]                       NVARCHAR (60)    NOT NULL,
    [Note]                        NVARCHAR (2000)  NULL,
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

CREATE CLUSTERED INDEX [ix_AttoSocietarioStorico]
    ON [Organizzazioni].[AttoSocietarioStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

