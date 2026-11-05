CREATE TABLE [Tipologica].[TipoPraticaProcesso] (
    [TipoPraticaProcessoId] INT                                         IDENTITY (1, 1) NOT NULL,
    [Codice]                NVARCHAR (50)                               NOT NULL,
    [DescrizioneIta]        NVARCHAR (500)                              NOT NULL,
    [DescrizioneEng]        NVARCHAR (500)                              NULL,
    [Specialistica]         BIT                                         DEFAULT ((0)) NOT NULL,
    [Attivo]                BIT                                         DEFAULT ((1)) NOT NULL,
    [DataCreazione]         DATETIME2 (7)                               DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]              INT                                         NULL,
    [DataModifica]          DATETIME2 (7)                               NULL,
    [ModificatoDa]          INT                                         NULL,
    [DataCancellazione]     DATETIME2 (7)                               NULL,
    [CancellatoDa]          INT                                         NULL,
    [UniqueRowId]           UNIQUEIDENTIFIER                            DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]    DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]      DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_TipoPraticaProcesso] PRIMARY KEY CLUSTERED ([TipoPraticaProcessoId] ASC),
    CONSTRAINT [UQ_TipoPraticaProcesso_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Tipologica].[TipoPraticaProcessoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_TipoPraticaProcesso_CreatoDa]
    ON [Tipologica].[TipoPraticaProcesso]([CreatoDa] ASC);


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_TipoPraticaProcesso_DataCancellazione]
    ON [Tipologica].[TipoPraticaProcesso]([TipoPraticaProcessoId] ASC) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoPraticaProcesso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoPraticaProcesso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoPraticaProcesso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TIPOLOGICA', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoPraticaProcesso';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipologia del fascicolo/pratica gestita nel kernel Processi.Pratica: distingue le pratiche specialistiche legate a una decisione di accreditamento (RG-01/RG-02) dalle pratiche trasversali non specialistiche di gestione CSA. Note terminologiche: (1) APPELLO = termine di glossario RG-01/RG-02 ("richiesta di riconsiderare qualsiasi decisione di accreditamento avversa"); "ricorso" è sinonimo informale nel testo dei regolamenti, non un istituto distinto. (2) VARIAZIONE (RG-02, modifica amministrativa non sanzionatoria: metodo, sedi, identità giuridica, o riduzione/autoriduzione volontaria di prove/sedi a richiesta del CAB) è concettualmente diversa da RIDUZIONE_SCOPO (provvedimento sanzionatorio imposto da ACCREDIA) pur usando parole simili nel testo normativo. (3) TRASFERIMENTO (accreditamento da un Ente estero EA/IAF/ILAC ad ACCREDIA) è diverso da TRASFERIMENTO_TITOLARITA (stesso accreditamento, cambio di soggetto giuridico per cessione/fusione con modifica CF/P.IVA). (4) RIPRISTINO (RG-02 §1.1: "concessione, sorveglianza, estensione, rinnovo, riduzione, autoriduzione, sospensione, autosospensione, ripristino, rinuncia e revoca") è la richiesta di cessazione di una sospensione/autosospensione con ritorno allo stato pienamente attivo.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoPraticaProcesso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoPraticaProcesso","temporal":true,"temporal_type":2,"history_table":"Tipologica.TipoPraticaProcessoStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoPraticaProcesso';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoPraticaProcesso';


GO

