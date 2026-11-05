CREATE TABLE [Standard].[FonteLegislativaPartizioneStorico] (
    [FonteLegislativaPartizioneId] INT              NOT NULL,
    [FonteLegislativaId]           INT              NOT NULL,
    [ParentPartizioneId]           INT              NULL,
    [TipoPartizioneFonteId]        INT              NOT NULL,
    [CodicePartizione]             VARCHAR (100)    NOT NULL,
    [TitoloPartizione]             NVARCHAR (500)   NULL,
    [Descrizione]                  NVARCHAR (2000)  NULL,
    [Ordinamento]                  INT              NULL,
    [PartizioneInteraFonte]        BIT              NOT NULL,
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

CREATE CLUSTERED INDEX [ix_FonteLegislativaPartizioneStorico]
    ON [Standard].[FonteLegislativaPartizioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

