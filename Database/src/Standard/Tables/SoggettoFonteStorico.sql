CREATE TABLE [Standard].[SoggettoFonteStorico] (
    [SoggettoFonteId]                    INT              NOT NULL,
    [Codice]                             NVARCHAR (50)    NOT NULL,
    [Denominazione]                      NVARCHAR (400)   NOT NULL,
    [TipoSoggetto]                       NVARCHAR (40)    NOT NULL,
    [OrganismoDiNormazioneId]            INT              NULL,
    [SchemaCertificazioneProprietarioId] INT              NULL,
    [EnteAccreditamentoId]               INT              NULL,
    [RegolatoreId]                       INT              NULL,
    [CooperazioneAccreditamentoId]       INT              NULL,
    [Attivo]                             BIT              NOT NULL,
    [DataCreazione]                      DATETIME2 (7)    NOT NULL,
    [CreatoDa]                           INT              NULL,
    [DataModifica]                       DATETIME2 (7)    NULL,
    [ModificatoDa]                       INT              NULL,
    [DataCancellazione]                  DATETIME2 (7)    NULL,
    [CancellatoDa]                       INT              NULL,
    [UniqueRowId]                        UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                 DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                   DATETIME2 (7)    NOT NULL,
    [OrganizzazioneId]                   INT              NULL
);


GO

CREATE CLUSTERED INDEX [ix_SoggettoFonteStorico]
    ON [Standard].[SoggettoFonteStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

