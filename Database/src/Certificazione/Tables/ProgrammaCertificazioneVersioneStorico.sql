CREATE TABLE [Certificazione].[ProgrammaCertificazioneVersioneStorico] (
    [ProgrammaCertificazioneVersioneId] INT              NOT NULL,
    [ProgrammaCertificazioneId]         INT              NOT NULL,
    [CodiceVersione]                    NVARCHAR (150)   NOT NULL,
    [VersioneSchema]                    NVARCHAR (200)   NULL,
    [TitoloVersione]                    NVARCHAR (510)   NULL,
    [DataEntrataVigore]                 DATE             NULL,
    [DataFineValiditaProgramma]         DATE             NULL,
    [CicloAnni]                         SMALLINT         NULL,
    [RichiedeEsame]                     BIT              NOT NULL,
    [RichiedeSorveglianza]              BIT              NOT NULL,
    [RichiedeDelibera]                  BIT              NOT NULL,
    [RichiedeCampoProva]                BIT              NOT NULL,
    [RichiedeDocentiQualificati]        BIT              NOT NULL,
    [StatoVersioneProgrammaId]          INT              NOT NULL,
    [VersioneCorrente]                  BIT              NOT NULL,
    [Note]                              NVARCHAR (4000)  NULL,
    [Attivo]                            BIT              NOT NULL,
    [DataCreazione]                     DATETIME2 (7)    NOT NULL,
    [CreatoDa]                          INT              NULL,
    [DataModifica]                      DATETIME2 (7)    NULL,
    [ModificatoDa]                      INT              NULL,
    [DataCancellazione]                 DATETIME2 (7)    NULL,
    [CancellatoDa]                      INT              NULL,
    [UniqueRowId]                       UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                  DATETIME2 (7)    NOT NULL,
    [SchemaCertificazioneVersioneId]    INT              NULL
);


GO

CREATE CLUSTERED INDEX [ix_ProgrammaCertificazioneVersioneStorico]
    ON [Certificazione].[ProgrammaCertificazioneVersioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

