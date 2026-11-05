CREATE TABLE [Ispettori].[GruppoVerificaStorico] (
    [GruppoVerificaId]       INT              NOT NULL,
    [VisitaIspettivaId]      INT              NULL,
    [OrganismoAccreditatoId] INT              NOT NULL,
    [DipartimentoAccrediaId] INT              NOT NULL,
    [CodiceGruppo]           NVARCHAR (50)    NOT NULL,
    [DataCostituzione]       DATE             NOT NULL,
    [DataVerifica]           DATE             NULL,
    [DataFineVerifica]       DATE             NULL,
    [TipoVerifica]           NVARCHAR (50)    NOT NULL,
    [ModalitaVerifica]       NVARCHAR (50)    NOT NULL,
    [TeamLeaderId]           INT              NOT NULL,
    [StatoGruppo]            NVARCHAR (20)    NOT NULL,
    [ConflittiVerificati]    BIT              NOT NULL,
    [DataVerificaConflitti]  DATETIME2 (7)    NULL,
    [VerificaConflittiDa]    INT              NULL,
    [Note]                   NVARCHAR (MAX)   NULL,
    [NoteInterne]            NVARCHAR (MAX)   NULL,
    [DataCreazione]          DATETIME2 (7)    NOT NULL,
    [CreatoDa]               INT              NULL,
    [DataModifica]           DATETIME2 (7)    NULL,
    [ModificatoDa]           INT              NULL,
    [DataCancellazione]      DATETIME2 (7)    NULL,
    [CancellatoDa]           INT              NULL,
    [UniqueRowId]            UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]     DATETIME2 (7)    NOT NULL,
    [DataFineValidita]       DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_GruppoVerificaStorico]
    ON [Ispettori].[GruppoVerificaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

