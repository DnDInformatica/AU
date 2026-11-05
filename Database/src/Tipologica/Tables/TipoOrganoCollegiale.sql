CREATE TABLE [Tipologica].[TipoOrganoCollegiale] (
    [TipoOrganoCollegialeId]          INT                                         IDENTITY (1, 1) NOT NULL,
    [Codice]                          NVARCHAR (50)                               NOT NULL,
    [DescrizioneIta]                  NVARCHAR (1000)                             NOT NULL,
    [DescrizioneEng]                  NVARCHAR (1000)                             NULL,
    [Deliberante]                     BIT                                         CONSTRAINT [DF_TipoOrganoColl_Deliberante] DEFAULT ((0)) NOT NULL,
    [QuorumCostitutivoNum]            INT                                         NULL,
    [QuorumCostitutivoDen]            INT                                         NULL,
    [QuorumDeliberativoNum]           INT                                         NULL,
    [QuorumDeliberativoDen]           INT                                         NULL,
    [BaseCalcoloDeliberativo]         NVARCHAR (30)                               NULL,
    [AstensioneEquivaleVotoContrario] BIT                                         CONSTRAINT [DF_TipoOrganoColl_Astensione] DEFAULT ((0)) NOT NULL,
    [AmmetteDelega]                   BIT                                         CONSTRAINT [DF_TipoOrganoColl_AmmetteDelega] DEFAULT ((0)) NOT NULL,
    [AmmetteCooptazione]              BIT                                         CONSTRAINT [DF_TipoOrganoColl_AmmetteCooptazione] DEFAULT ((0)) NOT NULL,
    [DurataMandatoEsercizi]           INT                                         NULL,
    [FonteNormativa]                  NVARCHAR (500)                              NULL,
    [Ordine]                          INT                                         NULL,
    [Attivo]                          BIT                                         CONSTRAINT [DF_TipoOrganoColl_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                   DATETIME2 (7)                               CONSTRAINT [DF_TipoOrganoColl_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                        INT                                         NULL,
    [DataModifica]                    DATETIME2 (7)                               NULL,
    [ModificatoDa]                    INT                                         NULL,
    [DataCancellazione]               DATETIME2 (7)                               NULL,
    [CancellatoDa]                    INT                                         NULL,
    [UniqueRowId]                     UNIQUEIDENTIFIER                            CONSTRAINT [DF_TipoOrganoColl_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]              DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]                DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_TipoOrganoCollegiale] PRIMARY KEY CLUSTERED ([TipoOrganoCollegialeId] ASC),
    CONSTRAINT [CK_TipoOrganoColl_BaseCalcolo] CHECK ([BaseCalcoloDeliberativo] IS NULL OR ([BaseCalcoloDeliberativo]='COMPONENTI_IN_CARICA' OR [BaseCalcoloDeliberativo]='PRESENTI')),
    CONSTRAINT [CK_TipoOrganoColl_DeliberanteCompleto] CHECK ([Deliberante]=(0) OR [QuorumCostitutivoNum] IS NOT NULL AND [QuorumDeliberativoNum] IS NOT NULL AND [BaseCalcoloDeliberativo] IS NOT NULL),
    CONSTRAINT [CK_TipoOrganoColl_FrazioniValide] CHECK (([QuorumCostitutivoNum] IS NULL OR [QuorumCostitutivoDen]>(0) AND [QuorumCostitutivoNum]>(0) AND [QuorumCostitutivoNum]<=[QuorumCostitutivoDen]) AND ([QuorumDeliberativoNum] IS NULL OR [QuorumDeliberativoDen]>(0) AND [QuorumDeliberativoNum]>(0) AND [QuorumDeliberativoNum]<=[QuorumDeliberativoDen])),
    CONSTRAINT [UQ_TipoOrganoCollegiale_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Tipologica].[TipoOrganoCollegialeStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_TipoOrganoCollegiale_CreatoDa]
    ON [Tipologica].[TipoOrganoCollegiale]([CreatoDa] ASC);


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_TipoOrganoCollegiale_DataCancellazione]
    ON [Tipologica].[TipoOrganoCollegiale]([TipoOrganoCollegialeId] ASC) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumCostitutivoDen';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DescrizioneEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AmmetteCooptazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"QuorumCostitutivoDen","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumCostitutivoDen';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record, per riconciliazione tra sistemi distribuiti.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'FonteNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se le astensioni sono computate come voti negativi rispetto alla proposta. Vale 1 per la Commissione d''Appello (RG-06 art. 2). Si distingue dal regime della consultazione per e-mail del Comitato per l''Attivita di Accreditamento, dove astensioni e mancate risposte non vengono invece conteggiate ai fini del raggiungimento della maggioranza (RG-04 art. 3).', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AstensioneEquivaleVotoContrario';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Durata in esercizi del mandato dei Componenti. Vale 3 per i Componenti del Comitato di Accreditamento, che cessano unitamente agli altri in carica alla scadenza del mandato della consiliatura anche se nominati nel corso del triennio.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DurataMandatoEsercizi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AmmetteDelega';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DurataMandatoEsercizi';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se l''organo ammette la delega o la sostituzione dei Componenti nelle riunioni. Vale 0 per tutti gli organi deliberanti: RG-04 artt. 3 e 6 e RG-06 art. 2 escludono espressamente la delega. La possibilita di delega residua riguarda la sola funzione di Segretario ed e governata a livello di ruolo in Tipologica.TipoRuoloPartecipazioneEvento.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AmmetteDelega';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se l''organo puo cooptare sostituti temporanei. Previsto per la Commissione d''Appello in caso di conflitto di interesse o impedimento prolungato di un Componente: il sostituto resta in carica fino al completamento della trattazione della pratica e la nomina deve essere confermata dal Consiglio Direttivo.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AmmetteCooptazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DescrizioneIta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumDeliberativoDen';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Deliberante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"QuorumDeliberativoDen","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumDeliberativoDen';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumDeliberativoNum';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"TipoOrganoCollegialeId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'TipoOrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Deliberante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"QuorumDeliberativoNum","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumDeliberativoNum';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice stabile del tipo di organo, usato come business key. Immutabile una volta pubblicato.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"DataFineValidita","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":true,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"FonteNormativa","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'FonteNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"AmmetteDelega","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AmmetteDelega';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DurataMandatoEsercizi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AmmetteDelega';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"DurataMandatoEsercizi","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DurataMandatoEsercizi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AmmetteCooptazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumCostitutivoDen';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"AmmetteCooptazione","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AmmetteCooptazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"Codice","data_type":"nvarchar","max_length":100,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DescrizioneEng';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"Ordine","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumCostitutivoNum';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"AstensioneEquivaleVotoContrario","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AstensioneEquivaleVotoContrario';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'FonteNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"DataInizioValidita","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":true,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AstensioneEquivaleVotoContrario';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'BaseCalcoloDeliberativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione in italiano del tipo di organo, dei suoi compiti e del regime di funzionamento, con i riferimenti regolamentari applicabili.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DescrizioneIta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumCostitutivoNum';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"Attivo","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'TipoOrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"BaseCalcoloDeliberativo","data_type":"nvarchar","max_length":60,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'BaseCalcoloDeliberativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'TipoOrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumDeliberativoNum';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione in inglese del tipo di organo, per la reportistica verso EA, IAF e ILAC. Facoltativa.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DescrizioneEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumDeliberativoNum';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumCostitutivoDen';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TIPOLOGICA', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'BaseCalcoloDeliberativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DescrizioneIta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se l''organo assume deliberazioni sulle pratiche di accreditamento. Il Comitato di Indirizzo e Garanzia, ad esempio, esprime proposte e linee di indirizzo ma non delibera sulle pratiche. Il vincolo CK_TipoOrganoColl_DeliberanteCompleto impone che per gli organi deliberanti siano valorizzati entrambi i quorum e la base di calcolo.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Deliberante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumDeliberativoDen';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'TipoOrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumDeliberativoDen';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Deliberante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"DescrizioneIta","data_type":"nvarchar","max_length":2000,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DescrizioneIta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumCostitutivoDen';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AmmetteDelega';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DurataMandatoEsercizi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DurataMandatoEsercizi';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AmmetteCooptazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AmmetteCooptazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AstensioneEquivaleVotoContrario';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'FonteNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AmmetteDelega';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numeratore della frazione dei Componenti in carica necessaria a costituire validamente la riunione. Vale 1 su 2 per i Comitati e 3 su 5 per la Commissione d''Appello.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumCostitutivoNum';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine del periodo di validita della versione di riga (colonna di periodo SYSTEM_TIME, generata dal motore).', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'FonteNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"DescrizioneEng","data_type":"nvarchar","max_length":2000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DescrizioneEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumCostitutivoNum';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'BaseCalcoloDeliberativo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AstensioneEquivaleVotoContrario';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numeratore della frazione necessaria ad approvare una deliberazione. Vale 2 su 3 per i Comitati e 3 su 5 per la Commissione d''Appello.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumDeliberativoNum';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumDeliberativoNum';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"Deliberante","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Deliberante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DescrizioneIta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipi di organo collegiale di ACCREDIA, con i parametri normativi che ne governano il funzionamento deliberativo. Le regole non sono uniformi tra organi: i Comitati deliberano con i due terzi dei presenti su un quorum costitutivo di meta dei Componenti, mentre la Commissione d''Appello richiede i tre quinti dei Componenti in carica sia per la costituzione sia per la deliberazione e computa le astensioni come voti contrari. Parametrizzare queste differenze qui evita di cablarle nel codice applicativo. Fonti: RG-04 rev.06 artt. 3 e 6; RG-06 rev.05 artt. 1 e 2; ST-00 rev.06 artt. 18, 19, 21.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DescrizioneEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Denominatore della frazione del quorum costitutivo. La soglia si ottiene arrotondando all''intero superiore il prodotto tra la frazione e il numero dei Componenti in carica.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumCostitutivoDen';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogata. Identity, senza significato di business.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'TipoOrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insieme su cui si calcola la maggioranza deliberativa. PRESENTI: la frazione si applica ai soli presenti aventi diritto di voto, come per i Comitati, dove le decisioni sono valide se approvate da almeno i due terzi dei presenti. COMPONENTI_IN_CARICA: la frazione si applica alla totalita dei Componenti dell''organo indipendentemente dalla presenza, come per la Commissione d''Appello, dove le deliberazioni richiedono il voto favorevole di almeno i tre quinti dei Componenti della Commissione. Confondere le due basi produce delibere formalmente invalide.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'BaseCalcoloDeliberativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento puntuale al documento e all''articolo da cui discendono i parametri della riga. Dove un valore non e stato confermato sulla fonte primaria, la colonna lo dichiara esplicitamente.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'FonteNormativa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AstensioneEquivaleVotoContrario';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DescrizioneEng';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumCostitutivoNum';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"QuorumCostitutivoNum","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumCostitutivoNum';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ordinamento di presentazione della voce nelle interfacce. Non ha significato normativo.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'BaseCalcoloDeliberativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DescrizioneIta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Denominatore della frazione del quorum deliberativo. La base su cui applicare la frazione e indicata da BaseCalcoloDeliberativo e non e la stessa per tutti gli organi.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumDeliberativoDen';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"TipoOrganoCollegiale","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'TipoOrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio del periodo di validita della versione di riga (colonna di periodo SYSTEM_TIME, generata dal motore).', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Tipologica;Table:TipoOrganoCollegiale;NotNull', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Deliberante';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se la voce e utilizzabile per nuove registrazioni. Le voci disattivate restano referenziabili dai record storici.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoOrganoCollegiale', @level2type = N'COLUMN', @level2name = N'QuorumDeliberativoDen';


GO

