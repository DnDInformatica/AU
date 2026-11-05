CREATE TABLE [Eventi].[Evento] (
    [EventoId]               INT                                                IDENTITY (1, 1) NOT NULL,
    [TipoEventoId]           INT                                                NOT NULL,
    [Titolo]                 NVARCHAR (500)                                     NOT NULL,
    [Descrizione]            NVARCHAR (MAX)                                     NULL,
    [DipartimentoAccrediaId] INT                                                NULL,
    [OrganizzazioneId]       INT                                                NULL,
    [DataInizio]             DATETIME2 (7)                                      NOT NULL,
    [DataFine]               DATETIME2 (7)                                      NULL,
    [Luogo]                  NVARCHAR (500)                                     NULL,
    [ResponsabilePersonaId]  INT                                                NULL,
    [DataCreazione]          DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]               INT                                                NULL,
    [DataModifica]           DATETIME2 (7)                                      NULL,
    [ModificatoDa]           INT                                                NULL,
    [DataCancellazione]      DATETIME2 (7)                                      NULL,
    [CancellatoDa]           INT                                                NULL,
    [UniqueRowId]            UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]     DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [OrganoCollegialeId]     INT                                                NULL,
    [StatoEventoId]          INT                                                NOT NULL,
    [VisibilitaEventoId]     INT                                                NOT NULL,
    CONSTRAINT [PK_Evento] PRIMARY KEY CLUSTERED ([EventoId] ASC),
    CONSTRAINT [CK_Evento_Date] CHECK ([DataFine] IS NULL OR [DataFine]>=[DataInizio]),
    CONSTRAINT [FK_Evento_DipartimentoAccredia] FOREIGN KEY ([DipartimentoAccrediaId]) REFERENCES [Tipologica].[DipartimentoAccredia] ([DipartimentoAccrediaId]),
    CONSTRAINT [FK_Evento_Organizzazione] FOREIGN KEY ([OrganizzazioneId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId]),
    CONSTRAINT [FK_Evento_OrganoCollegiale] FOREIGN KEY ([OrganoCollegialeId]) REFERENCES [Organi].[OrganoCollegiale] ([OrganoCollegialeId]),
    CONSTRAINT [FK_Evento_ResponsabilePersona] FOREIGN KEY ([ResponsabilePersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [FK_Evento_StatoEvento] FOREIGN KEY ([StatoEventoId]) REFERENCES [Tipologica].[StatoEvento] ([StatoEventoId]),
    CONSTRAINT [FK_Evento_TipoEvento] FOREIGN KEY ([TipoEventoId]) REFERENCES [Eventi].[TipoEvento] ([TipoEventoId]),
    CONSTRAINT [FK_Evento_VisibilitaEvento] FOREIGN KEY ([VisibilitaEventoId]) REFERENCES [Tipologica].[VisibilitaEvento] ([VisibilitaEventoId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Eventi].[EventoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_Evento_OrganoCollegialeId]
    ON [Eventi].[Evento]([OrganoCollegialeId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Evento_StatoEventoId]
    ON [Eventi].[Evento]([StatoEventoId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Evento_VisibilitaEventoId]
    ON [Eventi].[Evento]([VisibilitaEventoId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Evento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'TipoEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Data di business da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Evento","column":"OrganizzazioneId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Organizzazioni.Organizzazione.OrganizzazioneId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Evento","column":"ResponsabilePersonaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'ResponsabilePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'TipoEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Evento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Evento;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'Luogo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Evento","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Evento","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Evento;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Titolo descrittivo da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Evento","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Evento","column":"DataInizio","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'Luogo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Evento","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Evento;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Evento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Evento","column":"TipoEventoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Eventi.TipoEvento.TipoEventoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'TipoEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione testuale da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'Luogo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Evento;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Evento;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'ResponsabilePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'eventi;riunioni;kernel', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Organo collegiale convocato per la seduta. FK verso Organi.OrganoCollegiale. NULL per gli eventi che non fanno capo a un organo, quali corsi, riunioni operative e gruppi di lavoro. E il collegamento che consente di confrontare i presenti alla seduta con la composizione dell''organo alla data e di derivare quindi numero legale e maggioranze.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'OrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Evento","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Evento","column":"EventoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Evento","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Evento generico per riunioni, sedute, corsi e incontri.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Evento","column":"Titolo","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Evento","column":"DataFine","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'Luogo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'ResponsabilePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Evento","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Evento;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Evento;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Evento;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'Luogo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Evento;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'TipoEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'ResponsabilePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Evento;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Evento;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Data di business da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Evento","column":"Luogo","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'Luogo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'ResponsabilePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'TipoEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'Titolo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Evento","column":"DipartimentoAccrediaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.DipartimentoAccredia.DipartimentoAccrediaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataInizio';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Identificatore di riferimento da completare.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Evento;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'ResponsabilePersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Evento","column":"Descrizione","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'TipoEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Evento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"Evento","temporal":true,"temporal_type":2,"history_table":"Eventi.EventoStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:Evento;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'Evento', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

