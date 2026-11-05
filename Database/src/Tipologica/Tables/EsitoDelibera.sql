CREATE TABLE [Tipologica].[EsitoDelibera] (
    [EsitoDeliberaId]    INT                                         IDENTITY (1, 1) NOT NULL,
    [Codice]             NVARCHAR (50)                               NOT NULL,
    [DescrizioneIta]     NVARCHAR (1000)                             NOT NULL,
    [DescrizioneEng]     NVARCHAR (1000)                             NULL,
    [Categoria]          NVARCHAR (30)                               NOT NULL,
    [FonteNormativa]     NVARCHAR (500)                              NULL,
    [Ordine]             INT                                         NULL,
    [Attivo]             BIT                                         CONSTRAINT [DF_EsitoDelibera_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]      DATETIME2 (7)                               CONSTRAINT [DF_EsitoDelibera_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]           INT                                         NULL,
    [DataModifica]       DATETIME2 (7)                               NULL,
    [ModificatoDa]       INT                                         NULL,
    [DataCancellazione]  DATETIME2 (7)                               NULL,
    [CancellatoDa]       INT                                         NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER                            CONSTRAINT [DF_EsitoDelibera_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_EsitoDelibera] PRIMARY KEY CLUSTERED ([EsitoDeliberaId] ASC),
    CONSTRAINT [UQ_EsitoDelibera_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Tipologica].[EsitoDeliberaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_EsitoDelibera_DataCancellazione]
    ON [Tipologica].[EsitoDelibera]([EsitoDeliberaId] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_EsitoDelibera_CreatoDa]
    ON [Tipologica].[EsitoDelibera]([CreatoDa] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:EsitoDelibera;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:EsitoDelibera;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:EsitoDelibera;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DescrizioneEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"EsitoDelibera","column":"FonteNormativa","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'FonteNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DescrizioneEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:EsitoDelibera;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'EsitoDeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"EsitoDelibera","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:EsitoDelibera;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"EsitoDelibera","column":"DescrizioneIta","data_type":"nvarchar","max_length":2000,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DescrizioneIta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"EsitoDelibera","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Categoria';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio del periodo di validita della versione di riga (colonna di periodo SYSTEM_TIME, generata dal motore).', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"EsitoDelibera","column":"DataInizioValidita","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":true,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Esiti nel merito di una deliberazione di organo collegiale. Sostituisce un CHECK con enum inline su Processi.Delibera.EsitoDelibera. La distinzione tra esito e stato e sostanziale: l''esito dice cosa ha deciso l''organo, lo stato dice a che punto e il ciclo di vita dell''atto. La categoria SFAVOREVOLE identifica le decisioni di accreditamento avverse, impugnabili davanti alla Commissione d''Appello entro trenta giorni dalla ricezione del provvedimento (RG-06 rev.05 art. 1).', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:EsitoDelibera;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'FonteNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"EsitoDelibera","column":"Codice","data_type":"nvarchar","max_length":100,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DescrizioneEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:EsitoDelibera;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DescrizioneIta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"EsitoDelibera","column":"Attivo","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"EsitoDelibera","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'EsitoDeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento puntuale al documento e all''articolo da cui discende la voce. Dichiara esplicitamente i casi in cui la voce e una classificazione operativa interna priva di base regolamentare.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'FonteNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Categoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:EsitoDelibera;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione in italiano della voce, con il riferimento regolamentare applicabile ove esistente.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DescrizioneIta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'EsitoDeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:EsitoDelibera;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"EsitoDelibera","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DescrizioneIta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"EsitoDelibera","column":"EsitoDeliberaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'EsitoDeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Raggruppamento funzionale della voce, usato per interrogazioni per classe anziche per singolo codice.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Categoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"EsitoDelibera","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'FonteNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:EsitoDelibera;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Categoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DescrizioneIta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice stabile della voce, usato come business key e nelle integrazioni. Immutabile una volta pubblicato.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"EsitoDelibera","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TIPOLOGICA', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:EsitoDelibera;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'FonteNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"EsitoDelibera","column":"Categoria","data_type":"nvarchar","max_length":60,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Categoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:EsitoDelibera;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DescrizioneEng';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se la voce e utilizzabile per nuove registrazioni. Le voci disattivate restano referenziabili dai record storici.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"EsitoDelibera","column":"DataFineValidita","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":true,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine del periodo di validita della versione di riga (colonna di periodo SYSTEM_TIME, generata dal motore).', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record, per riconciliazione tra sistemi distribuiti.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DescrizioneIta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'EsitoDeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"EsitoDelibera","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ordinamento di presentazione della voce nelle interfacce. Non ha significato normativo.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'FonteNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione in inglese della voce, per la reportistica verso EA, IAF e ILAC. Facoltativa.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DescrizioneEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:EsitoDelibera;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:EsitoDelibera;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:EsitoDelibera;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:EsitoDelibera;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Categoria';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"EsitoDelibera","column":"Ordine","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:EsitoDelibera;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogata della voce di tipologica. Identity, senza significato di business.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'EsitoDeliberaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"EsitoDelibera","column":"DescrizioneEng","data_type":"nvarchar","max_length":2000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'EsitoDelibera', @level2type = N'COLUMN', @level2name = N'DescrizioneEng';


GO

