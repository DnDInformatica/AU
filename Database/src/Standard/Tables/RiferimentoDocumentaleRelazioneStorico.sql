CREATE TABLE [Standard].[RiferimentoDocumentaleRelazioneStorico] (
    [RiferimentoDocumentaleRelazioneId] INT              NOT NULL,
    [RiferimentoOrigineId]              INT              NOT NULL,
    [RiferimentoDestinazioneId]         INT              NOT NULL,
    [TipoRelazione]                     NVARCHAR (40)    NOT NULL,
    [DataDecorrenza]                    DATE             NULL,
    [Note]                              NVARCHAR (1000)  NULL,
    [Attivo]                            BIT              NOT NULL,
    [DataCreazione]                     DATETIME2 (7)    NOT NULL,
    [CreatoDa]                          INT              NULL,
    [DataModifica]                      DATETIME2 (7)    NULL,
    [ModificatoDa]                      INT              NULL,
    [DataCancellazione]                 DATETIME2 (7)    NULL,
    [CancellatoDa]                      INT              NULL,
    [UniqueRowId]                       UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                  DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_RiferimentoDocumentaleRelazioneStorico]
    ON [Standard].[RiferimentoDocumentaleRelazioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

