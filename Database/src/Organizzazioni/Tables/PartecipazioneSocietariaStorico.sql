CREATE TABLE [Organizzazioni].[PartecipazioneSocietariaStorico] (
    [PartecipazioneSocietariaId]   INT              NOT NULL,
    [AssettoProprietarioId]        INT              NOT NULL,
    [TitolareTipo]                 NVARCHAR (20)    NOT NULL,
    [OrganizzazioneTitolareId]     INT              NULL,
    [PersonaTitolareId]            INT              NULL,
    [DenominazioneTitolareRaw]     NVARCHAR (300)   NULL,
    [CodiceFiscaleTitolareRaw]     NVARCHAR (20)    NULL,
    [TipoDiritto]                  NVARCHAR (30)    NOT NULL,
    [PercentualePartecipazione]    DECIMAL (9, 6)   NULL,
    [NumeroAzioni]                 BIGINT           NULL,
    [ValoreNominalePartecipazione] DECIMAL (19, 2)  NULL,
    [DirittiVotoPercentuale]       DECIMAL (9, 6)   NULL,
    [DataInizio]                   DATE             NULL,
    [DataFine]                     DATE             NULL,
    [Note]                         NVARCHAR (1000)  NULL,
    [DataCreazione]                DATETIME2 (7)    NOT NULL,
    [CreatoDa]                     INT              NULL,
    [DataModifica]                 DATETIME2 (7)    NULL,
    [ModificatoDa]                 INT              NULL,
    [DataCancellazione]            DATETIME2 (7)    NULL,
    [CancellatoDa]                 INT              NULL,
    [UniqueRowId]                  UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]           DATETIME2 (7)    NOT NULL,
    [DataFineValidita]             DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_PartecipazioneSocietariaStorico]
    ON [Organizzazioni].[PartecipazioneSocietariaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

