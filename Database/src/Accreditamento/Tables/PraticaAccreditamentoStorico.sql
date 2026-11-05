CREATE TABLE [Accreditamento].[PraticaAccreditamentoStorico] (
    [PraticaAccreditamentoId]           INT              NOT NULL,
    [OrganizzazioneId]                  INT              NOT NULL,
    [SchemaAccreditamentoId]            INT              NOT NULL,
    [NormaAccreditamentoId]             INT              NULL,
    [CodicePPA]                         NVARCHAR (20)    NOT NULL,
    [NumeroRegistrazione]               NVARCHAR (20)    NOT NULL,
    [OggettoIta]                        NVARCHAR (MAX)   NULL,
    [OggettoEng]                        NVARCHAR (MAX)   NULL,
    [VariazioniIta]                     NVARCHAR (MAX)   NULL,
    [VariazioniEng]                     NVARCHAR (MAX)   NULL,
    [DataAccreditamento]                DATE             NOT NULL,
    [DataScadenza]                      DATE             NOT NULL,
    [NomeFilePDF]                       NVARCHAR (500)   NULL,
    [FlagEsclusoRT05]                   BIT              NOT NULL,
    [DataCreazione]                     DATETIME2 (7)    NOT NULL,
    [CreatoDa]                          INT              NULL,
    [DataModifica]                      DATETIME2 (7)    NULL,
    [ModificatoDa]                      INT              NULL,
    [DataCancellazione]                 DATETIME2 (7)    NULL,
    [CancellatoDa]                      INT              NULL,
    [UniqueRowId]                       UNIQUEIDENTIFIER NOT NULL,
    [StatoPraticaId]                    TINYINT          NOT NULL,
    [UltimaReleaseId]                   INT              NULL,
    [ChecksumSemantico]                 BIGINT           NULL,
    [DataInizioValidita]                DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                  DATETIME2 (7)    NOT NULL,
    [TipoScopoAccreditamentoId]         TINYINT          NOT NULL,
    [PerimetroFlessibilita]             NVARCHAR (MAX)   NULL,
    [DataConcessioneScopoFlex]          DATE             NULL,
    [RiferimentoDeliberaCSA]            NVARCHAR (200)   NULL,
    [AnalisiRischiRiferimento]          NVARCHAR (500)   NULL,
    [PraticaAccreditamentoPrecedenteId] INT              NULL
);


GO

CREATE CLUSTERED INDEX [ix_PraticaAccreditamentoStorico]
    ON [Accreditamento].[PraticaAccreditamentoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

