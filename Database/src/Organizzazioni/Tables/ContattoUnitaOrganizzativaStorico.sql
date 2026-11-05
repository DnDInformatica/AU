CREATE TABLE [Organizzazioni].[ContattoUnitaOrganizzativaStorico] (
    [ContattoId]           INT              NOT NULL,
    [UnitaOrganizzativaId] INT              NOT NULL,
    [TipoContattoId]       INT              NOT NULL,
    [Valore]               NVARCHAR (500)   NOT NULL,
    [ValoreSecondario]     NVARCHAR (500)   NULL,
    [Descrizione]          NVARCHAR (250)   NULL,
    [Note]                 NVARCHAR (MAX)   NULL,
    [DataInizio]           DATE             NOT NULL,
    [DataFine]             DATE             NULL,
    [Principale]           BIT              NOT NULL,
    [OrdinePriorita]       INT              NULL,
    [IsVerificato]         BIT              NOT NULL,
    [DataVerifica]         DATETIME2 (7)    NULL,
    [IsPubblico]           BIT              NOT NULL,
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

CREATE CLUSTERED INDEX [ix_ContattoUnitaOrganizzativaStorico]
    ON [Organizzazioni].[ContattoUnitaOrganizzativaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

