CREATE TABLE [Organi].[ComposizioneOrgano] (
    [ComposizioneOrganoId]            INT                                         IDENTITY (1, 1) NOT NULL,
    [OrganoCollegialeId]              INT                                         NOT NULL,
    [PersonaId]                       INT                                         NOT NULL,
    [TipoRuoloPartecipazioneEventoId] INT                                         NOT NULL,
    [DataInizioIncarico]              DATE                                        NOT NULL,
    [DataFineIncarico]                DATE                                        NULL,
    [AttoNomina]                      NVARCHAR (500)                              NULL,
    [Cooptato]                        BIT                                         CONSTRAINT [DF_ComposizioneOrgano_Cooptato] DEFAULT ((0)) NOT NULL,
    [CooptatoPerPuntoOdGId]           INT                                         NULL,
    [CodiceEticoSottoscritto]         BIT                                         CONSTRAINT [DF_ComposizioneOrgano_CodiceEtico] DEFAULT ((0)) NOT NULL,
    [DataSottoscrizioneCodiceEtico]   DATE                                        NULL,
    [Note]                            NVARCHAR (2000)                             NULL,
    [DataCreazione]                   DATETIME2 (7)                               CONSTRAINT [DF_ComposizioneOrgano_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                        INT                                         NULL,
    [DataModifica]                    DATETIME2 (7)                               NULL,
    [ModificatoDa]                    INT                                         NULL,
    [DataCancellazione]               DATETIME2 (7)                               NULL,
    [CancellatoDa]                    INT                                         NULL,
    [UniqueRowId]                     UNIQUEIDENTIFIER                            CONSTRAINT [DF_ComposizioneOrgano_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]              DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]                DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_ComposizioneOrgano] PRIMARY KEY CLUSTERED ([ComposizioneOrganoId] ASC),
    CONSTRAINT [CK_ComposizioneOrgano_CodiceEtico] CHECK ([CodiceEticoSottoscritto]=(0) OR [DataSottoscrizioneCodiceEtico] IS NOT NULL),
    CONSTRAINT [CK_ComposizioneOrgano_Cooptazione] CHECK ([Cooptato]=(1) OR [CooptatoPerPuntoOdGId] IS NULL),
    CONSTRAINT [CK_ComposizioneOrgano_Periodo] CHECK ([DataFineIncarico] IS NULL OR [DataFineIncarico]>=[DataInizioIncarico]),
    CONSTRAINT [CK_ComposizioneOrgano_RuoloAmmissibile] CHECK ([Organi].[fn_RuoloAmmissibileInOrgano]([TipoRuoloPartecipazioneEventoId])=(1)),
    CONSTRAINT [FK_ComposizioneOrgano_OrganoCollegiale] FOREIGN KEY ([OrganoCollegialeId]) REFERENCES [Organi].[OrganoCollegiale] ([OrganoCollegialeId]),
    CONSTRAINT [FK_ComposizioneOrgano_Persona] FOREIGN KEY ([PersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [FK_ComposizioneOrgano_PuntoOdG] FOREIGN KEY ([CooptatoPerPuntoOdGId]) REFERENCES [Eventi].[PuntoOdG] ([PuntoOdGId]),
    CONSTRAINT [FK_ComposizioneOrgano_TipoRuoloPartecipazioneEvento] FOREIGN KEY ([TipoRuoloPartecipazioneEventoId]) REFERENCES [Tipologica].[TipoRuoloPartecipazioneEvento] ([TipoRuoloPartecipazioneEventoId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Organi].[ComposizioneOrganoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ComposizioneOrgano_IncaricoAperto]
    ON [Organi].[ComposizioneOrgano]([OrganoCollegialeId] ASC, [PersonaId] ASC, [TipoRuoloPartecipazioneEventoId] ASC) WHERE ([DataFineIncarico] IS NULL AND [DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ComposizioneOrgano_PersonaId]
    ON [Organi].[ComposizioneOrgano]([PersonaId] ASC);


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_ComposizioneOrgano_DataCancellazione]
    ON [Organi].[ComposizioneOrgano]([ComposizioneOrganoId] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ComposizioneOrgano_OrganoCollegialeId]
    ON [Organi].[ComposizioneOrgano]([OrganoCollegialeId] ASC)
    INCLUDE([PersonaId], [TipoRuoloPartecipazioneEventoId], [DataInizioIncarico], [DataFineIncarico]);


GO

CREATE NONCLUSTERED INDEX [IX_ComposizioneOrgano_CreatoDa]
    ON [Organi].[ComposizioneOrgano]([CreatoDa] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'ComposizioneOrganoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica che il mandato deriva da cooptazione di un sostituto temporaneo anziche da nomina ordinaria. Previsto per la Commissione d''Appello in caso di conflitto di interesse o impedimento prolungato di un Componente in carica.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'Cooptato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'OrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'AttoNomina';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di decorrenza del mandato.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataInizioIncarico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CodiceEticoSottoscritto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataSottoscrizioneCodiceEtico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'TipoRuoloPartecipazioneEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;NotNull', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'Cooptato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;NotNull', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataInizioIncarico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"AttoNomina","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'AttoNomina';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CodiceEticoSottoscritto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"CodiceEticoSottoscritto","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CodiceEticoSottoscritto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Composizione storicizzata degli organi collegiali: registra chi siede in quale organo, con quale carica e per quale periodo. E il presupposto di ogni verifica automatica sul funzionamento degli organi: senza mandati datati non e possibile determinare il numero dei Componenti in carica a una certa data, ne quindi calcolare il quorum costitutivo, ne verificare le incompatibilita e i limiti di durata previsti da RG-04 rev.06 artt. 1 e 4. Supporta anche la cooptazione di sostituti temporanei prevista per la Commissione d''Appello da RG-06 rev.05 art. 2.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataSottoscrizioneCodiceEtico';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Annotazioni libere sul mandato, ad esempio le circostanze di una cessazione anticipata.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"TipoRuoloPartecipazioneEventoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.TipoRuoloPartecipazioneEvento.TipoRuoloPartecipazioneEventoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'TipoRuoloPartecipazioneEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"DataInizioValidita","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":true,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'OrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"CooptatoPerPuntoOdGId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Eventi.PuntoOdG.PuntoOdGId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CooptatoPerPuntoOdGId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'TipoRuoloPartecipazioneEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;NotNull', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'ComposizioneOrganoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'AttoNomina';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento all''atto di nomina. I Componenti dei Comitati e SottoComitati Settoriali sono designati dal Consiglio Direttivo, che ne valuta il possesso documentato dei requisiti di competenza ed esperienza.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'AttoNomina';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataFineIncarico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;NotNull', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CodiceEticoSottoscritto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"PersonaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'ComposizioneOrganoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'TipoRuoloPartecipazioneEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CooptatoPerPuntoOdGId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"ComposizioneOrganoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'ComposizioneOrganoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Organo in cui la persona ricopre la carica. FK verso Organi.OrganoCollegiale.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'OrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'AttoNomina';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataFineIncarico';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"DataFineIncarico","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataFineIncarico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CodiceEticoSottoscritto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di sottoscrizione del Codice Etico e di Condotta. Obbligatoria se CodiceEticoSottoscritto vale 1.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataSottoscrizioneCodiceEtico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogata del mandato. Identity, senza significato di business.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'ComposizioneOrganoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio del periodo di validita della versione di riga (colonna di periodo SYSTEM_TIME, generata dal motore).', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CooptatoPerPuntoOdGId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;NotNull', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;NotNull', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataSottoscrizioneCodiceEtico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"DataInizioIncarico","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataInizioIncarico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"Cooptato","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'Cooptato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataFineIncarico';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine del periodo di validita della versione di riga (colonna di periodo SYSTEM_TIME, generata dal motore).', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CooptatoPerPuntoOdGId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Carica ricoperta nell''organo. Riusa deliberatamente Tipologica.TipoRuoloPartecipazioneEvento anziche introdurre una tipologica parallela: gli attributi HaDirittoVoto, ConteggiatoNumeroLegale e AmmetteDelega governano allo stesso modo la carica nell''organo e la partecipazione alla singola seduta, e duplicarli comporterebbe il rischio di disallineamento. Il vincolo CK_ComposizioneOrgano_RuoloAmmissibile limita le cariche alle categorie DELIBERANTE e SUPPORTO, escludendo i ruoli meramente consultivi o formativi che non comportano appartenenza all''organo.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'TipoRuoloPartecipazioneEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;NotNull', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataInizioIncarico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica l''avvenuta sottoscrizione del Codice Etico e di Condotta di ACCREDIA, che tutti i Componenti del Comitato di Accreditamento devono accettare unitamente alla carica.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CodiceEticoSottoscritto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'Cooptato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"Note","data_type":"nvarchar","max_length":4000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataFineIncarico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;NotNull', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'ComposizioneOrganoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'AttoNomina';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ASSOCIAZIONE', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Punto all''ordine del giorno per la cui trattazione la cooptazione e stata disposta. Il sostituto cooptato resta in carica fino al completamento della trattazione della pratica su cui e stato impegnato, quindi il mandato e circoscritto a questo punto. Valorizzabile solo se Cooptato vale 1.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CooptatoPerPuntoOdGId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Persona titolare della carica. FK verso Persone.Persona.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'TipoRuoloPartecipazioneEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'OrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataSottoscrizioneCodiceEtico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'Cooptato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"DataFineValidita","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":true,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataInizioIncarico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record, per riconciliazione tra sistemi distribuiti.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'OrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:ComposizioneOrgano;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'CooptatoPerPuntoOdGId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"OrganoCollegialeId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Organi.OrganoCollegiale.OrganoCollegialeId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'OrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"ComposizioneOrgano","column":"DataSottoscrizioneCodiceEtico","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataSottoscrizioneCodiceEtico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataInizioIncarico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'Cooptato';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di cessazione del mandato. NULL se il mandato e in corso. L''indice UQ_ComposizioneOrgano_IncaricoAperto impedisce che una stessa persona abbia piu mandati aperti contemporaneamente sullo stesso organo con la stessa carica.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'ComposizioneOrgano', @level2type = N'COLUMN', @level2name = N'DataFineIncarico';


GO

