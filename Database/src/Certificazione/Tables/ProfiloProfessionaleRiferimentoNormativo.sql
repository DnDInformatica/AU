CREATE TABLE [Certificazione].[ProfiloProfessionaleRiferimentoNormativo] (
    [ProfiloProfessionaleRiferimentoNormativoId] INT                                         IDENTITY (1, 1) NOT NULL,
    [ProfiloProfessionaleId]                     INT                                         NOT NULL,
    [ProfiloProfessionaleSpecificaTecnicaId]     INT                                         NULL,
    [NormaEdizioneId]                            INT                                         NULL,
    [SchemaCertificazioneVersioneId]             INT                                         NULL,
    [TipoRelazione]                              NVARCHAR (30)                               NOT NULL,
    [Ordinale]                                   INT                                         CONSTRAINT [DF_ProfProfRifNorm_Ordinale] DEFAULT ((1)) NOT NULL,
    [Obbligatoria]                               BIT                                         CONSTRAINT [DF_ProfProfRifNorm_Obbligatoria] DEFAULT ((0)) NOT NULL,
    [RiferimentoGrezzo]                          NVARCHAR (2000)                             NULL,
    [Attivo]                                     BIT                                         CONSTRAINT [DF_ProfProfRifNorm_Attivo] DEFAULT ((0)) NOT NULL,
    [DataCreazione]                              DATETIME2 (7)                               CONSTRAINT [DF_ProfProfRifNorm_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                                   INT                                         NULL,
    [DataModifica]                               DATETIME2 (7)                               NULL,
    [ModificatoDa]                               INT                                         NULL,
    [DataCancellazione]                          DATETIME2 (7)                               NULL,
    [CancellatoDa]                               INT                                         NULL,
    [UniqueRowId]                                UNIQUEIDENTIFIER                            CONSTRAINT [DF_ProfProfRifNorm_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                         DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]                           DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_ProfiloProfessionaleRiferimentoNormativo] PRIMARY KEY CLUSTERED ([ProfiloProfessionaleRiferimentoNormativoId] ASC),
    CONSTRAINT [CK_ProfProfRifNorm_AlmenoUnRiferimento] CHECK ([NormaEdizioneId] IS NOT NULL OR [SchemaCertificazioneVersioneId] IS NOT NULL),
    CONSTRAINT [CK_ProfProfRifNorm_TipoRelazione] CHECK ([TipoRelazione]='REGOLAMENTO_CAB' OR [TipoRelazione]='IN_ACCORDO_A' OR [TipoRelazione]='INTEGRA' OR [TipoRelazione]='BASATO_SU'),
    CONSTRAINT [FK_ProfProfRifNorm_NormaEdizione] FOREIGN KEY ([NormaEdizioneId]) REFERENCES [Standard].[NormaEdizione] ([NormaEdizioneId]),
    CONSTRAINT [FK_ProfProfRifNorm_Profilo] FOREIGN KEY ([ProfiloProfessionaleId]) REFERENCES [Certificazione].[ProfiloProfessionale] ([ProfiloProfessionaleId]),
    CONSTRAINT [FK_ProfProfRifNorm_SchemaCertVer] FOREIGN KEY ([SchemaCertificazioneVersioneId]) REFERENCES [Standard].[SchemaCertificazioneVersione] ([SchemaCertificazioneVersioneId]),
    CONSTRAINT [FK_ProfProfRifNorm_Spec] FOREIGN KEY ([ProfiloProfessionaleSpecificaTecnicaId]) REFERENCES [Certificazione].[ProfiloProfessionaleSpecificaTecnica] ([ProfiloProfessionaleSpecificaTecnicaId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Certificazione].[ProfiloProfessionaleRiferimentoNormativoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_ProfProfRifNorm_DataCancellazione]
    ON [Certificazione].[ProfiloProfessionaleRiferimentoNormativo]([DataCancellazione] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ProfProfRifNorm_CreatoDa]
    ON [Certificazione].[ProfiloProfessionaleRiferimentoNormativo]([CreatoDa] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_ProfProfRifNorm_ProfiloProfessionaleId]
    ON [Certificazione].[ProfiloProfessionaleRiferimentoNormativo]([ProfiloProfessionaleId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_ProfProfRifNorm_NormaEdizioneId]
    ON [Certificazione].[ProfiloProfessionaleRiferimentoNormativo]([NormaEdizioneId] ASC);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_ProfProfRifNorm_BusinessKey]
    ON [Certificazione].[ProfiloProfessionaleRiferimentoNormativo]([ProfiloProfessionaleId] ASC, [NormaEdizioneId] ASC, [SchemaCertificazioneVersioneId] ASC, [TipoRelazione] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ProfProfRifNorm_SchemaCertVersioneId]
    ON [Certificazione].[ProfiloProfessionaleRiferimentoNormativo]([SchemaCertificazioneVersioneId] ASC);


GO

CREATE   TRIGGER [Certificazione].[TR_MIG123_Freeze_ProfiloProfessionaleRiferimentoNormativo] ON [Certificazione].[ProfiloProfessionaleRiferimentoNormativo] AFTER INSERT, UPDATE, DELETE AS
                   BEGIN
                       SET NOCOUNT ON;
                       THROW 62331,
                           'MIG_123: catalogo legacy congelato; usare Standard.',
                           1;
                   END;

GO

EXECUTE sp_addextendedproperty @name = N'Accredia.ArchiveTable', @value = N'[ArchiveSIAC].[Legacy_Certificazione_ProfiloProfessionaleRiferimentoNormativo]', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleRiferimentoNormativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"status":"Deprecated","reason":"Catalogo profilo professionale legacy duplicato nel modello canonico Standard","replacement":"Standard.ProfiloProfessionaleVersioneRiferimentoNormativo","write_policy":"Nessun nuovo consumer o nuovo utilizzo; sola conservazione transitoria","decommission_gate":"Preservare provenienza identificativi, classificare history system-time e verificare consumer esterni prima della rimozione"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleRiferimentoNormativo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimenti normativi di una figura professionale FPC: relazione molti-a-molti tipizzata verso NormaEdizione o SchemaCertificazioneVersione. Sostituisce la specifica a testo libero e la FK singola.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleRiferimentoNormativo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riga di specifica tecnica di origine (deprecanda), per tracciabilita della migrazione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'ProfiloProfessionaleSpecificaTecnicaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Versione di schema certificativo di riferimento (architettura C1). Nullable: alternativa a NormaEdizioneId.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'SchemaCertificazioneVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ordine di citazione del riferimento entro la figura (1 = primario).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'Ordinale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stringa normativa originaria dell''anagrafe FPC (law_regulation_it), conservata per audit e ricostruzione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'RiferimentoGrezzo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.DecommissionState', @value = N'ARCHIVED_AWAITING_EXTERNAL_APPROVAL', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleRiferimentoNormativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Deprecated', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleRiferimentoNormativo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Figura professionale a cui il riferimento appartiene.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'ProfiloProfessionaleId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Edizione di norma tecnica di riferimento (Modello B). Nullable: alternativa a SchemaCertificazioneVersioneId.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'NormaEdizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ruolo del riferimento: BASATO_SU (norma base), INTEGRA (norma integrativa), IN_ACCORDO_A, REGOLAMENTO_CAB.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'TipoRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se il riferimento e obbligatorio ai fini della certificazione della figura.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'Obbligatoria';


GO

