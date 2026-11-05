CREATE TABLE [Standard].[SettoreEA_NACEStorico] (
    [SettoreEA_NACEId]   INT              NOT NULL,
    [SettoreEAId]        INT              NOT NULL,
    [NaceId]             INT              NOT NULL,
    [FlagPrincipale]     BIT              NOT NULL,
    [Origine]            NVARCHAR (50)    NOT NULL,
    [Confidenza]         TINYINT          NULL,
    [DataCreazione]      DATETIME2 (7)    NOT NULL,
    [CreatoDa]           INT              NULL,
    [DataModifica]       DATETIME2 (7)    NULL,
    [ModificatoDa]       INT              NULL,
    [DataCancellazione]  DATETIME2 (7)    NULL,
    [CancellatoDa]       INT              NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita] DATETIME2 (7)    NOT NULL,
    [DataFineValidita]   DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_SettoreEA_NACEStorico]
    ON [Standard].[SettoreEA_NACEStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

