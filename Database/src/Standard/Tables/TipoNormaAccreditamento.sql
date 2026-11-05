CREATE TABLE [Standard].[TipoNormaAccreditamento] (
    [TipoNormaAccreditamentoId] INT                                                IDENTITY (1, 1) NOT NULL,
    [Codice]                    NVARCHAR (30)                                      NOT NULL,
    [Descrizione]               NVARCHAR (300)                                     NOT NULL,
    [Attivo]                    BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]             DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                  INT                                                NULL,
    [DataModifica]              DATETIME2 (7)                                      NULL,
    [ModificatoDa]              INT                                                NULL,
    [DataCancellazione]         DATETIME2 (7)                                      NULL,
    [CancellatoDa]              INT                                                NULL,
    [UniqueRowId]               UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]        DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]          DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_TipoNormaAccreditamento] PRIMARY KEY CLUSTERED ([TipoNormaAccreditamentoId] ASC),
    CONSTRAINT [CK_TipoNormaAccreditamento_Codice] CHECK (len(ltrim(rtrim([Codice])))>(0)),
    CONSTRAINT [CK_TipoNormaAccreditamento_Descrizione] CHECK (len(ltrim(rtrim([Descrizione])))>(0)),
    CONSTRAINT [UQ_TipoNormaAccreditamento_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[TipoNormaAccreditamentoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoNormaAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoNormaAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoNormaAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione del ruolo normativo. Questa tipologia serve a impedire confusione fra norma di accreditamento dell''ODC e norma/schema della certificazione rilasciata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoNormaAccreditamento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice del ruolo normativo. Esempi: AccreditamentoOdC per norme di accreditamento CAB; SchemaCertificazione per norme/schemi certificabili; Duplice per norme con duplice ruolo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoNormaAccreditamento', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Lookup dei ruoli/tipologie delle norme nel sistema Accredia.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoNormaAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata della tipologia di ruolo normativo nel Modello B.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'TipoNormaAccreditamento', @level2type = N'COLUMN', @level2name = N'TipoNormaAccreditamentoId';


GO

