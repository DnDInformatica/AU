CREATE TABLE [Organizzazioni].[OrganizzazioneSedeStorico] (
    [OrganizzazioneSedeId]     INT              NOT NULL,
    [OrganizzazioneId]         INT              NOT NULL,
    [Progressivo]              SMALLINT         NULL,
    [NIscrizioneREA]           NVARCHAR (9)     NULL,
    [SiglaProvinciaREA]        NVARCHAR (2)     NULL,
    [DataIscrizioneREA]        DATETIME2 (7)    NULL,
    [TipoOrganizzazioneSedeId] TINYINT          NOT NULL,
    [Denominazione]            NVARCHAR (500)   NULL,
    [Insegna]                  NVARCHAR (50)    NULL,
    [DataApertura]             DATE             NULL,
    [CodiceStatoAttivitaId]    NVARCHAR (1)     NULL,
    [DescrizioneAttivita]      NVARCHAR (500)   NULL,
    [DataInizioAttivita]       DATE             NULL,
    [CodiceAttivitaISTAT]      NVARCHAR (6)     NULL,
    [CodiceCausaleCessazione]  NVARCHAR (8)     NULL,
    [DataCessazioneUL]         DATE             NULL,
    [DataDenunciaCessazione]   DATE             NULL,
    [IndirizzoID]              BIGINT           NULL,
    [DataCreazione]            DATETIME2 (7)    NOT NULL,
    [CreatoDa]                 INT              NULL,
    [DataModifica]             DATETIME2 (7)    NULL,
    [ModificatoDa]             INT              NULL,
    [DataCancellazione]        DATETIME2 (7)    NULL,
    [CancellatoDa]             INT              NULL,
    [UniqueRowId]              UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]       DATETIME2 (7)    NOT NULL,
    [DataFineValidita]         DATETIME2 (7)    NOT NULL,
    [SedeCanonicaId]           INT              NULL,
    [StatoRiconciliazione]     NVARCHAR (40)    NULL,
    [MetodoRiconciliazione]    NVARCHAR (120)   NULL,
    [DataRiconciliazione]      DATETIME2 (7)    NULL,
    [NoteRiconciliazione]      NVARCHAR (2000)  NULL
);


GO

CREATE CLUSTERED INDEX [ix_OrganizzazioneSedeStorico]
    ON [Organizzazioni].[OrganizzazioneSedeStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

