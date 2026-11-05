CREATE TABLE [RisorseUmane].[ContrattoStorico] (
    [ContrattoId]          INT              NOT NULL,
    [DipendenteId]         INT              NOT NULL,
    [TipoContrattoId]      INT              NOT NULL,
    [DataInizio]           DATE             NOT NULL,
    [DataFine]             DATE             NULL,
    [LivelloInquadramento] NVARCHAR (20)    NULL,
    [CCNLApplicato]        NVARCHAR (100)   NULL,
    [RAL]                  DECIMAL (12, 2)  NULL,
    [PercentualePartTime]  DECIMAL (5, 2)   NULL,
    [OreLavoroSettimanali] DECIMAL (5, 2)   NULL,
    [IsContrattoCorrente]  BIT              NOT NULL,
    [Note]                 NVARCHAR (MAX)   NULL,
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

CREATE CLUSTERED INDEX [ix_ContrattoStorico]
    ON [RisorseUmane].[ContrattoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

