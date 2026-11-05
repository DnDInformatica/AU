CREATE TABLE [Certificazione].[ProfiloProfessionaleIdentificativo] (
    [ProfiloProfessionaleIdentificativoId] INT                                                IDENTITY (1, 1) NOT NULL,
    [ProfiloProfessionaleId]               INT                                                NOT NULL,
    [TipoIdentificativo]                   NVARCHAR (100)                                     NOT NULL,
    [ValoreIdentificativo]                 NVARCHAR (600)                                     NOT NULL,
    [OrigineSistema]                       NVARCHAR (200)                                     NOT NULL,
    [NormaFamigliaIdOrigine]               INT                                                NULL,
    [NormaEdizioneIdOrigine]               INT                                                NULL,
    [CodiceFamigliaOrigine]                NVARCHAR (200)                                     NULL,
    [SiglaBaseOrigine]                     NVARCHAR (400)                                     NULL,
    [RiferimentoEdizioneOrigine]           NVARCHAR (600)                                     NULL,
    [RiferimentoDesignazioneOrigine]       NVARCHAR (600)                                     NULL,
    [TitoloBaseItaOrigine]                 NVARCHAR (2000)                                    NULL,
    [Note]                                 NVARCHAR (2000)                                    NULL,
    [Attivo]                               BIT                                                CONSTRAINT [DF_ProfiloProfessionaleIdentificativo_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                        DATETIME2 (7)                                      CONSTRAINT [DF_ProfiloProfessionaleIdentificativo_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                             INT                                                NULL,
    [DataModifica]                         DATETIME2 (7)                                      NULL,
    [ModificatoDa]                         INT                                                NULL,
    [DataCancellazione]                    DATETIME2 (7)                                      NULL,
    [CancellatoDa]                         INT                                                NULL,
    [UniqueRowId]                          UNIQUEIDENTIFIER                                   CONSTRAINT [DF_ProfiloProfessionaleIdentificativo_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                   DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]                     DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_ProfiloProfessionaleIdentificativo] PRIMARY KEY CLUSTERED ([ProfiloProfessionaleIdentificativoId] ASC),
    CONSTRAINT [CK_ProfiloProfessionaleIdentificativo_Origine] CHECK (len(ltrim(rtrim([OrigineSistema])))>(0)),
    CONSTRAINT [CK_ProfiloProfessionaleIdentificativo_Tipo] CHECK (len(ltrim(rtrim([TipoIdentificativo])))>(0)),
    CONSTRAINT [CK_ProfiloProfessionaleIdentificativo_Valore] CHECK (len(ltrim(rtrim([ValoreIdentificativo])))>(0)),
    CONSTRAINT [FK_ProfiloProfessionaleIdentificativo_ProfiloProfessionale] FOREIGN KEY ([ProfiloProfessionaleId]) REFERENCES [Certificazione].[ProfiloProfessionale] ([ProfiloProfessionaleId]),
    CONSTRAINT [UQ_ProfiloProfessionaleIdentificativo_TargetTipoValoreOrigine] UNIQUE NONCLUSTERED ([ProfiloProfessionaleId] ASC, [TipoIdentificativo] ASC, [ValoreIdentificativo] ASC, [OrigineSistema] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Certificazione].[ProfiloProfessionaleIdentificativoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE   TRIGGER [Certificazione].[TR_MIG123_Freeze_ProfiloProfessionaleIdentificativo] ON [Certificazione].[ProfiloProfessionaleIdentificativo] AFTER INSERT, UPDATE, DELETE AS
                   BEGIN
                       SET NOCOUNT ON;
                       THROW 62331,
                           'MIG_123: catalogo legacy congelato; usare Standard.',
                           1;
                   END;

GO

EXECUTE sp_addextendedproperty @name = N'Accredia.DecommissionState', @value = N'ARCHIVED_AWAITING_EXTERNAL_APPROVAL', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Deprecated', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.ArchiveTable', @value = N'[ArchiveSIAC].[Legacy_Certificazione_ProfiloProfessionaleIdentificativo]', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"status":"Deprecated","reason":"Catalogo profilo professionale legacy duplicato nel modello canonico Standard","replacement":"Standard.ProfiloProfessionaleIdentificativo","write_policy":"Nessun nuovo consumer o nuovo utilizzo; sola conservazione transitoria","decommission_gate":"Preservare provenienza identificativi, classificare history system-time e verificare consumer esterni prima della rimozione"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativi legacy, import o alternativi associati a un profilo professionale certificabile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo';


GO

