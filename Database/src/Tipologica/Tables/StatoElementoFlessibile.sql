CREATE TABLE [Tipologica].[StatoElementoFlessibile] (
    [StatoElementoFlessibileId] TINYINT                                            NOT NULL,
    [Codice]                    NVARCHAR (40)                                      NOT NULL,
    [Descrizione]               NVARCHAR (400)                                     NOT NULL,
    [Attivo]                    BIT                                                CONSTRAINT [DF_StatoElementoFlex_Attivo] DEFAULT ((1)) NOT NULL,
    [UniqueRowId]               UNIQUEIDENTIFIER                                   CONSTRAINT [DF_StatoElementoFlex_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataCreazione]             DATETIME2 (7)                                      CONSTRAINT [DF_StatoElementoFlex_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                  INT                                                NULL,
    [DataModifica]              DATETIME2 (7)                                      NULL,
    [ModificatoDa]              INT                                                NULL,
    [DataCancellazione]         DATETIME2 (7)                                      NULL,
    [CancellatoDa]              INT                                                NULL,
    [DataInizioValidita]        DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]          DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_StatoElementoFlessibile] PRIMARY KEY CLUSTERED ([StatoElementoFlessibileId] ASC),
    CONSTRAINT [UQ_StatoElementoFlessibile_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Tipologica].[StatoElementoFlessibileStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipologica degli stati di un elemento dell''Elenco controllato dello scopo flessibile gestito dal CAB.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'StatoElementoFlessibile';


GO

