CREATE TABLE [Organizzazioni].[CapitaleSociale] (
    [CapitaleSocialeStoricoId] INT                                                IDENTITY (1, 1) NOT NULL,
    [OrganizzazioneId]         INT                                                NOT NULL,
    [DataRiferimento]          DATE                                               NOT NULL,
    [CapitaleDeliberato]       DECIMAL (19, 2)                                    NULL,
    [CapitaleSottoscritto]     DECIMAL (19, 2)                                    NULL,
    [CapitaleVersato]          DECIMAL (19, 2)                                    NULL,
    [Valuta]                   CHAR (3)                                           DEFAULT ('EUR') NOT NULL,
    [NumeroAzioni]             BIGINT                                             NULL,
    [ValoreNominaleAzione]     DECIMAL (19, 6)                                    NULL,
    [Fonte]                    NVARCHAR (60)                                      DEFAULT (N'VISURA_RI') NOT NULL,
    [DocumentoId]              INT                                                NULL,
    [Note]                     NVARCHAR (1000)                                    NULL,
    [DataCreazione]            DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                 INT                                                NULL,
    [DataModifica]             DATETIME2 (7)                                      NULL,
    [ModificatoDa]             INT                                                NULL,
    [DataCancellazione]        DATETIME2 (7)                                      NULL,
    [CancellatoDa]             INT                                                NULL,
    [UniqueRowId]              UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]         DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_CapitaleSociale] PRIMARY KEY CLUSTERED ([CapitaleSocialeStoricoId] ASC),
    CONSTRAINT [FK_CapitaleSociale_Documento] FOREIGN KEY ([DocumentoId]) REFERENCES [Documentale].[Documento] ([DocumentoId]),
    CONSTRAINT [FK_CapitaleSociale_Organizzazione] FOREIGN KEY ([OrganizzazioneId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Organizzazioni].[CapitaleSocialeStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'ValoreNominaleAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataRiferimento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:CapitaleSociale;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleSottoscritto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo di dominio NumeroAzioni.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'NumeroAzioni';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'Fonte';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleDeliberato';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo di dominio ValoreNominaleAzione.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'ValoreNominaleAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"CapitaleSociale","column":"CapitaleVersato","data_type":"decimal","max_length":9,"precision":19,"scale":2,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleVersato';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco del record.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleSocialeStoricoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"CapitaleSociale","column":"Valuta","data_type":"char","max_length":3,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'Valuta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleDeliberato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Documentale.Documento.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:CapitaleSociale;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleVersato';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo di dominio Fonte.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'Fonte';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave esterna verso Organizzazioni.Organizzazione.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:CapitaleSociale;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'Valuta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note e annotazioni operative.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"CapitaleSociale","column":"CapitaleDeliberato","data_type":"decimal","max_length":9,"precision":19,"scale":2,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleDeliberato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'Fonte';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleVersato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'Fonte';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:CapitaleSociale;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleDeliberato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'Valuta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo di dominio CapitaleVersato.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleVersato';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo di dominio Valuta.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'Valuta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Storico del capitale sociale e delle sue varianti (deliberato, sottoscritto, versato). Standard ACCREDIA: RG-01 rev.06 EC — il capitale sociale è elemento di valutazione della solidità finanziaria dell''OdC ai fini dell''accreditamento (requisiti di indipendenza e imparzialità); DA-01 rev.04 — il documento di accreditamento riporta la configurazione societaria al momento del rilascio; variazioni significative del capitale triggherano revisione del DA. Normativa italiana: Codice Civile artt. 2327, 2342, 2346 (capitale SPA); D.Lgs. 123/2022 art. 4.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleSocialeStoricoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'NumeroAzioni';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record (GUID tecnico).', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"CapitaleSociale","column":"CapitaleSottoscritto","data_type":"decimal","max_length":9,"precision":19,"scale":2,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleSottoscritto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataRiferimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:CapitaleSociale;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'Valuta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"CapitaleSociale","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:CapitaleSociale;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:CapitaleSociale;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"CapitaleSociale","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"CapitaleSociale","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:CapitaleSociale;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:CapitaleSociale;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"CapitaleSociale","column":"Note","data_type":"nvarchar","max_length":2000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"CapitaleSociale","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:CapitaleSociale;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'NumeroAzioni';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleSocialeStoricoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo di dominio CapitaleDeliberato.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleDeliberato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'ValoreNominaleAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleSocialeStoricoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'NumeroAzioni';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"CapitaleSociale","column":"DataRiferimento","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataRiferimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleSottoscritto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'ValoreNominaleAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:CapitaleSociale;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataRiferimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo di dominio CapitaleSottoscritto.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleSottoscritto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:CapitaleSociale;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"CapitaleSociale","column":"NumeroAzioni","data_type":"bigint","max_length":8,"precision":19,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'NumeroAzioni';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"CapitaleSociale","column":"CapitaleSocialeStoricoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleSocialeStoricoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleSottoscritto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:CapitaleSociale;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleSocialeStoricoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"CapitaleSociale","temporal":true,"temporal_type":2,"history_table":"Organizzazioni.CapitaleSocialeStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"CapitaleSociale","column":"ValoreNominaleAzione","data_type":"decimal","max_length":9,"precision":19,"scale":6,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'ValoreNominaleAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"CapitaleSociale","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataRiferimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:CapitaleSociale;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'NumeroAzioni';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleSottoscritto';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"CapitaleSociale","column":"Fonte","data_type":"nvarchar","max_length":120,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'Fonte';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data/evento rilevante per il processo di dominio.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataRiferimento';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"CapitaleSociale","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:CapitaleSociale;Nullable', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'ValoreNominaleAzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleVersato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:CapitaleSociale;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'Valuta';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:CapitaleSociale;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.03', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleDeliberato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"CapitaleSociale","column":"DocumentoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Documentale.Documento.DocumentoId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'TRANSAZIONE', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"CapitaleSociale","column":"OrganizzazioneId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Organizzazioni.Organizzazione.OrganizzazioneId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'OrganizzazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organizzazioni","table":"CapitaleSociale","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:CapitaleSociale;NotNull', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'Fonte';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'CapitaleVersato';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organizzazioni;Table:CapitaleSociale;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'CapitaleSociale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

