CREATE TABLE [Persone].[RegistroTrattamentiStorico] (
    [RegistroTrattamentiId]      INT              NOT NULL,
    [Codice]                     NVARCHAR (30)    NOT NULL,
    [NomeTrattamento]            NVARCHAR (200)   NOT NULL,
    [Descrizione]                NVARCHAR (MAX)   NULL,
    [TipoFinalitaTrattamentoId]  INT              NOT NULL,
    [BaseGiuridica]              NVARCHAR (30)    NOT NULL,
    [CategorieDati]              NVARCHAR (500)   NOT NULL,
    [CategorieInteressati]       NVARCHAR (500)   NOT NULL,
    [DatiParticolari]            BIT              NOT NULL,
    [DatiGiudiziari]             BIT              NOT NULL,
    [CategorieDestinatari]       NVARCHAR (500)   NULL,
    [TrasferimentoExtraUE]       BIT              NOT NULL,
    [PaesiExtraUE]               NVARCHAR (200)   NULL,
    [GaranzieExtraUE]            NVARCHAR (200)   NULL,
    [TermineConservazione]       NVARCHAR (100)   NOT NULL,
    [TermineConservazioneGiorni] INT              NULL,
    [MisureSicurezza]            NVARCHAR (MAX)   NULL,
    [ResponsabileTrattamentoId]  INT              NULL,
    [ContitolareId]              INT              NULL,
    [DPONotificato]              BIT              NOT NULL,
    [Stato]                      NVARCHAR (20)    NOT NULL,
    [DataInizioTrattamento]      DATE             NOT NULL,
    [DataFineTrattamento]        DATE             NULL,
    [DataCreazione]              DATETIME2 (7)    NOT NULL,
    [CreatoDa]                   INT              NULL,
    [DataModifica]               DATETIME2 (7)    NULL,
    [ModificatoDa]               INT              NULL,
    [DataCancellazione]          DATETIME2 (7)    NULL,
    [CancellatoDa]               INT              NULL,
    [UniqueRowId]                UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]         DATETIME2 (7)    NOT NULL,
    [DataFineValidita]           DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_RegistroTrattamentiStorico]
    ON [Persone].[RegistroTrattamentiStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

