CREATE TABLE [Accreditamento].[AccordoMutualRiconoscimentoStorico] (
    [AccordoMutualRiconoscimentoId] INT              NOT NULL,
    [EnteAccreditamentoId]          INT              NOT NULL,
    [SchemaAccreditamentoId]        INT              NOT NULL,
    [StatoFirmatario]               NVARCHAR (30)    NOT NULL,
    [DataFirma]                     DATE             NOT NULL,
    [DataUltimaConferma]            DATE             NULL,
    [DataScadenzaConferma]          DATE             NULL,
    [OrganoDeliberante]             NVARCHAR (100)   NULL,
    [RiferimentoDocumentale]        NVARCHAR (255)   NULL,
    [DataCreazione]                 DATETIME2 (7)    NOT NULL,
    [CreatoDa]                      INT              NULL,
    [DataModifica]                  DATETIME2 (7)    NULL,
    [ModificatoDa]                  INT              NULL,
    [DataCancellazione]             DATETIME2 (7)    NULL,
    [CancellatoDa]                  INT              NULL,
    [UniqueRowId]                   UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]            DATETIME2 (7)    NOT NULL,
    [DataFineValidita]              DATETIME2 (7)    NOT NULL,
    [TipoAccordoRiconoscimentoId]   INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_AccordoMutualRiconoscimentoStorico]
    ON [Accreditamento].[AccordoMutualRiconoscimentoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

