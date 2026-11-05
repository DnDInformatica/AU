CREATE TABLE [Standard].[ClassificazioneGovernanceStorico] (
    [ClassificazioneId]            INT              NOT NULL,
    [TipoSistemaClassificatorio]   NVARCHAR (80)    NOT NULL,
    [FonteCanonicaSoggettoFonteId] INT              NULL,
    [VersionabileFlag]             BIT              NOT NULL,
    [ConsenteGerarchia]            BIT              NOT NULL,
    [ConsenteCorrispondenze]       BIT              NOT NULL,
    [ConsenteVoceTecnica]          BIT              NOT NULL,
    [NoteGovernance]               NVARCHAR (2000)  NULL,
    [Attivo]                       BIT              NOT NULL,
    [DataCreazione]                DATETIME2 (7)    NOT NULL,
    [CreatoDa]                     INT              NULL,
    [DataModifica]                 DATETIME2 (7)    NULL,
    [ModificatoDa]                 INT              NULL,
    [DataCancellazione]            DATETIME2 (7)    NULL,
    [CancellatoDa]                 INT              NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]           DATETIME2 (7)    NOT NULL,
    [DataFineValidita]             DATETIME2 (7)    NOT NULL,
    [ConsentePiuPadri]             BIT              NULL
);


GO

CREATE CLUSTERED INDEX [ix_ClassificazioneGovernanceStorico]
    ON [Standard].[ClassificazioneGovernanceStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

