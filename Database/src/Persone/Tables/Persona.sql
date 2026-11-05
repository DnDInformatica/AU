CREATE TABLE [Persone].[Persona] (
    [PersonaId]           INT                                                IDENTITY (1, 1) NOT NULL,
    [CodiceFiscale]       NVARCHAR (16)                                      NULL,
    [TitoloOnorificoId]   INT                                                NULL,
    [Cognome]             NVARCHAR (100)                                     NOT NULL,
    [Nome]                NVARCHAR (100)                                     NOT NULL,
    [Genere]              CHAR (1)                                           NULL,
    [DataNascita]         DATE                                               NOT NULL,
    [ComuneNascitaId]     INT                                                NULL,
    [LuogoNascita]        NVARCHAR (100)                                     NULL,
    [ProvinciaNascita]    NVARCHAR (2)                                       NULL,
    [StatoNascitaId]      INT                                                NULL,
    [ConsensoPrivacy]     BIT                                                DEFAULT ((0)) NOT NULL,
    [DataConsensoPrivacy] DATETIME2 (7)                                      NULL,
    [Note]                NVARCHAR (500)                                     NULL,
    [DataCreazione]       DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]            INT                                                NULL,
    [DataModifica]        DATETIME2 (7)                                      NULL,
    [ModificatoDa]        INT                                                NULL,
    [DataCancellazione]   DATETIME2 (7)                                      NULL,
    [CancellatoDa]        INT                                                NULL,
    [UniqueRowId]         UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]  DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]    DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_Persona] PRIMARY KEY CLUSTERED ([PersonaId] ASC),
    CONSTRAINT [CK_Persona_CodiceFiscale] CHECK ([CodiceFiscale] IS NULL OR len([CodiceFiscale])=(16)),
    CONSTRAINT [CK_Persona_ConsensoPrivacy] CHECK ([ConsensoPrivacy]=(0) AND [DataConsensoPrivacy] IS NULL OR [ConsensoPrivacy]=(1) AND [DataConsensoPrivacy] IS NOT NULL),
    CONSTRAINT [CK_Persona_Genere] CHECK ([Genere] IS NULL OR ([Genere]='F' OR [Genere]='M')),
    CONSTRAINT [FK_Persona_TitoloOnorifico] FOREIGN KEY ([TitoloOnorificoId]) REFERENCES [Tipologica].[TitoloOnorifico] ([TitoloOnorificoId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Persone].[PersonaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'LuogoNascita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ConsensoPrivacy';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"Nome","data_type":"nvarchar","max_length":200,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"PII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Nome';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ProvinciaNascita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataNascita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"PersonaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'CodiceFiscale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice fiscale — identificatore univoco della persona fisica. GDPR art. 4 §1: dato identificativo diretto. Art. 87 Reg. UE 2016/679 e D.Lgs. 196/2003 art. 24: il CF è dato fiscale soggetto a misure di sicurezza rafforzate. Richiede base giuridica in RegistroTrattamenti.BaseGiuridica.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'CodiceFiscale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Genere';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ConsensoPrivacy';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"Note","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'TitoloOnorificoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ComuneNascitaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'LuogoNascita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'StatoNascitaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Genere';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataConsensoPrivacy';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Cognome';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Nome';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'MASTER', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"LuogoNascita","data_type":"nvarchar","max_length":200,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'LuogoNascita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di consenso privacy (true = consenso acquisito). GDPR art. 7: il consenso deve essere libero, specifico, informato e inequivocabile. Questo campo è lo stato corrente; il dettaglio storico e per finalità vive in ConsensoPersona. NON eliminare a soft-delete: mantenere per audit GDPR art. 5 §2 (accountability). Valore default: 0 (nessun consenso).', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ConsensoPrivacy';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"Cognome","data_type":"nvarchar","max_length":200,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"PII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Cognome';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ConsensoPrivacy';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento logico a Accredia.Territorio.Paese.PaeseId (comune di nascita)', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ComuneNascitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ProvinciaNascita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Nome';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataNascita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento logico a Accredia.Territorio.Paese.PaeseId (stato/nazione di nascita)', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'StatoNascitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Nome';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;Nullable;PII;ValidatedField', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'CodiceFiscale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'LuogoNascita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"ComuneNascitaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ComuneNascitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'TitoloOnorificoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataConsensoPrivacy';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Genere';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"StatoNascitaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'StatoNascitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Cognome';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Genere';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ConsensoPrivacy';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Cognome';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ComuneNascitaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Cognome';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"ProvinciaNascita","data_type":"nvarchar","max_length":4,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ProvinciaNascita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"DataNascita","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataNascita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'StatoNascitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di acquisizione del consenso privacy. GDPR art. 7 §1: il titolare deve poter dimostrare che l''interessato ha prestato il consenso. Art. 5 §2 (accountability): traccia probatoria del momento di acquisizione. NULL = consenso non ancora acquisito o non applicabile (base giuridica diversa dal consenso).', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataConsensoPrivacy';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Anagrafica persone fisiche. GDPR Reg. UE 2016/679 art. 4 §1 — «interessato»: persona fisica identificabile. Art. 5 §1 — principi: minimizzazione dei dati (solo campi strettamente necessari), limitazione della conservazione (soft-delete + temporal). Art. 9 — dati particolari: DataNascita, CodiceFiscale sono dati identificativi sensibili; il loro trattamento richiede base giuridica esplicita in RegistroTrattamenti.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","entity":"Persona","temporal":true,"temporal_type":2,"history_table":"Persone.PersonaStorico","doc":{"ms_description":"MS_Description","extended_doc":"Accredia.Doc","model_note":"Accredia.ModelNote"}}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;NotNull;PII', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Nome';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'LuogoNascita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'CodiceFiscale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"DataConsensoPrivacy","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataConsensoPrivacy';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ComuneNascitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'TitoloOnorificoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'StatoNascitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Genere';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;NotNull', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataNascita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"CodiceFiscale","data_type":"nvarchar","max_length":32,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"PII","validation":"AgenziaEntrate-VerificaCF"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'CodiceFiscale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ProvinciaNascita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'TitoloOnorificoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"Genere","data_type":"char","max_length":1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Genere';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"ConsensoPrivacy","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ConsensoPrivacy';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'TitoloOnorificoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ProvinciaNascita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ComuneNascitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;NotNull;PII', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Cognome';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataNascita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Persone;Table:Persona;Nullable', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataConsensoPrivacy';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'StatoNascitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'Nome';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'persone;anagrafica;audit;compliance', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'LuogoNascita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'[TODO] Descrizione colonna da completare.', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'ProvinciaNascita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'CodiceFiscale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di nascita della persona. GDPR art. 4 §1: dato identificativo indiretto che contribuisce alla identificabilità univoca. Art. 5 §1 lett. c — minimizzazione: valorizzare solo se necessario per il processo (es. verifica età per incarichi regolamentati). Per minorenni si applica art. 8 GDPR (consenso del genitore).', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataNascita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'DataConsensoPrivacy';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Persone","table":"Persona","column":"TitoloOnorificoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.TitoloOnorifico.TitoloOnorificoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Persone', @level1type = N'TABLE', @level1name = N'Persona', @level2type = N'COLUMN', @level2name = N'TitoloOnorificoId';


GO

