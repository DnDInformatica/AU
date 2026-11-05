CREATE TABLE [Standard].[ClassificazioneDominioSemanticoStorico] (
    [ClassificazioneDominioSemanticoId] INT              NOT NULL,
    [ClassificazioneId]                 INT              NOT NULL,
    [DominioSemanticoId]                INT              NOT NULL,
    [RuoloDominio]                      NVARCHAR (20)    NOT NULL,
    [RiferimentoDocumentaleId]          INT              NULL,
    [Motivazione]                       NVARCHAR (2000)  NULL,
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

CREATE CLUSTERED INDEX [ix_ClassificazioneDominioSemanticoStorico]
    ON [Standard].[ClassificazioneDominioSemanticoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

