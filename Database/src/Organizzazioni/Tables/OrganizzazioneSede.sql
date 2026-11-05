CREATE TABLE [Organizzazioni].[OrganizzazioneSede] (
    [OrganizzazioneSedeId]     INT                                                IDENTITY (1, 1) NOT NULL,
    [OrganizzazioneId]         INT                                                NOT NULL,
    [Progressivo]              SMALLINT                                           NULL,
    [NIscrizioneREA]           NVARCHAR (9)                                       NULL,
    [SiglaProvinciaREA]        NVARCHAR (2)                                       NULL,
    [DataIscrizioneREA]        DATETIME2 (7)                                      NULL,
    [TipoOrganizzazioneSedeId] TINYINT                                            NOT NULL,
    [Denominazione]            NVARCHAR (500)                                     NULL,
    [Insegna]                  NVARCHAR (50)                                      NULL,
    [DataApertura]             DATE                                               NULL,
    [CodiceStatoAttivitaId]    NVARCHAR (1)                                       NULL,
    [DescrizioneAttivita]      NVARCHAR (500)                                     NULL,
    [DataInizioAttivita]       DATE                                               NULL,
    [CodiceAttivitaISTAT]      NVARCHAR (6)                                       NULL,
    [CodiceCausaleCessazione]  NVARCHAR (8)                                       NULL,
    [DataCessazioneUL]         DATE                                               NULL,
    [DataDenunciaCessazione]   DATE                                               NULL,
    [IndirizzoID]              BIGINT                                             NULL,
    [DataCreazione]            DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                 INT                                                NULL,
    [DataModifica]             DATETIME2 (7)                                      NULL,
    [ModificatoDa]             INT                                                NULL,
    [DataCancellazione]        DATETIME2 (7)                                      NULL,
    [CancellatoDa]             INT                                                NULL,
    [UniqueRowId]              UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]         DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [SedeCanonicaId]           INT                                                NULL,
    [StatoRiconciliazione]     NVARCHAR (40)                                      NULL,
    [MetodoRiconciliazione]    NVARCHAR (120)                                     NULL,
    [DataRiconciliazione]      DATETIME2 (7)                                      NULL,
    [NoteRiconciliazione]      NVARCHAR (2000)                                    NULL,
    CONSTRAINT [PK_OrganizzazioneSede] PRIMARY KEY CLUSTERED ([OrganizzazioneSedeId] ASC),
    CONSTRAINT [CK_OrganizzazioneSede_StatoRiconciliazione] CHECK ([StatoRiconciliazione] IS NULL OR ([StatoRiconciliazione]=N'NON_RICONCILIABILE' OR [StatoRiconciliazione]=N'AMBIGUA' OR [StatoRiconciliazione]=N'RICONCILIATA')),
    CONSTRAINT [FK_OrganizzazioneSede_Organizzazione] FOREIGN KEY ([OrganizzazioneId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId]),
    CONSTRAINT [FK_OrganizzazioneSede_SedeCanonica] FOREIGN KEY ([SedeCanonicaId]) REFERENCES [Organizzazioni].[Sede] ([SedeId]),
    CONSTRAINT [FK_OrganizzazioneSede_TipoOrganizzazioneSede] FOREIGN KEY ([TipoOrganizzazioneSedeId]) REFERENCES [Tipologica].[TipoOrganizzazioneSede] ([TipoOrganizzazioneSedeId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Organizzazioni].[OrganizzazioneSedeStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE   TRIGGER Organizzazioni.TR_OrganizzazioneSede_LegacyReadOnly ON Organizzazioni.OrganizzazioneSede AFTER INSERT,UPDATE,DELETE AS
BEGIN SET NOCOUNT ON; THROW 52204,N'OrganizzazioneSede e dismessa e in sola lettura. Usare Organizzazioni.Sede.',1; END;

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento all''indirizzo anagrafico/fisico della sede.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'IndirizzoID';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Organizzazione proprietaria della sede.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'NIscrizioneREA';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataCessazioneUL';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CodiceStatoAttivitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataApertura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CodiceCausaleCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataInizioAttivita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sigla provincia della Camera di Commercio associata al numero REA (es. MI, RM, TO).', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'SiglaProvinciaREA';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"Denominazione","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"DataDenunciaCessazione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataDenunciaCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'Insegna';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'TipoOrganizzazioneSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'NIscrizioneREA';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"OrganizzazioneId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Organizzazioni.Organizzazione.OrganizzazioneId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CodiceCausaleCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"SiglaProvinciaREA","data_type":"nvarchar","max_length":4,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'SiglaProvinciaREA';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'OrganizzazioneSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"DescrizioneAttivita","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DescrizioneAttivita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CodiceStatoAttivitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'Progressivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di inizio attività operativa della sede.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataInizioAttivita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataDenunciaCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insegna commerciale associata alla sede/unità locale.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'Insegna';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'TABELLA LEGACY IN SOLA LETTURA. Non usare per nuove scritture. Ogni riga e riconciliata tramite SedeCanonicaId; il master ufficiale e Organizzazioni.Sede.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataIscrizioneREA';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"CodiceCausaleCessazione","data_type":"nvarchar","max_length":16,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CodiceCausaleCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'MASTER', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice stato attività della sede (attiva, sospesa, cessata, ecc.).', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CodiceStatoAttivitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataDenunciaCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataApertura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataIscrizioneREA';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataInizioAttivita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"NIscrizioneREA","data_type":"nvarchar","max_length":18,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'NIscrizioneREA';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'Insegna';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"TipoOrganizzazioneSedeId","data_type":"tinyint","max_length":1,"precision":3,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.TipoOrganizzazioneSede.TipoOrganizzazioneSedeId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'TipoOrganizzazioneSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CodiceCausaleCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DescrizioneAttivita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'OrganizzazioneSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'SiglaProvinciaREA';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CodiceAttivitaISTAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di denuncia/comunicazione ufficiale della cessazione.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataDenunciaCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"CodiceStatoAttivitaId","data_type":"nvarchar","max_length":2,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CodiceStatoAttivitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'Progressivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"DataCessazioneUL","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataCessazioneUL';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataApertura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataIscrizioneREA';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'IndirizzoID';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CodiceAttivitaISTAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione dell''attività prevalente svolta presso la sede.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DescrizioneAttivita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Denominazione operativa della sede, se diversa dalla ragione sociale.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'TipoOrganizzazioneSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'OrganizzazioneSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'GUID univoco del record', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di apertura della sede o unità locale.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataApertura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataDenunciaCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'organizzazioni;anagrafica;audit;compliance', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"DataIscrizioneREA","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataIscrizioneREA';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha cancellato il record', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'NIscrizioneREA';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","temporal":true,"temporal_type":2,"history_table":"Organizzazioni.OrganizzazioneSedeStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'TipoOrganizzazioneSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'Insegna';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"CodiceAttivitaISTAT","data_type":"nvarchar","max_length":12,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CodiceAttivitaISTAT';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'IndirizzoID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice della causale amministrativa di cessazione dell''unità locale.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CodiceCausaleCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DescrizioneAttivita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'SiglaProvinciaREA';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataCessazioneUL';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'Progressivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'IndirizzoID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo univoco della sede organizzativa.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'OrganizzazioneSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CodiceStatoAttivitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataInizioAttivita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataIscrizioneREA';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"DataApertura","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataApertura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"OrganizzazioneSedeId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'OrganizzazioneSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'Insegna';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CodiceAttivitaISTAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipologia sede nel dominio organizzativo (es. PRINCIPALE, SECONDARIA, DEPOSITO).', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'TipoOrganizzazioneSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'Progressivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero REA della sede presso la Camera di Commercio competente.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'NIscrizioneREA';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di cessazione effettiva dell''unità locale/sede.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataCessazioneUL';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DescrizioneAttivita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'NIscrizioneREA';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"IndirizzoID","data_type":"bigint","max_length":8,"precision":19,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'IndirizzoID';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataCessazioneUL';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'TipoOrganizzazioneSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CodiceAttivitaISTAT';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CodiceStatoAttivitaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'SiglaProvinciaREA';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'IndirizzoID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataCessazioneUL';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha modificato il record', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"Insegna","data_type":"nvarchar","max_length":100,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'Insegna';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"DataInizioAttivita","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataInizioAttivita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice attività ISTAT/Ateco associato all''attività della sede.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CodiceAttivitaISTAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di iscrizione REA della sede.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataIscrizioneREA';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Progressivo della sede nel perimetro dell''organizzazione, usato in acquisizioni/import legacy.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'Progressivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataApertura';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'OrganizzazioneSedeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataDenunciaCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica del record.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'SiglaProvinciaREA';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DescrizioneAttivita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:OrganizzazioneSede;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'DataInizioAttivita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'CodiceCausaleCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"OrganizzazioneSede","column":"Progressivo","data_type":"smallint","max_length":2,"precision":5,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneSede', @level2type = N'COLUMN', @level2name = N'Progressivo';


GO

