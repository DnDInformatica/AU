CREATE TABLE [Processi].[PraticaScadenzaStorico] (
    [PraticaScadenzaId]       INT              NOT NULL,
    [PraticaId]               INT              NULL,
    [DataScadenza]            DATETIME2 (7)    NOT NULL,
    [IsBloccante]             BIT              NOT NULL,
    [Note]                    NVARCHAR (2000)  NULL,
    [DataCreazione]           DATETIME2 (7)    NOT NULL,
    [CreatoDa]                INT              NULL,
    [DataModifica]            DATETIME2 (7)    NULL,
    [ModificatoDa]            INT              NULL,
    [DataCancellazione]       DATETIME2 (7)    NULL,
    [CancellatoDa]            INT              NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]      DATETIME2 (7)    NOT NULL,
    [DataFineValidita]        DATETIME2 (7)    NOT NULL,
    [PraticaAccreditamentoId] INT              NULL,
    [StatoScadenzaPraticaId]  INT              NOT NULL,
    [TipoScadenzaPraticaId]   INT              NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_PraticaScadenzaStorico]
    ON [Processi].[PraticaScadenzaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

