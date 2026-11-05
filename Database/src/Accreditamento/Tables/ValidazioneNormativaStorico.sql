CREATE TABLE [Accreditamento].[ValidazioneNormativaStorico] (
    [ValidazioneNormativaId] BIGINT         NOT NULL,
    [EntityType]             NVARCHAR (50)  NOT NULL,
    [EntityId]               INT            NOT NULL,
    [Step]                   INT            NOT NULL,
    [Regola]                 NVARCHAR (100) NOT NULL,
    [StatoValidazione]       NVARCHAR (20)  NOT NULL,
    [Descrizione]            NVARCHAR (MAX) NULL,
    [DettagliViolazione]     NVARCHAR (MAX) NULL,
    [DataValidazione]        DATETIME2 (7)  NOT NULL,
    [UtenteCheHaValidato]    NVARCHAR (100) NULL,
    [DataCreazione]          DATETIME2 (7)  NOT NULL,
    [CreatoDa]               INT            NULL,
    [DataModifica]           DATETIME2 (7)  NULL,
    [ModificatoDa]           INT            NULL,
    [DataCancellazione]      DATETIME2 (7)  NULL,
    [CancellatoDa]           INT            NULL,
    [DataInizioValidita]     DATETIME2 (7)  NOT NULL,
    [DataFineValidita]       DATETIME2 (7)  NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ValidazioneNormativaStorico]
    ON [Accreditamento].[ValidazioneNormativaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

