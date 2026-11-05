CREATE TABLE [Organizzazioni].[OrganizzazioneStorico] (
    [OrganizzazioneId]            INT              NOT NULL,
    [RagioneSociale]              NVARCHAR (550)   NOT NULL,
    [Denominazione]               NVARCHAR (550)   NOT NULL,
    [PartitaIVA]                  NVARCHAR (11)    NULL,
    [CodiceFiscale]               NVARCHAR (16)    NULL,
    [NRegistroImprese]            NVARCHAR (21)    NULL,
    [TipoCodiceNaturaGiuridicaID] INT              NULL,
    [StatoAttivitaId]             TINYINT          NULL,
    [OggettoSociale]              NVARCHAR (1000)  NULL,
    [DataIscrizioneIscrizioneRI]  DATETIME2 (7)    NULL,
    [DataCostituzione]            DATETIME2 (7)    NULL,
    [TipoOrganizzazioneId]        INT              NULL,
    [DataCreazione]               DATETIME2 (7)    NOT NULL,
    [CreatoDa]                    INT              NULL,
    [DataModifica]                DATETIME2 (7)    NULL,
    [ModificatoDa]                INT              NULL,
    [DataCancellazione]           DATETIME2 (7)    NULL,
    [CancellatoDa]                INT              NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER NOT NULL,
    [CodOrganizzazione]           NVARCHAR (20)    NULL,
    [DataInizioValidita]          DATETIME2 (7)    NOT NULL,
    [DataFineValidita]            DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_OrganizzazioneStorico]
    ON [Organizzazioni].[OrganizzazioneStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

