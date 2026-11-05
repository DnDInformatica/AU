CREATE TABLE [Accreditamento].[ElencoDettaglioFlessibileStorico] (
    [ElencoDettaglioFlessibileId] INT              NOT NULL,
    [PraticaAccreditamentoId]     INT              NOT NULL,
    [TipologiaFamiglia]           NVARCHAR (400)   NOT NULL,
    [OggettoDettaglio]            NVARCHAR (1000)  NOT NULL,
    [DescrizioneEstesa]           NVARCHAR (MAX)   NULL,
    [NormaEdizioneId]             INT              NULL,
    [CodiceNormaTesto]            NVARCHAR (200)   NULL,
    [AnnoRevisioneNorma]          NVARCHAR (40)    NULL,
    [DocumentoRegoleRiferimento]  NVARCHAR (500)   NULL,
    [DataInserimentoCAB]          DATE             NOT NULL,
    [DataModificaCAB]             DATE             NULL,
    [DataCancellazioneCAB]        DATE             NULL,
    [StatoElementoFlessibileId]   TINYINT          NOT NULL,
    [UrlPubblicazione]            NVARCHAR (1000)  NULL,
    [FlagVisibilitaPubblica]      BIT              NOT NULL,
    [RegistrazioneIstruttoriaCAB] NVARCHAR (MAX)   NULL,
    [NoteValidazione]             NVARCHAR (MAX)   NULL,
    [DataCreazione]               DATETIME2 (7)    NOT NULL,
    [CreatoDa]                    INT              NULL,
    [DataModifica]                DATETIME2 (7)    NULL,
    [ModificatoDa]                INT              NULL,
    [DataCancellazione]           DATETIME2 (7)    NULL,
    [CancellatoDa]                INT              NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]          DATETIME2 (7)    NOT NULL,
    [DataFineValidita]            DATETIME2 (7)    NOT NULL,
    [HashBusinessKey]             BINARY (32)      NULL
);


GO

CREATE CLUSTERED INDEX [ix_ElencoDettaglioFlessibileStorico]
    ON [Accreditamento].[ElencoDettaglioFlessibileStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

