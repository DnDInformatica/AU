CREATE TABLE [Organizzazioni].[IndirizzoUnitaOrganizzativaStorico] (
    [IndirizzoId]          INT              NOT NULL,
    [UnitaOrganizzativaId] INT              NOT NULL,
    [TipoIndirizzoId]      INT              NOT NULL,
    [ComuneId]             INT              NULL,
    [Indirizzo]            NVARCHAR (250)   NOT NULL,
    [NumeroCivico]         NVARCHAR (20)    NULL,
    [CAP]                  NVARCHAR (5)     NULL,
    [Localita]             NVARCHAR (100)   NULL,
    [Presso]               NVARCHAR (250)   NULL,
    [Latitudine]           DECIMAL (10, 8)  NULL,
    [Longitudine]          DECIMAL (11, 8)  NULL,
    [Piano]                NVARCHAR (20)    NULL,
    [Interno]              NVARCHAR (20)    NULL,
    [Edificio]             NVARCHAR (100)   NULL,
    [ZonaIndustriale]      NVARCHAR (150)   NULL,
    [DataInizio]           DATE             NOT NULL,
    [DataFine]             DATE             NULL,
    [Principale]           BIT              NOT NULL,
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

CREATE CLUSTERED INDEX [ix_IndirizzoUnitaOrganizzativaStorico]
    ON [Organizzazioni].[IndirizzoUnitaOrganizzativaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

