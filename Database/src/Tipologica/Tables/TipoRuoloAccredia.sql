CREATE TABLE [Tipologica].[TipoRuoloAccredia] (
    [TipoRuoloAccrediaId] INT                                         IDENTITY (1, 1) NOT NULL,
    [Codice]              NVARCHAR (50)                               NOT NULL,
    [DescrizioneIta]      NVARCHAR (500)                              NOT NULL,
    [DescrizioneEng]      NVARCHAR (500)                              NULL,
    [Categoria]           NVARCHAR (30)                               NOT NULL,
    [Ordine]              INT                                         NULL,
    [Attivo]              BIT                                         DEFAULT ((1)) NOT NULL,
    [DataCreazione]       DATETIME2 (7)                               DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]            INT                                         NULL,
    [DataModifica]        DATETIME2 (7)                               NULL,
    [ModificatoDa]        INT                                         NULL,
    [DataCancellazione]   DATETIME2 (7)                               NULL,
    [CancellatoDa]        INT                                         NULL,
    [UniqueRowId]         UNIQUEIDENTIFIER                            DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]  DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]    DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_TipoRuoloAccredia] PRIMARY KEY CLUSTERED ([TipoRuoloAccrediaId] ASC),
    CONSTRAINT [CK_TipoRuoloAccredia_Categoria] CHECK ([Categoria]=N'DELIBERANTE' OR [Categoria]=N'VALUTATIVO' OR [Categoria]=N'ORGANIZZATIVO'),
    CONSTRAINT [UQ_TipoRuoloAccredia_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Tipologica].[TipoRuoloAccrediaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_TipoRuoloAccredia_DataCancellazione]
    ON [Tipologica].[TipoRuoloAccredia]([TipoRuoloAccrediaId] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_TipoRuoloAccredia_CreatoDa]
    ON [Tipologica].[TipoRuoloAccredia]([CreatoDa] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoRuoloAccredia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoRuoloAccredia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoRuoloAccredia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ruoli/organi interni ad ACCREDIA responsabili di uno step di workflow (Workflow.WorkflowStepDefinizione, Workflow.Task). Distinta da Tipologica.TipoRuolo (ruoli di governance del CAB/organizzazione accreditata: Amministratore, Direttore Generale del CAB, Responsabile Tecnico, ecc. - MAI usata per assegnare step di processo interni) e da Tipologica.TipoRuoloIspettore (dettaglio di competenza del singolo valutatore per la pianificazione delle verifiche, P2 - livello di granularità diverso e più specifico). Categoria: ORGANIZZATIVO (FT, Direzione Dipartimento, Segreteria Tecnica), VALUTATIVO (generico "assegnare a un valutatore", dettaglio in TipoRuoloIspettore), DELIBERANTE (organi che adottano delibere: CSA, Commissione d''Appello, Consiglio Direttivo).', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoRuoloAccredia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TIPOLOGICA', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoRuoloAccredia';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoRuoloAccredia';


GO

