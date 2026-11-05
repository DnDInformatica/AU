CREATE TABLE [Tipologica].[TipoUnitaOrganizzativaStorico] (
    [TipoUnitaOrganizzativaId]          INT              NOT NULL,
    [Codice]                            NVARCHAR (10)    NULL,
    [Descrizione]                       NVARCHAR (150)   NOT NULL,
    [TipoUnitaOrganizzativaCategoriaId] INT              NULL,
    [OrdineGerarchico]                  INT              NULL,
    [DataCreazione]                     DATETIME2 (7)    NOT NULL,
    [CreatoDa]                          INT              NULL,
    [DataModifica]                      DATETIME2 (7)    NULL,
    [ModificatoDa]                      INT              NULL,
    [DataCancellazione]                 DATETIME2 (7)    NULL,
    [CancellatoDa]                      INT              NULL,
    [UniqueRowId]                       UNIQUEIDENTIFIER NOT NULL,
    [CategoriaRegolatoria]              NVARCHAR (30)    NULL,
    [IsAuditabile]                      BIT              NOT NULL,
    [HasResponsabilitaTecnica]          BIT              NOT NULL,
    [PuoSvolgereAttivitaAccreditate]    BIT              NOT NULL,
    [NoteNormative]                     NVARCHAR (500)   NULL,
    [DataInizioValidita]                DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                  DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_TipoUnitaOrganizzativaStorico]
    ON [Tipologica].[TipoUnitaOrganizzativaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

