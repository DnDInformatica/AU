CREATE TABLE [Organizzazioni].[CapitaleSocialeStorico] (
    [CapitaleSocialeStoricoId] INT              NOT NULL,
    [OrganizzazioneId]         INT              NOT NULL,
    [DataRiferimento]          DATE             NOT NULL,
    [CapitaleDeliberato]       DECIMAL (19, 2)  NULL,
    [CapitaleSottoscritto]     DECIMAL (19, 2)  NULL,
    [CapitaleVersato]          DECIMAL (19, 2)  NULL,
    [Valuta]                   CHAR (3)         NOT NULL,
    [NumeroAzioni]             BIGINT           NULL,
    [ValoreNominaleAzione]     DECIMAL (19, 6)  NULL,
    [Fonte]                    NVARCHAR (60)    NOT NULL,
    [DocumentoId]              INT              NULL,
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

CREATE CLUSTERED INDEX [ix_CapitaleSocialeStorico]
    ON [Organizzazioni].[CapitaleSocialeStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

