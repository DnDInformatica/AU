CREATE TABLE [Organizzazioni].[PotereStorico] (
    [PotereId]                 INT              NOT NULL,
    [IncaricoId]               INT              NOT NULL,
    [TipoPotereId]             INT              NOT NULL,
    [DataInizio]               DATE             NOT NULL,
    [DataFine]                 DATE             NULL,
    [LimiteImportoSingolo]     DECIMAL (18, 2)  NULL,
    [LimiteImportoGiornaliero] DECIMAL (18, 2)  NULL,
    [LimiteImportoMensile]     DECIMAL (18, 2)  NULL,
    [LimiteImportoAnnuo]       DECIMAL (18, 2)  NULL,
    [Valuta]                   NVARCHAR (3)     NULL,
    [ModalitaFirma]            NVARCHAR (30)    NULL,
    [FirmaCongiuntaCon]        NVARCHAR (200)   NULL,
    [AmbitoTerritoriale]       NVARCHAR (100)   NULL,
    [AmbitoMateriale]          NVARCHAR (500)   NULL,
    [TipoOperazioniAmmesse]    NVARCHAR (500)   NULL,
    [PuoDelegare]              BIT              NOT NULL,
    [DelegatoDa]               INT              NULL,
    [StatoPotere]              NVARCHAR (20)    NOT NULL,
    [DataRevoca]               DATE             NULL,
    [MotivoRevoca]             NVARCHAR (500)   NULL,
    [ProtocolloCCIAA]          NVARCHAR (50)    NULL,
    [DataRegistrazioneCCIAA]   DATE             NULL,
    [NumeroRepertorioNotarile] NVARCHAR (50)    NULL,
    [Note]                     NVARCHAR (MAX)   NULL,
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

CREATE CLUSTERED INDEX [ix_PotereStorico]
    ON [Organizzazioni].[PotereStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

