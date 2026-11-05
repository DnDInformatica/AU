CREATE TABLE [Organizzazioni].[StrumentoFinanziarioSocietarioStorico] (
    [StrumentoFinanziarioSocietarioId] INT              NOT NULL,
    [OrganizzazioneId]                 INT              NOT NULL,
    [TipoStrumento]                    NVARCHAR (40)    NOT NULL,
    [ClasseStrumento]                  NVARCHAR (80)    NULL,
    [ISIN]                             NVARCHAR (20)    NULL,
    [Quantita]                         BIGINT           NULL,
    [ValoreNominaleUnitario]           DECIMAL (19, 6)  NULL,
    [Valuta]                           CHAR (3)         NOT NULL,
    [DataEmissione]                    DATE             NULL,
    [DataScadenza]                     DATE             NULL,
    [StatoStrumento]                   NVARCHAR (30)    NOT NULL,
    [DocumentoId]                      INT              NULL,
    [Note]                             NVARCHAR (1000)  NULL,
    [DataCreazione]                    DATETIME2 (7)    NOT NULL,
    [CreatoDa]                         INT              NULL,
    [DataModifica]                     DATETIME2 (7)    NULL,
    [ModificatoDa]                     INT              NULL,
    [DataCancellazione]                DATETIME2 (7)    NULL,
    [CancellatoDa]                     INT              NULL,
    [UniqueRowId]                      UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]               DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                 DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_StrumentoFinanziarioSocietarioStorico]
    ON [Organizzazioni].[StrumentoFinanziarioSocietarioStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

