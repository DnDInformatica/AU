CREATE TABLE [Certificazione].[ProgrammaRequisitoFonteLegislativaStorico] (
    [ProgrammaRequisitoFonteLegislativaId] INT              NOT NULL,
    [ProgrammaRequisitoId]                 INT              NOT NULL,
    [FonteLegislativaPartizioneId]         INT              NOT NULL,
    [Note]                                 NVARCHAR (500)   NULL,
    [DataCreazione]                        DATETIME2 (7)    NOT NULL,
    [CreatoDa]                             INT              NULL,
    [DataModifica]                         DATETIME2 (7)    NULL,
    [ModificatoDa]                         INT              NULL,
    [DataCancellazione]                    DATETIME2 (7)    NULL,
    [CancellatoDa]                         INT              NULL,
    [UniqueRowId]                          UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                   DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                     DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ProgrammaRequisitoFonteLegislativaStorico]
    ON [Certificazione].[ProgrammaRequisitoFonteLegislativaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

