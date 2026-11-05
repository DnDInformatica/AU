CREATE TABLE [Standard].[SchemaAccreditamentoStorico] (
    [SchemaAccreditamentoId]           INT              NOT NULL,
    [Codice]                           NVARCHAR (10)    NOT NULL,
    [CodiceInternazionale]             NVARCHAR (10)    NULL,
    [DenominazioneIta]                 NVARCHAR (500)   NOT NULL,
    [DenominazioneEng]                 NVARCHAR (500)   NULL,
    [ApplicaSettoriEA]                 BIT              NOT NULL,
    [IndiceOrdinamento]                INT              NULL,
    [Attivo]                           BIT              NOT NULL,
    [DataCreazione]                    DATETIME2 (7)    NOT NULL,
    [CreatoDa]                         INT              NULL,
    [DataModifica]                     DATETIME2 (7)    NULL,
    [ModificatoDa]                     INT              NULL,
    [DataCancellazione]                DATETIME2 (7)    NULL,
    [CancellatoDa]                     INT              NULL,
    [UniqueRowId]                      UNIQUEIDENTIFIER NOT NULL,
    [Proprietario]                     NVARCHAR (200)   NULL,
    [SitoWeb]                          NVARCHAR (500)   NULL,
    [Accreditabile]                    BIT              NOT NULL,
    [DataInizioValidita]               DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                 DATETIME2 (7)    NOT NULL,
    [DurataStandardCicloAnni]          TINYINT          NULL,
    [DurataMassimaCicloAnniConProroga] TINYINT          NULL
);


GO

CREATE CLUSTERED INDEX [ix_SchemaAccreditamentoStorico]
    ON [Standard].[SchemaAccreditamentoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

