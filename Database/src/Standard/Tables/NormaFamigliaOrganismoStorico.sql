CREATE TABLE [Standard].[NormaFamigliaOrganismoStorico] (
    [NormaFamigliaOrganismoId] INT              NOT NULL,
    [NormaFamigliaId]          INT              NOT NULL,
    [OrganismoDiNormazioneId]  INT              NOT NULL,
    [Ruolo]                    VARCHAR (30)     NOT NULL,
    [OrdineDesignazione]       SMALLINT         NULL,
    [Attivo]                   BIT              NOT NULL,
    [DataCreazione]            DATETIME2 (7)    NOT NULL,
    [CreatoDa]                 INT              NULL,
    [DataModifica]             DATETIME2 (7)    NULL,
    [ModificatoDa]             INT              NULL,
    [DataCancellazione]        DATETIME2 (7)    NULL,
    [CancellatoDa]             INT              NULL,
    [UniqueRowId]              UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]       DATETIME2 (7)    NOT NULL,
    [DataFineValidita]         DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_NormaFamigliaOrganismoStorico]
    ON [Standard].[NormaFamigliaOrganismoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

