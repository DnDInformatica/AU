CREATE TABLE [Certificazione].[CertificazioneSedeStorico] (
    [CertificazioneSedeId] INT              NOT NULL,
    [CertificazioneId]     INT              NOT NULL,
    [SedeId]               INT              NULL,
    [AmbitoIta]            NVARCHAR (MAX)   NULL,
    [AmbitoEng]            NVARCHAR (MAX)   NULL,
    [DataScadenzaSede]     DATE             NULL,
    [DataCreazione]        DATETIME2 (7)    NOT NULL,
    [CreatoDa]             INT              NULL,
    [DataModifica]         DATETIME2 (7)    NULL,
    [ModificatoDa]         INT              NULL,
    [DataCancellazione]    DATETIME2 (7)    NULL,
    [CancellatoDa]         INT              NULL,
    [UniqueRowId]          UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]   DATETIME2 (7)    NOT NULL,
    [DataFineValidita]     DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_CertificazioneSedeStorico]
    ON [Certificazione].[CertificazioneSedeStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

