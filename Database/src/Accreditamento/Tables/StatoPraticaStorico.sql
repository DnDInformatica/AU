CREATE TABLE [Accreditamento].[StatoPraticaStorico] (
    [StatoPraticaId]     TINYINT        NOT NULL,
    [Codice]             NVARCHAR (20)  NOT NULL,
    [DescrizioneIta]     NVARCHAR (500) NOT NULL,
    [DescrizioneEng]     NVARCHAR (500) NULL,
    [Attivo]             BIT            NOT NULL,
    [DataCreazione]      DATETIME2 (7)  NOT NULL,
    [CreatoDa]           INT            NULL,
    [DataModifica]       DATETIME2 (7)  NULL,
    [ModificatoDa]       INT            NULL,
    [DataCancellazione]  DATETIME2 (7)  NULL,
    [CancellatoDa]       INT            NULL,
    [DataInizioValidita] DATETIME2 (7)  NOT NULL,
    [DataFineValidita]   DATETIME2 (7)  NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_StatoPraticaStorico]
    ON [Accreditamento].[StatoPraticaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

