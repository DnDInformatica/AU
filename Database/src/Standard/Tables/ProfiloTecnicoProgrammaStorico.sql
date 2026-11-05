CREATE TABLE [Standard].[ProfiloTecnicoProgrammaStorico] (
    [ProfiloTecnicoProgrammaId]         INT              NOT NULL,
    [ProgrammaCertificazioneVersioneId] INT              NOT NULL,
    [CodiceSpecificaTecnica]            NVARCHAR (50)    NOT NULL,
    [Codice]                            NVARCHAR (100)   NOT NULL,
    [DescrizioneIta]                    NVARCHAR (2000)  NOT NULL,
    [Ordinale]                          SMALLINT         NOT NULL,
    [StatoQualificazione]               NVARCHAR (30)    NOT NULL,
    [OrigineSistema]                    NVARCHAR (200)   NOT NULL,
    [RiferimentoOrigine]                NVARCHAR (500)   NULL,
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
    [DescrizioneEng]                    NVARCHAR (2000)  NULL
);


GO

CREATE CLUSTERED INDEX [ix_ProfiloTecnicoProgrammaStorico]
    ON [Standard].[ProfiloTecnicoProgrammaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione inglese da fonte attendibile. NULL se la traduzione non e disponibile; non duplicare automaticamente il testo italiano.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloTecnicoProgrammaStorico', @level2type = N'COLUMN', @level2name = N'DescrizioneEng';


GO

