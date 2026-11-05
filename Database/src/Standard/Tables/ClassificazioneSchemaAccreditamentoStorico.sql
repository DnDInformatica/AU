CREATE TABLE [Standard].[ClassificazioneSchemaAccreditamentoStorico] (
    [ClassificazioneSchemaAccreditamentoId] INT              NOT NULL,
    [ClassificazioneId]                     INT              NOT NULL,
    [SchemaAccreditamentoId]                INT              NOT NULL,
    [RuoloApplicabilita]                    NVARCHAR (40)    NOT NULL,
    [RiferimentoDocumentaleId]              INT              NOT NULL,
    [Note]                                  NVARCHAR (2000)  NULL,
    [Attivo]                                BIT              NOT NULL,
    [DataCreazione]                         DATETIME2 (7)    NOT NULL,
    [CreatoDa]                              INT              NULL,
    [DataModifica]                          DATETIME2 (7)    NULL,
    [ModificatoDa]                          INT              NULL,
    [DataCancellazione]                     DATETIME2 (7)    NULL,
    [CancellatoDa]                          INT              NULL,
    [UniqueRowId]                           UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                    DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                      DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ClassificazioneSchemaAccreditamentoStorico]
    ON [Standard].[ClassificazioneSchemaAccreditamentoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

