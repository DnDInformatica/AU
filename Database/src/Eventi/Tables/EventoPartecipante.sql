CREATE TABLE [Eventi].[EventoPartecipante] (
    [EventoPartecipanteId]            INT                                                IDENTITY (1, 1) NOT NULL,
    [EventoId]                        INT                                                NOT NULL,
    [PersonaId]                       INT                                                NOT NULL,
    [Presente]                        BIT                                                NULL,
    [DelegatoDaPersonaId]             INT                                                NULL,
    [DataInvito]                      DATETIME2 (7)                                      NULL,
    [DataRisposta]                    DATETIME2 (7)                                      NULL,
    [Note]                            NVARCHAR (1000)                                    NULL,
    [DataCreazione]                   DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                        INT                                                NULL,
    [DataModifica]                    DATETIME2 (7)                                      NULL,
    [ModificatoDa]                    INT                                                NULL,
    [DataCancellazione]               DATETIME2 (7)                                      NULL,
    [CancellatoDa]                    INT                                                NULL,
    [UniqueRowId]                     UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]              DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]                DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [TipoRuoloPartecipazioneEventoId] INT                                                NOT NULL,
    [StatoInvitoEventoId]             INT                                                NOT NULL,
    CONSTRAINT [PK_EventoPartecipante] PRIMARY KEY CLUSTERED ([EventoPartecipanteId] ASC),
    CONSTRAINT [CK_EventoPartecipante_DelegaAmmessaDalRuolo] CHECK ([DelegatoDaPersonaId] IS NULL OR [Eventi].[fn_RuoloPartecipazioneAmmetteDelega]([TipoRuoloPartecipazioneEventoId])=(1)),
    CONSTRAINT [CK_EventoPartecipante_DelegaNonAutoreferenziale] CHECK ([DelegatoDaPersonaId] IS NULL OR [DelegatoDaPersonaId]<>[PersonaId]),
    CONSTRAINT [CK_EventoPartecipante_Risposta] CHECK ([DataRisposta] IS NULL OR [DataInvito] IS NULL OR [DataRisposta]>=[DataInvito]),
    CONSTRAINT [FK_EventoPartecipante_DelegatoDaPersona] FOREIGN KEY ([DelegatoDaPersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [FK_EventoPartecipante_Evento] FOREIGN KEY ([EventoId]) REFERENCES [Eventi].[Evento] ([EventoId]),
    CONSTRAINT [FK_EventoPartecipante_Persona] FOREIGN KEY ([PersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [FK_EventoPartecipante_StatoInvitoEvento] FOREIGN KEY ([StatoInvitoEventoId]) REFERENCES [Tipologica].[StatoInvitoEvento] ([StatoInvitoEventoId]),
    CONSTRAINT [FK_EventoPartecipante_TipoRuoloPartecipazioneEvento] FOREIGN KEY ([TipoRuoloPartecipazioneEventoId]) REFERENCES [Tipologica].[TipoRuoloPartecipazioneEvento] ([TipoRuoloPartecipazioneEventoId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Eventi].[EventoPartecipanteStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_EventoPartecipante]
    ON [Eventi].[EventoPartecipante]([EventoId] ASC, [PersonaId] ASC, [TipoRuoloPartecipazioneEventoId] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_EventoPartecipante_TipoRuoloPartecipazioneEventoId]
    ON [Eventi].[EventoPartecipante]([TipoRuoloPartecipazioneEventoId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_EventoPartecipante_StatoInvitoEventoId]
    ON [Eventi].[EventoPartecipante]([StatoInvitoEventoId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Partecipanti a un evento (seduta di organo collegiale, riunione, corso, gruppo di lavoro). Associa una Persona a un Evento con un ruolo di partecipazione tipizzato e lo stato di gestione dell''invito. Per gli eventi deliberanti e la tabella da cui si determinano il numero legale e la base di calcolo delle maggioranze: la riunione e validamente costituita con almeno la meta dei Componenti e le decisioni sono valide se approvate da almeno i due terzi dei presenti (RG-04 rev.06 artt. 3 e 6).', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"EventoPartecipante","temporal":true,"temporal_type":2,"history_table":"Eventi.EventoPartecipanteStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:EventoPartecipante;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'EventoPartecipanteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:EventoPartecipante;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DelegatoDaPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"EventoPartecipante","column":"DataInvito","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataInvito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"EventoPartecipante","column":"Note","data_type":"nvarchar","max_length":2000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"EventoPartecipante","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:EventoPartecipante;FK;NotNull;Tipologica', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'TipoRuoloPartecipazioneEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:EventoPartecipante;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataInvito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento all''evento a cui la persona partecipa. FK verso Eventi.Evento.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"EventoPartecipante","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:EventoPartecipante;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'Presente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'StatoInvitoEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'StatoInvitoEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"EventoPartecipante","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'TipoRuoloPartecipazioneEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'EventoPartecipanteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"EventoPartecipante","column":"EventoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Eventi.Evento.EventoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC della risposta del partecipante all''invito. Vincolata a non precedere DataInvito da CK_EventoPartecipante_Risposta.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Persona che ha conferito delega al partecipante, quando questi interviene in vece altrui. FK verso Persone.Persona. Valorizzabile solo per i ruoli con AmmetteDelega pari a 1, vincolo applicato da CK_EventoPartecipante_DelegaAmmessaDalRuolo: i regolamenti escludono la delega per i Componenti degli organi deliberanti e la ammettono unicamente per la funzione di Segretario, delegabile a Personale del Dipartimento (RG-04 rev.06 artt. 3 e 6).', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DelegatoDaPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:EventoPartecipante;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataInvito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:EventoPartecipante;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento anagrafico della persona che partecipa. FK verso Persone.Persona. Il ruolo istituzionale della persona non e desumibile da questa colonna: e espresso da TipoRuoloPartecipazioneEventoId e vale per il singolo evento.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stato di gestione dell''invito. FK verso Tipologica.StatoInvitoEvento. Sostituisce la precedente colonna testuale StatoInvito, vincolata da un CHECK con enum inline (DA_INVIARE, INVIATO, ACCETTATO, RIFIUTATO, ANNULLATO). Descrive il ciclo dell''invito, non la presenza effettiva, che e registrata in Presente.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'StatoInvitoEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"EventoPartecipante","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"EventoPartecipante","column":"Presente","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'Presente';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ASSOCIAZIONE', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'TipoRuoloPartecipazioneEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:EventoPartecipante;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DelegatoDaPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'Presente';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ruolo con cui la persona partecipa allo specifico evento. FK verso Tipologica.TipoRuoloPartecipazioneEvento, che porta gli attributi normativi HaDirittoVoto, ConteggiatoNumeroLegale e AmmetteDelega. Sostituisce la precedente colonna testuale RuoloPartecipazione, vincolata da un CHECK con enum inline (PRESIDENTE, MEMBRO, SEGRETARIO, ESPERTO_ESTERNO, INVITATO_SENZA_VOTO). La stessa persona puo comparire piu volte sullo stesso evento con ruoli diversi.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'TipoRuoloPartecipazioneEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataInvito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:EventoPartecipante;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"EventoPartecipante","column":"DelegatoDaPersonaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DelegatoDaPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"EventoPartecipante","column":"DataRisposta","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:EventoPartecipante;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:EventoPartecipante;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'Presente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"EventoPartecipante","column":"StatoInvitoEventoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.StatoInvitoEvento.StatoInvitoEventoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'StatoInvitoEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:EventoPartecipante;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"EventoPartecipante","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DelegatoDaPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'EventoPartecipanteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:EventoPartecipante;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogata della partecipazione. Identity, senza significato di business.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'EventoPartecipanteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Annotazioni libere sulla partecipazione, ad esempio la motivazione di un''assenza giustificata o i limiti di intervento di un partecipante ammesso per i soli specifici aspetti di consultazione.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Presenza effettiva alla riunione, rilevata in sede di evento e distinta dall''adesione dichiarata in StatoInvitoEventoId. NULL finche la presenza non e stata rilevata. Nelle sedute in videoconferenza o in modalita mista la verifica delle presenze avviene per mezzo di videocamera o nei modi consentiti dalla Legge (RG-04 rev.06 artt. 3 e 6). E il campo su cui si calcola il numero legale, in combinazione con ConteggiatoNumeroLegale della tipologica di ruolo.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'Presente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:EventoPartecipante;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"EventoPartecipante","column":"TipoRuoloPartecipazioneEventoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.TipoRuoloPartecipazioneEvento.TipoRuoloPartecipazioneEventoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'TipoRuoloPartecipazioneEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC di trasmissione dell''invito e dell''avviso di convocazione. La documentazione a supporto dei punti iscritti all''Ordine del Giorno viene resa disponibile di norma almeno 7 giorni solari prima della riunione (RG-04 rev.06 artt. 3 e 5).', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataInvito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:EventoPartecipante;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'StatoInvitoEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"EventoPartecipante","column":"EventoPartecipanteId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'EventoPartecipanteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:EventoPartecipante;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DelegatoDaPersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record, per riconciliazione tra sistemi distribuiti.', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'EventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataInvito';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'TipoRuoloPartecipazioneEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"EventoPartecipante","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'eventi;partecipanti;kernel', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'EventoPartecipanteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"EventoPartecipante","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Eventi;Table:EventoPartecipante;FK;NotNull;Tipologica', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'StatoInvitoEventoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'Presente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Eventi","table":"EventoPartecipante","column":"PersonaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Eventi', @level1type = N'TABLE', @level1name = N'EventoPartecipante', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

