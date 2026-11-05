CREATE TABLE [Organizzazioni].[OrganoSocialeStorico] (
    [OrganoSocialeId]    INT              NOT NULL,
    [OrganizzazioneId]   INT              NOT NULL,
    [Codice]             NVARCHAR (50)    NOT NULL,
    [Denominazione]      NVARCHAR (250)   NOT NULL,
    [Descrizione]        NVARCHAR (1000)  NULL,
    [CategoriaOrgano]    NVARCHAR (100)   NULL,
    [Attivo]             BIT              NOT NULL,
    [FlagDelibereCSA]    BIT              NOT NULL,
    [DataInizio]         DATE             NULL,
    [DataFine]           DATE             NULL,
    [Note]               NVARCHAR (2000)  NULL,
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

CREATE CLUSTERED INDEX [ix_OrganoSocialeStorico]
    ON [Organizzazioni].[OrganoSocialeStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

