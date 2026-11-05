CREATE TABLE [RisorseUmane].[DipendenteStorico] (
    [DipendenteId]               INT              NOT NULL,
    [PersonaId]                  INT              NOT NULL,
    [Matricola]                  NVARCHAR (20)    NOT NULL,
    [EmailAziendale]             NVARCHAR (100)   NULL,
    [TelefonoInterno]            NVARCHAR (10)    NULL,
    [UnitaOrganizzativaId]       INT              NULL,
    [ResponsabileDirettoId]      INT              NULL,
    [DataAssunzione]             DATE             NOT NULL,
    [DataCessazione]             DATE             NULL,
    [StatoDipendenteId]          INT              NOT NULL,
    [AbilitatoAttivitaIspettiva] BIT              NOT NULL,
    [Note]                       NVARCHAR (MAX)   NULL,
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

CREATE CLUSTERED INDEX [ix_DipendenteStorico]
    ON [RisorseUmane].[DipendenteStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

