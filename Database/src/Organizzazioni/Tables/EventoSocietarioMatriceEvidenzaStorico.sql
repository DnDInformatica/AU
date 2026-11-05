CREATE TABLE [Organizzazioni].[EventoSocietarioMatriceEvidenzaStorico] (
    [EventoSocietarioMatriceEvidenzaId] INT              NOT NULL,
    [EventoSocietarioMatriceImpattoId]  INT              NOT NULL,
    [EvidenzaCodice]                    NVARCHAR (60)    NOT NULL,
    [Obbligatoria]                      BIT              NOT NULL,
    [Note]                              NVARCHAR (500)   NULL,
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

CREATE CLUSTERED INDEX [ix_EventoSocietarioMatriceEvidenzaStorico]
    ON [Organizzazioni].[EventoSocietarioMatriceEvidenzaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

