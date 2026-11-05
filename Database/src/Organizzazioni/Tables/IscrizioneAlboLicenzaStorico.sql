CREATE TABLE [Organizzazioni].[IscrizioneAlboLicenzaStorico] (
    [IscrizioneAlboLicenzaId]  INT              NOT NULL,
    [OrganizzazioneId]         INT              NOT NULL,
    [SedeId]                   INT              NULL,
    [UnitaOrganizzativaId]     INT              NULL,
    [TipoIscrizione]           NVARCHAR (40)    NOT NULL,
    [EnteRilasciante]          NVARCHAR (200)   NOT NULL,
    [CodiceIscrizione]         NVARCHAR (100)   NOT NULL,
    [Descrizione]              NVARCHAR (500)   NULL,
    [StatoIscrizione]          NVARCHAR (20)    NOT NULL,
    [DataInizioValiditaTitolo] DATE             NULL,
    [DataFineValiditaTitolo]   DATE             NULL,
    [DataSospensione]          DATE             NULL,
    [DataRevoca]               DATE             NULL,
    [MotivoSospensioneRevoca]  NVARCHAR (1000)  NULL,
    [DocumentoId]              INT              NULL,
    [Fonte]                    NVARCHAR (60)    NOT NULL,
    [Note]                     NVARCHAR (1000)  NULL,
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

CREATE CLUSTERED INDEX [ix_IscrizioneAlboLicenzaStorico]
    ON [Organizzazioni].[IscrizioneAlboLicenzaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

