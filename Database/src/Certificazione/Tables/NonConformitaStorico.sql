CREATE TABLE [Certificazione].[NonConformitaStorico] (
    [NonConformitaId]         INT              NOT NULL,
    [ValutazioneRequisitoId]  INT              NOT NULL,
    [TipoNonConformitaId]     INT              NOT NULL,
    [StatoNonConformitaId]    INT              NOT NULL,
    [CodiceNonConformita]     NVARCHAR (50)    NOT NULL,
    [Titolo]                  NVARCHAR (255)   NOT NULL,
    [Descrizione]             NVARCHAR (MAX)   NOT NULL,
    [DataRilevazione]         DATETIME2 (7)    NOT NULL,
    [RilevataDa]              INT              NULL,
    [DataScadenzaTrattamento] DATE             NULL,
    [DataChiusura]            DATETIME2 (7)    NULL,
    [ChiusaDa]                INT              NULL,
    [CausaRadice]             NVARCHAR (MAX)   NULL,
    [TrattamentoImmediato]    NVARCHAR (MAX)   NULL,
    [VerificaEfficacia]       NVARCHAR (MAX)   NULL,
    [Attivo]                  BIT              NOT NULL,
    [DataCreazione]           DATETIME2 (7)    NOT NULL,
    [CreatoDa]                INT              NULL,
    [DataModifica]            DATETIME2 (7)    NULL,
    [ModificatoDa]            INT              NULL,
    [DataCancellazione]       DATETIME2 (7)    NULL,
    [CancellatoDa]            INT              NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]      DATETIME2 (7)    NOT NULL,
    [DataFineValidita]        DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_NonConformitaStorico]
    ON [Certificazione].[NonConformitaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

