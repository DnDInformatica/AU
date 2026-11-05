CREATE TABLE [Persone].[RichiestaEsercizioDiritti] (
    [RichiestaEsercizioDirittiId] INT                                                IDENTITY (1, 1) NOT NULL,
    [PersonaId]                   INT                                                NULL,
    [NomeRichiedente]             NVARCHAR (200)                                     NOT NULL,
    [EmailRichiedente]            NVARCHAR (200)                                     NOT NULL,
    [TelefonoRichiedente]         NVARCHAR (50)                                      NULL,
    [Codice]                      NVARCHAR (30)                                      NOT NULL,
    [TipoDirittoGDPRId]           INT                                                NOT NULL,
    [DataRichiesta]               DATETIME2 (7)                                      NOT NULL,
    [ModalitaRichiesta]           NVARCHAR (30)                                      NOT NULL,
    [TestoRichiesta]              NVARCHAR (MAX)                                     NULL,
    [DocumentoRichiesta]          NVARCHAR (500)                                     NULL,
    [IdentitaVerificata]          BIT                                                DEFAULT ((0)) NOT NULL,
    [DataVerificaIdentita]        DATETIME2 (7)                                      NULL,
    [ModalitaVerifica]            NVARCHAR (100)                                     NULL,
    [DataScadenza]                DATE                                               NOT NULL,
    [DataProrogaRichiesta]        DATE                                               NULL,
    [MotivoProrogaRichiesta]      NVARCHAR (500)                                     NULL,
    [Stato]                       NVARCHAR (30)                                      DEFAULT ('RICEVUTA') NOT NULL,
    [ResponsabileGestioneId]      INT                                                NULL,
    [Note]                        NVARCHAR (MAX)                                     NULL,
    [DataRisposta]                DATETIME2 (7)                                      NULL,
    [EsitoRisposta]               NVARCHAR (30)                                      NULL,
    [MotivoRifiuto]               NVARCHAR (MAX)                                     NULL,
    [TestoRisposta]               NVARCHAR (MAX)                                     NULL,
    [DocumentoRisposta]           NVARCHAR (500)                                     NULL,
    [DataEsecuzione]              DATETIME2 (7)                                      NULL,
    [DatiCancellati]              NVARCHAR (MAX)                                     NULL,
    [DataCreazione]               DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                    INT                                                NULL,
    [DataModifica]                DATETIME2 (7)                                      NULL,
    [ModificatoDa]                INT                                                NULL,
    [DataCancellazione]           DATETIME2 (7)                                      NULL,
    [CancellatoDa]                INT                                                NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]          DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]            DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_RichiestaEsercizioDiritti] PRIMARY KEY CLUSTERED ([RichiestaEsercizioDirittiId] ASC),
    CONSTRAINT [CK_RichiestaEsercizioDiritti_Esito] CHECK ([EsitoRisposta] IS NULL OR ([EsitoRisposta]='RIFIUTATA' OR [EsitoRisposta]='PARZIALE' OR [EsitoRisposta]='ACCOLTA')),
    CONSTRAINT [CK_RichiestaEsercizioDiritti_Modalita] CHECK ([ModalitaRichiesta]='TELEFONO' OR [ModalitaRichiesta]='WEB' OR [ModalitaRichiesta]='CARTACEO' OR [ModalitaRichiesta]='PEC' OR [ModalitaRichiesta]='EMAIL'),
    CONSTRAINT [CK_RichiestaEsercizioDiritti_Stato] CHECK ([Stato]='ANNULLATA' OR [Stato]='COMPLETATA' OR [Stato]='IN_LAVORAZIONE' OR [Stato]='IN_VERIFICA' OR [Stato]='RICEVUTA'),
    CONSTRAINT [FK_RichiestaEsercizioDiritti_Persona] FOREIGN KEY ([PersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [FK_RichiestaEsercizioDiritti_Responsabile] FOREIGN KEY ([ResponsabileGestioneId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [FK_RichiestaEsercizioDiritti_TipoDiritto] FOREIGN KEY ([TipoDirittoGDPRId]) REFERENCES [Tipologica].[TipoDirittoGDPR] ([TipoDirittoGDPRId]),
    CONSTRAINT [UK_RichiestaEsercizioDiritti_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Persone].[RichiestaEsercizioDirittiStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione dei dati cancellati/anonimizzati a seguito della richiesta art. 17. GDPR art. 17 §1 — diritto all''oblio: il titolare cancella i dati senza ingiustificato ritardo. Questo campo documenta quali dati sono stati cancellati e con quale modalità (cancellazione fisica, anonimizzazione, pseudonimizzazione) per accountability art. 5 §2. NULL per diritti diversi da art. 17.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DatiCancellati';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ModalitaVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataEsecuzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'EsitoRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'NomeRichiedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"MotivoProrogaRichiesta","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'MotivoProrogaRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DocumentoRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ResponsabileGestioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ModalitaVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TestoRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'MotivoProrogaRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di ricezione della richiesta. GDPR art. 12 §3: il titolare risponde senza ingiustificato ritardo, e comunque entro un mese. Il termine decorre da DataRichiesta. Combinato con DataScadenza (DataRichiesta + 30gg) consente il monitoraggio SLA e l''alerting automatico.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TestoRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'RichiestaEsercizioDirittiId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"MotivoRifiuto","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'MotivoRifiuto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ModalitaRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Tipologica.TipoDirittoGDPR. GDPR — diritto esercitato: art. 15 (accesso), art. 16 (rettifica), art. 17 (cancellazione/oblio), art. 18 (limitazione), art. 20 (portabilità), art. 21 (opposizione). Il tipo determina le azioni da eseguire sul database (es. art. 17 → soft-delete + anonimizzazione dati correlati; art. 20 → export strutturato).', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TipoDirittoGDPRId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ResponsabileGestioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ModalitaRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TipoDirittoGDPRId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TelefonoRichiedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataEsecuzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"DatiCancellati","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DatiCancellati';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TestoRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'RichiestaEsercizioDirittiId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'EsitoRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DocumentoRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TestoRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DocumentoRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"Stato","data_type":"nvarchar","max_length":60,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TelefonoRichiedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'IdentitaVerificata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'MotivoRifiuto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataProrogaRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'EmailRichiedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ModalitaVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"PersonaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DocumentoRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TipoDirittoGDPRId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'MotivoProrogaRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TestoRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"DataScadenza","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ModalitaRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'RichiestaEsercizioDirittiId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ModalitaRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TipoDirittoGDPRId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TestoRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'MotivoRifiuto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DocumentoRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TestoRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DocumentoRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TelefonoRichiedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"RichiestaEsercizioDirittiId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'RichiestaEsercizioDirittiId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"DataEsecuzione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataEsecuzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'IdentitaVerificata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TelefonoRichiedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DatiCancellati';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"EsitoRisposta","data_type":"nvarchar","max_length":60,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'EsitoRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'IdentitaVerificata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"DataProrogaRichiesta","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataProrogaRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'EmailRichiedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DocumentoRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'persone;anagrafica;audit;compliance', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Motivazione del rifiuto della richiesta. GDPR art. 12 §4: il rifiuto deve essere motivato con riferimento alla norma applicabile. Cause lecite di rifiuto: libertà di espressione (art. 17 §3 lett. a), obbligo legale (art. 17 §3 lett. b), interesse pubblico (art. 17 §3 lett. d), accertamento diritti in sede giudiziaria (art. 17 §3 lett. e), richiesta manifestamente infondata/eccessiva (art. 12 §5).', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'MotivoRifiuto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'EmailRichiedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataVerificaIdentita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataVerificaIdentita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'NomeRichiedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataProrogaRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"Note","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'RichiestaEsercizioDirittiId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;Nullable;PII', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TelefonoRichiedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"DocumentoRichiesta","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DocumentoRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di scadenza per la risposta (DataRichiesta + 30 giorni). GDPR art. 12 §3: termine ordinario di un mese; art. 12 §3 secondo comma: proroga di ulteriori due mesi per complessità o numero di richieste, con comunicazione all''interessato entro il primo mese. DataProrogaRichiesta contiene il termine prorogato.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'MotivoRifiuto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"TelefonoRichiedente","data_type":"nvarchar","max_length":100,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"PII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TelefonoRichiedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DocumentoRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Richieste di esercizio dei diritti dell''interessato verso ACCREDIA come titolare del trattamento. Riferimento normativo europeo: Reg. UE 2016/679 (GDPR) — art. 15 (accesso), art. 16 (rettifica), art. 17 (cancellazione/diritto all''oblio), art. 18 (limitazione), art. 20 (portabilità), art. 21 (opposizione). ACCREDIA ha l''obbligo di rispondere entro 30 giorni (art. 12 §3). Ogni record traccia tipo di richiesta, data, esito e termine di evasione.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;NotNull;PII', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'EmailRichiedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"IdentitaVerificata","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'IdentitaVerificata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"DocumentoRisposta","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DocumentoRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'EsitoRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataProrogaRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"EmailRichiedente","data_type":"nvarchar","max_length":400,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"PII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'EmailRichiedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DatiCancellati';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataEsecuzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'IdentitaVerificata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ResponsabileGestioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;NotNull;PII', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'NomeRichiedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"DataVerificaIdentita","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataVerificaIdentita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataVerificaIdentita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataProrogaRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TestoRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"NomeRichiedente","data_type":"nvarchar","max_length":400,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"PII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'NomeRichiedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"ModalitaVerifica","data_type":"nvarchar","max_length":200,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ModalitaVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"DataRisposta","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataEsecuzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ResponsabileGestioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'MotivoProrogaRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Esito della risposta alla richiesta. GDPR art. 12 §4: se il titolare non dà seguito alla richiesta, informa l''interessato entro un mese dei motivi e della possibilità di proporre reclamo all''autorità di controllo (art. 77) o ricorso giurisdizionale (art. 79). Valori attesi: EVASO / RIFIUTATO / PARZIALMENTE_EVASO / TRASFERITO.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'EsitoRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di verifica dell''identità del richiedente. GDPR art. 12 §6: il titolare può richiedere informazioni supplementari per verificare l''identità dell''interessato; non può richiedere informazioni non necessarie. La verifica è obbligatoria per richieste ad alto rischio (es. art. 17 cancellazione, art. 20 portabilità). Falso positivo = risposta a soggetto non legittimato.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'IdentitaVerificata';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ASSOCIAZIONE', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'EmailRichiedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataVerificaIdentita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DatiCancellati';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataEsecuzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataProrogaRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'NomeRichiedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","entity":"RichiestaEsercizioDiritti","temporal":true,"temporal_type":2,"history_table":"Persone.RichiestaEsercizioDirittiStorico","doc":{"ms_description":"MS_Description","extended_doc":"Accredia.Doc","model_note":"Accredia.ModelNote"}}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DocumentoRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'NomeRichiedente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'EsitoRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"TestoRisposta","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TestoRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'MotivoProrogaRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"ResponsabileGestioneId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ResponsabileGestioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataVerificaIdentita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ModalitaVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'MotivoRifiuto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ResponsabileGestioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'MotivoProrogaRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DocumentoRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'RichiestaEsercizioDirittiId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"TipoDirittoGDPRId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.TipoDirittoGDPR.TipoDirittoGDPRId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TipoDirittoGDPRId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"DataRichiesta","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"ModalitaRichiesta","data_type":"nvarchar","max_length":60,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ModalitaRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TipoDirittoGDPRId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DatiCancellati';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ModalitaVerifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'DataScadenza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"Codice","data_type":"nvarchar","max_length":60,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TestoRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'Stato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TestoRisposta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"RichiestaEsercizioDiritti","column":"TestoRichiesta","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'TestoRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:RichiestaEsercizioDiritti;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'RichiestaEsercizioDiritti', @level2type = N'COLUMN', @level2name = N'ModalitaRichiesta';


GO

