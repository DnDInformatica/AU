CREATE TABLE [Persone].[RichiestaEsercizioDirittiStorico] (
    [RichiestaEsercizioDirittiId] INT              NOT NULL,
    [PersonaId]                   INT              NULL,
    [NomeRichiedente]             NVARCHAR (200)   NOT NULL,
    [EmailRichiedente]            NVARCHAR (200)   NOT NULL,
    [TelefonoRichiedente]         NVARCHAR (50)    NULL,
    [Codice]                      NVARCHAR (30)    NOT NULL,
    [TipoDirittoGDPRId]           INT              NOT NULL,
    [DataRichiesta]               DATETIME2 (7)    NOT NULL,
    [ModalitaRichiesta]           NVARCHAR (30)    NOT NULL,
    [TestoRichiesta]              NVARCHAR (MAX)   NULL,
    [DocumentoRichiesta]          NVARCHAR (500)   NULL,
    [IdentitaVerificata]          BIT              NOT NULL,
    [DataVerificaIdentita]        DATETIME2 (7)    NULL,
    [ModalitaVerifica]            NVARCHAR (100)   NULL,
    [DataScadenza]                DATE             NOT NULL,
    [DataProrogaRichiesta]        DATE             NULL,
    [MotivoProrogaRichiesta]      NVARCHAR (500)   NULL,
    [Stato]                       NVARCHAR (30)    NOT NULL,
    [ResponsabileGestioneId]      INT              NULL,
    [Note]                        NVARCHAR (MAX)   NULL,
    [DataRisposta]                DATETIME2 (7)    NULL,
    [EsitoRisposta]               NVARCHAR (30)    NULL,
    [MotivoRifiuto]               NVARCHAR (MAX)   NULL,
    [TestoRisposta]               NVARCHAR (MAX)   NULL,
    [DocumentoRisposta]           NVARCHAR (500)   NULL,
    [DataEsecuzione]              DATETIME2 (7)    NULL,
    [DatiCancellati]              NVARCHAR (MAX)   NULL,
    [DataCreazione]               DATETIME2 (7)    NOT NULL,
    [CreatoDa]                    INT              NULL,
    [DataModifica]                DATETIME2 (7)    NULL,
    [ModificatoDa]                INT              NULL,
    [DataCancellazione]           DATETIME2 (7)    NULL,
    [CancellatoDa]                INT              NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]          DATETIME2 (7)    NOT NULL,
    [DataFineValidita]            DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_RichiestaEsercizioDirittiStorico]
    ON [Persone].[RichiestaEsercizioDirittiStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

