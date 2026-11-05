CREATE TABLE [Organizzazioni].[IncaricoIncompatibilitaStorico] (
    [IncaricoIncompatibilitaId]   INT              NOT NULL,
    [IncaricoId]                  INT              NOT NULL,
    [OrganizzazioneControparteId] INT              NOT NULL,
    [TipoIncompatibilitaId]       INT              NOT NULL,
    [DipartimentoAccrediaId]      INT              NULL,
    [RuoloSorgente]               NVARCHAR (200)   NULL,
    [PosizioneOrganizzativa]      NVARCHAR (300)   NULL,
    [RelazioneConEnte]            NVARCHAR (200)   NULL,
    [DataInizio]                  DATE             NOT NULL,
    [DataFine]                    DATE             NULL,
    [Fonte]                       NVARCHAR (100)   NULL,
    [RiferimentoOrigine]          NVARCHAR (100)   NULL,
    [Note]                        NVARCHAR (2000)  NULL,
    [DerogaConcessa]              BIT              NOT NULL,
    [DataDeroga]                  DATE             NULL,
    [DataCreazione]               DATETIME2 (7)    NOT NULL,
    [CreatoDa]                    INT              NULL,
    [DataModifica]                DATETIME2 (7)    NULL,
    [ModificatoDa]                INT              NULL,
    [DataCancellazione]           DATETIME2 (7)    NULL,
    [CancellatoDa]                INT              NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER NOT NULL,
    [PersonaId]                   INT              NOT NULL,
    [DataInizioValidita]          DATETIME2 (7)    NOT NULL,
    [DataFineValidita]            DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_IncaricoIncompatibilitaStorico]
    ON [Organizzazioni].[IncaricoIncompatibilitaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

