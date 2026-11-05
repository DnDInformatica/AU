CREATE TABLE [RisorseUmane].[Dipendente] (
    [DipendenteId]               INT                                                IDENTITY (1, 1) NOT NULL,
    [PersonaId]                  INT                                                NOT NULL,
    [Matricola]                  NVARCHAR (20)                                      NOT NULL,
    [EmailAziendale]             NVARCHAR (100)                                     NULL,
    [TelefonoInterno]            NVARCHAR (10)                                      NULL,
    [UnitaOrganizzativaId]       INT                                                NULL,
    [ResponsabileDirettoId]      INT                                                NULL,
    [DataAssunzione]             DATE                                               NOT NULL,
    [DataCessazione]             DATE                                               NULL,
    [StatoDipendenteId]          INT                                                NOT NULL,
    [AbilitatoAttivitaIspettiva] BIT                                                DEFAULT ((0)) NOT NULL,
    [Note]                       NVARCHAR (MAX)                                     NULL,
    [DataCreazione]              DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                   INT                                                NULL,
    [DataModifica]               DATETIME2 (7)                                      NULL,
    [ModificatoDa]               INT                                                NULL,
    [DataCancellazione]          DATETIME2 (7)                                      NULL,
    [CancellatoDa]               INT                                                NULL,
    [UniqueRowId]                UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]         DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]           DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_Dipendente] PRIMARY KEY CLUSTERED ([DipendenteId] ASC),
    CONSTRAINT [CK_Dipendente_Date] CHECK ([DataCessazione] IS NULL OR [DataCessazione]>=[DataAssunzione]),
    CONSTRAINT [FK_Dipendente_Persona] FOREIGN KEY ([PersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    CONSTRAINT [FK_Dipendente_Responsabile] FOREIGN KEY ([ResponsabileDirettoId]) REFERENCES [RisorseUmane].[Dipendente] ([DipendenteId]),
    CONSTRAINT [FK_Dipendente_Stato] FOREIGN KEY ([StatoDipendenteId]) REFERENCES [Tipologica].[StatoDipendente] ([StatoDipendenteId]),
    CONSTRAINT [FK_Dipendente_UnitaOrganizzativa] FOREIGN KEY ([UnitaOrganizzativaId]) REFERENCES [Organizzazioni].[UnitaOrganizzativa] ([UnitaOrganizzativaId]),
    CONSTRAINT [UQ_Dipendente_Matricola] UNIQUE NONCLUSTERED ([Matricola] ASC),
    CONSTRAINT [UQ_Dipendente_Persona] UNIQUE NONCLUSTERED ([PersonaId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[RisorseUmane].[DipendenteStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dipendente","column":"EmailAziendale","data_type":"nvarchar","max_length":200,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"PII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'EmailAziendale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dipendente;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dipendente;Nullable', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'AbilitatoAttivitaIspettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{

        "schema": "RisorseUmane",

        "table": "Dipendente",

        "entity": "Dipendente",

        "temporal": true,

        "temporal_type": 2,

        "history_table": "RisorseUmane.DipendenteStorico",

        "integrations": {

            "persona": "Persone.Persona",

            "unita_organizzativa": "Organizzazioni.UnitaOrganizzativa",

            "ispettore_interno": "Ispettori.Ispettore"

        },

        "business_rules": {

            "unique_persona": true,

            "unique_matricola": true,

            "hierarchy_via_responsabile": true,

            "inspector_link_via_abilitato": true

        },

        "gdpr": {

            "contains_pii": true,

            "retention_years": 10,

            "access_restricted": true

        },

        "reference": "Regolamento del Personale ACCREDIA"

    }', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'AbilitatoAttivitaIspettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di fine rapporto di lavoro. NULL se ancora in essere.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'EmailAziendale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dipendente","column":"UnitaOrganizzativaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Organizzazioni.UnitaOrganizzativa.UnitaOrganizzativaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'UnitaOrganizzativaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataAssunzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dipendente","column":"PersonaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Persone.Persona.PersonaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dipendente","column":"DataAssunzione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataAssunzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dipendente;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'UnitaOrganizzativaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dipendente","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dipendente","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'UnitaOrganizzativaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'EmailAziendale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'StatoDipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dipendente;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'AbilitatoAttivitaIspettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'ResponsabileDirettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dipendente;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'Matricola';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dipendente","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'AbilitatoAttivitaIspettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dipendente;Nullable;PII', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'TelefonoInterno';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Matricola aziendale univoca assegnata al dipendente.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'Matricola';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dipendente;PK;Identity;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dipendente;Nullable', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogate auto-incrementale.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dipendente","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note libere sul dipendente.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dipendente;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dipendente;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'ResponsabileDirettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero telefonico interno (es. 301, 402).', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'TelefonoInterno';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dipendente","column":"AbilitatoAttivitaIspettiva","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'AbilitatoAttivitaIspettiva';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK self-reference. DipendenteId del responsabile diretto gerarchico.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'ResponsabileDirettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'UnitaOrganizzativaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'EmailAziendale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dipendente","column":"TelefonoInterno","data_type":"nvarchar","max_length":20,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"PII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'TelefonoInterno';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di inizio rapporto di lavoro (assunzione).', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataAssunzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dipendente","column":"Matricola","data_type":"nvarchar","max_length":40,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'Matricola';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'ResponsabileDirettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'StatoDipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dipendente","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dipendente","column":"Note","data_type":"nvarchar","max_length":-1,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dipendente;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'StatoDipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dipendente","column":"ResponsabileDirettoId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"RisorseUmane.Dipendente.DipendenteId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'ResponsabileDirettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dipendente","column":"DipendenteId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dipendente;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dipendente","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'TelefonoInterno';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'Matricola';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dipendente","column":"DataCessazione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'ResponsabileDirettoId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dipendente;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'Matricola';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'TelefonoInterno';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Tipologica.StatoDipendente. Stato corrente: ATTIVO, PROVA, SOSPESO, CESSATO.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'StatoDipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dipendente;Nullable;PII', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'EmailAziendale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dipendente;Nullable;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dipendente","column":"StatoDipendenteId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.StatoDipendente.StatoDipendenteId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'StatoDipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dipendente;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataAssunzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"RisorseUmane","table":"Dipendente","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataAssunzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'MASTER', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'TRUE se il dipendente è abilitato a svolgere attività ispettiva come ispettore interno.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'AbilitatoAttivitaIspettiva';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dipendente;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'UnitaOrganizzativaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Organizzazioni.UnitaOrganizzativa. Area/Direzione di appartenenza.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'UnitaOrganizzativaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indirizzo email aziendale @accredia.it.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'EmailAziendale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Persone.Persona. Relazione 1:1, una persona può essere dipendente ACCREDIA una sola volta.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'PersonaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'risorse-umane,anagrafica,core,dipendenti,gdpr', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'StatoDipendenteId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'Matricola';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dipendente;NotNull;AuditColumn', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.02', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:RisorseUmane;Table:Dipendente;NotNull', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'DataAssunzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Risorse Umane', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente', @level2type = N'COLUMN', @level2name = N'TelefonoInterno';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Anagrafica dipendenti ACCREDIA. Gestisce rapporto di lavoro, collocazione organizzativa e abilitazioni.', @level0type = N'SCHEMA', @level0name = N'RisorseUmane', @level1type = N'TABLE', @level1name = N'Dipendente';


GO

