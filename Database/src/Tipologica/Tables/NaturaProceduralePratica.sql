CREATE TABLE [Tipologica].[NaturaProceduralePratica] (
    [NaturaProceduralePraticaId] INT                                         IDENTITY (1, 1) NOT NULL,
    [Codice]                     NVARCHAR (50)                               NOT NULL,
    [DescrizioneIta]             NVARCHAR (500)                              NOT NULL,
    [DescrizioneEng]             NVARCHAR (500)                              NULL,
    [Attivo]                     BIT                                         DEFAULT ((1)) NOT NULL,
    [DataCreazione]              DATETIME2 (7)                               DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                   INT                                         NULL,
    [DataModifica]               DATETIME2 (7)                               NULL,
    [ModificatoDa]               INT                                         NULL,
    [DataCancellazione]          DATETIME2 (7)                               NULL,
    [CancellatoDa]               INT                                         NULL,
    [UniqueRowId]                UNIQUEIDENTIFIER                            DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]         DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]           DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_NaturaProceduralePratica] PRIMARY KEY CLUSTERED ([NaturaProceduralePraticaId] ASC),
    CONSTRAINT [UQ_NaturaProceduralePratica_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Tipologica].[NaturaProceduralePraticaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_NaturaProceduralePratica_DataCancellazione]
    ON [Tipologica].[NaturaProceduralePratica]([NaturaProceduralePraticaId] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_NaturaProceduralePratica_CreatoDa]
    ON [Tipologica].[NaturaProceduralePratica]([CreatoDa] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"NaturaProceduralePratica","temporal":true,"temporal_type":2,"history_table":"Tipologica.NaturaProceduralePraticaStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'NaturaProceduralePratica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'NaturaProceduralePratica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'NaturaProceduralePratica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'NaturaProceduralePratica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'NaturaProceduralePratica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TIPOLOGICA', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'NaturaProceduralePratica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Natura procedurale del fascicolo Processi.Pratica: forma che assume il workflow indipendentemente dal legame con una decisione di accreditamento (asse ortogonale a Tipologica.TipoPraticaProcesso). Valori storici del kernel: pratica generica, istruttoria pura, pratica che produce una delibera, questione organizzativa CSA.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'NaturaProceduralePratica';


GO

