CREATE TABLE [Accreditamento].[OrganizzazioneEnteAccreditamentoStorico] (
    [OrganizzazioneEnteAccreditamentoId] INT              NOT NULL,
    [OrganizzazioneId]                   INT              NOT NULL,
    [EnteAccreditamentoId]               INT              NOT NULL,
    [TipoRelazione]                      NVARCHAR (30)    NOT NULL,
    [DataInizioRelazione]                DATE             NULL,
    [DataFineRelazione]                  DATE             NULL,
    [Note]                               NVARCHAR (500)   NULL,
    [DataCreazione]                      DATETIME2 (7)    NOT NULL,
    [CreatoDa]                           INT              NULL,
    [DataModifica]                       DATETIME2 (7)    NULL,
    [ModificatoDa]                       INT              NULL,
    [DataCancellazione]                  DATETIME2 (7)    NULL,
    [CancellatoDa]                       INT              NULL,
    [UniqueRowId]                        UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                 DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                   DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_OrganizzazioneEnteAccreditamentoStorico]
    ON [Accreditamento].[OrganizzazioneEnteAccreditamentoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

