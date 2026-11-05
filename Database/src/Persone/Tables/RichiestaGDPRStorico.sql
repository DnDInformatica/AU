CREATE TABLE [Persone].[RichiestaGDPRStorico] (
    [RichiestaGDPRId]              INT              NOT NULL,
    [PersonaId]                    INT              NULL,
    [NomeRichiedente]              NVARCHAR (100)   NOT NULL,
    [CognomeRichiedente]           NVARCHAR (100)   NOT NULL,
    [EmailRichiedente]             NVARCHAR (200)   NULL,
    [TelefonoRichiedente]          NVARCHAR (50)    NULL,
    [TipoDirittoInteressatoId]     INT              NOT NULL,
    [Codice]                       NVARCHAR (50)    NOT NULL,
    [DataRichiesta]                DATETIME2 (7)    NOT NULL,
    [CanaleRichiesta]              NVARCHAR (30)    NOT NULL,
    [DescrizioneRichiesta]         NVARCHAR (MAX)   NULL,
    [DocumentoIdentita]            NVARCHAR (100)   NULL,
    [DataScadenzaRisposta]         DATE             NOT NULL,
    [Stato]                        NVARCHAR (30)    NOT NULL,
    [ResponsabileGestioneId]       INT              NULL,
    [DataPresaInCarico]            DATETIME2 (7)    NULL,
    [DataRisposta]                 DATETIME2 (7)    NULL,
    [EsitoRichiesta]               NVARCHAR (30)    NULL,
    [MotivoRifiuto]                NVARCHAR (MAX)   NULL,
    [DescrizioneRisposta]          NVARCHAR (MAX)   NULL,
    [ModalitaRisposta]             NVARCHAR (30)    NULL,
    [RiferimentoDocumentoRisposta] NVARCHAR (200)   NULL,
    [Note]                         NVARCHAR (MAX)   NULL,
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

CREATE CLUSTERED INDEX [ix_RichiestaGDPRStorico]
    ON [Persone].[RichiestaGDPRStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

