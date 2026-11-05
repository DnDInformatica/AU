CREATE TABLE [Ispettori].[IspettoreStorico] (
    [IspettoreId]                  INT              NOT NULL,
    [CodiceIspettore]              NVARCHAR (20)    NOT NULL,
    [PersonaId]                    INT              NOT NULL,
    [IsIspettoreInterno]           BIT              NOT NULL,
    [IncaricoId]                   INT              NULL,
    [DatoreLavoroOrganizzazioneId] INT              NULL,
    [TipoRapportoLavoro]           NVARCHAR (30)    NULL,
    [TipoRuoloIspettoreId]         INT              NOT NULL,
    [StatoIspettoreId]             INT              NOT NULL,
    [DataQualifica]                DATE             NOT NULL,
    [DataPrimaQualifica]           DATE             NULL,
    [DataUltimoRinnovo]            DATE             NULL,
    [DataScadenzaQualifica]        DATE             NULL,
    [NumeroConvenzione]            NVARCHAR (50)    NULL,
    [DataFirmaConvenzione]         DATE             NULL,
    [DataScadenzaConvenzione]      DATE             NULL,
    [TariffaGiornaliera]           DECIMAL (10, 2)  NULL,
    [IBAN]                         NVARCHAR (34)    NULL,
    [DisponibilitaMensile]         INT              NULL,
    [ZonaGeograficaPreferita]      NVARCHAR (200)   NULL,
    [Note]                         NVARCHAR (MAX)   NULL,
    [DataCreazione]                DATETIME2 (7)    NOT NULL,
    [CreatoDa]                     INT              NULL,
    [DataModifica]                 DATETIME2 (7)    NULL,
    [ModificatoDa]                 INT              NULL,
    [DataCancellazione]            DATETIME2 (7)    NULL,
    [CancellatoDa]                 INT              NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER NOT NULL,
    [DipendenteId]                 INT              NULL,
    [DataInizioValidita]           DATETIME2 (7)    NOT NULL,
    [DataFineValidita]             DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_IspettoreStorico]
    ON [Ispettori].[IspettoreStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

