CREATE TABLE [Standard].[NACECorrispondenzaStorico] (
    [NACECorrispondenzaId] INT              NOT NULL,
    [VersioneDaId]         INT              NOT NULL,
    [NaceDaId]             INT              NOT NULL,
    [VersioneAId]          INT              NOT NULL,
    [NaceAId]              INT              NOT NULL,
    [Peso]                 DECIMAL (9, 6)   NULL,
    [Nota]                 NVARCHAR (500)   NULL,
    [DataCreazione]        DATETIME2 (7)    NOT NULL,
    [UniqueRowId]          UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]   DATETIME2 (7)    NOT NULL,
    [DataFineValidita]     DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_NACECorrispondenzaStorico]
    ON [Standard].[NACECorrispondenzaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

