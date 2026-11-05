CREATE TABLE [Organizzazioni].[SedeStorico] (
    [SedeId]              INT              NOT NULL,
    [OrganizzazioneId]    INT              NOT NULL,
    [TipoSedeId]          INT              NOT NULL,
    [CodiceSede]          NVARCHAR (50)    NULL,
    [Denominazione]       NVARCHAR (500)   NULL,
    [Insegna]             NVARCHAR (100)   NULL,
    [NIscrizioneREA]      NVARCHAR (11)    NULL,
    [SiglaProvinciaREA]   NVARCHAR (2)     NULL,
    [DataIscrizioneREA]   DATE             NULL,
    [Indirizzo]           NVARCHAR (250)   NOT NULL,
    [NumeroCivico]        NVARCHAR (20)    NULL,
    [CAP]                 NVARCHAR (10)    NULL,
    [Localita]            NVARCHAR (150)   NULL,
    [Provincia]           NVARCHAR (50)    NULL,
    [ComuneId]            INT              NULL,
    [Nazione]             NVARCHAR (100)   NULL,
    [Latitudine]          DECIMAL (10, 8)  NULL,
    [Longitudine]         DECIMAL (11, 8)  NULL,
    [Piano]               NVARCHAR (20)    NULL,
    [Interno]             NVARCHAR (20)    NULL,
    [Edificio]            NVARCHAR (100)   NULL,
    [ZonaIndustriale]     NVARCHAR (150)   NULL,
    [Presso]              NVARCHAR (250)   NULL,
    [StatoSede]           NVARCHAR (20)    NOT NULL,
    [DataApertura]        DATE             NULL,
    [DataCessazione]      DATE             NULL,
    [MotivoCessazione]    NVARCHAR (500)   NULL,
    [CodiceATECO]         NVARCHAR (10)    NULL,
    [DescrizioneAttivita] NVARCHAR (500)   NULL,
    [DataInizioAttivita]  DATE             NULL,
    [IsSedePrincipale]    BIT              NOT NULL,
    [IsSedeOperativa]     BIT              NOT NULL,
    [DataCreazione]       DATETIME2 (7)    NOT NULL,
    [CreatoDa]            INT              NULL,
    [DataModifica]        DATETIME2 (7)    NULL,
    [ModificatoDa]        INT              NULL,
    [DataCancellazione]   DATETIME2 (7)    NULL,
    [CancellatoDa]        INT              NULL,
    [UniqueRowId]         UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]  DATETIME2 (7)    NOT NULL,
    [DataFineValidita]    DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_SedeStorico]
    ON [Organizzazioni].[SedeStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

