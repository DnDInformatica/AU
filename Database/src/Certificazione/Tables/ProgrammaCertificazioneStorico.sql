CREATE TABLE [Certificazione].[ProgrammaCertificazioneStorico] (
    [ProgrammaCertificazioneId]   INT              NOT NULL,
    [Codice]                      NVARCHAR (50)    NOT NULL,
    [Nome]                        NVARCHAR (255)   NOT NULL,
    [Descrizione]                 NVARCHAR (1000)  NULL,
    [NormaAccreditamentoSchemaId] INT              NOT NULL,
    [ProprietarioSchema]          NVARCHAR (100)   NULL,
    [CodiceSchemaProprietario]    NVARCHAR (100)   NULL,
    [TipoProgramma]               NVARCHAR (50)    NOT NULL,
    [Attivo]                      BIT              NOT NULL,
    [DataCreazione]               DATETIME2 (7)    NOT NULL,
    [CreatoDa]                    INT              NULL,
    [DataModifica]                DATETIME2 (7)    NULL,
    [ModificatoDa]                INT              NULL,
    [DataCancellazione]           DATETIME2 (7)    NULL,
    [CancellatoDa]                INT              NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]          DATETIME2 (7)    NOT NULL,
    [DataFineValidita]            DATETIME2 (7)    NOT NULL,
    [SchemaCertificazioneId]      INT              NULL
);


GO

CREATE CLUSTERED INDEX [ix_ProgrammaCertificazioneStorico]
    ON [Certificazione].[ProgrammaCertificazioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

