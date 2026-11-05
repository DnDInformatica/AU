CREATE TABLE [Tipologica].[TipoScopoAccreditamento] (
    [TipoScopoAccreditamentoId] TINYINT                                            NOT NULL,
    [Codice]                    NVARCHAR (40)                                      NOT NULL,
    [Descrizione]               NVARCHAR (400)                                     NOT NULL,
    [Attivo]                    BIT                                                CONSTRAINT [DF_TipoScopoAccr_Attivo] DEFAULT ((1)) NOT NULL,
    [UniqueRowId]               UNIQUEIDENTIFIER                                   CONSTRAINT [DF_TipoScopoAccr_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataCreazione]             DATETIME2 (7)                                      CONSTRAINT [DF_TipoScopoAccr_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                  INT                                                NULL,
    [DataModifica]              DATETIME2 (7)                                      NULL,
    [ModificatoDa]              INT                                                NULL,
    [DataCancellazione]         DATETIME2 (7)                                      NULL,
    [CancellatoDa]              INT                                                NULL,
    [DataInizioValidita]        DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]          DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_TipoScopoAccreditamento] PRIMARY KEY CLUSTERED ([TipoScopoAccreditamentoId] ASC),
    CONSTRAINT [UQ_TipoScopoAccreditamento_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Tipologica].[TipoScopoAccreditamentoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipologica dei tipi di scopo di accreditamento (Fisso, Flessibile, Misto) ai sensi di ISO/IEC 17011, RT-37 e RT-26 ACCREDIA.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoScopoAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo univoco del tipo di scopo di accreditamento.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoScopoAccreditamento', @level2type = N'COLUMN', @level2name = N'TipoScopoAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice mnemonico del tipo di scopo (FIS, FLE, MIS).', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoScopoAccreditamento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione estesa del tipo di scopo di accreditamento.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoScopoAccreditamento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

