CREATE TABLE [Certificazione].[ProgrammaRequisitoEvidenzaStorico] (
    [ProgrammaRequisitoEvidenzaId] INT              NOT NULL,
    [ProgrammaRequisitoId]         INT              NOT NULL,
    [TipoEvidenzaProgrammaId]      INT              NOT NULL,
    [CodiceEvidenza]               NVARCHAR (50)    NOT NULL,
    [Titolo]                       NVARCHAR (255)   NOT NULL,
    [Descrizione]                  NVARCHAR (MAX)   NULL,
    [Obbligatoria]                 BIT              NOT NULL,
    [RichiedeDocumento]            BIT              NOT NULL,
    [RichiedeValidazione]          BIT              NOT NULL,
    [FormatoAmmesso]               NVARCHAR (255)   NULL,
    [ValiditaMesi]                 SMALLINT         NULL,
    [NoteValidazione]              NVARCHAR (MAX)   NULL,
    [Ordine]                       SMALLINT         NOT NULL,
    [Attivo]                       BIT              NOT NULL,
    [DataCreazione]                DATETIME2 (7)    NOT NULL,
    [CreatoDa]                     INT              NULL,
    [DataModifica]                 DATETIME2 (7)    NULL,
    [ModificatoDa]                 INT              NULL,
    [DataCancellazione]            DATETIME2 (7)    NULL,
    [CancellatoDa]                 INT              NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]           DATETIME2 (7)    NOT NULL,
    [DataFineValidita]             DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ProgrammaRequisitoEvidenzaStorico]
    ON [Certificazione].[ProgrammaRequisitoEvidenzaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

