CREATE TABLE [Standard].[SchemaCertificazioneVersioneNorma] (
    [SchemaCertificazioneVersioneNormaId] INT                                                IDENTITY (1, 1) NOT NULL,
    [SchemaCertificazioneVersioneId]      INT                                                NOT NULL,
    [NormaEdizioneId]                     INT                                                NOT NULL,
    [TipoRelazione]                       VARCHAR (30)                                       NOT NULL,
    [Ordine]                              SMALLINT                                           NULL,
    [Note]                                NVARCHAR (2000)                                    NULL,
    [Attivo]                              BIT                                                CONSTRAINT [DF_SchCertVersNorma_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                       DATETIME2 (7)                                      CONSTRAINT [DF_SchCertVersNorma_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                            INT                                                NULL,
    [DataModifica]                        DATETIME2 (7)                                      NULL,
    [ModificatoDa]                        INT                                                NULL,
    [DataCancellazione]                   DATETIME2 (7)                                      NULL,
    [CancellatoDa]                        INT                                                NULL,
    [UniqueRowId]                         UNIQUEIDENTIFIER                                   CONSTRAINT [DF_SchCertVersNorma_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                  DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]                    DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_SchemaCertificazioneVersioneNorma] PRIMARY KEY CLUSTERED ([SchemaCertificazioneVersioneNormaId] ASC),
    CONSTRAINT [CK_SchCertVersNorma_TipoRel] CHECK ([TipoRelazione]='RIFERIMENTO' OR [TipoRelazione]='INTEGRA' OR [TipoRelazione]='RICHIEDE' OR [TipoRelazione]='BASATO_SU'),
    CONSTRAINT [FK_SchCertVersNorma_NormaEdizione] FOREIGN KEY ([NormaEdizioneId]) REFERENCES [Standard].[NormaEdizione] ([NormaEdizioneId]),
    CONSTRAINT [FK_SchCertVersNorma_Versione] FOREIGN KEY ([SchemaCertificazioneVersioneId]) REFERENCES [Standard].[SchemaCertificazioneVersione] ([SchemaCertificazioneVersioneId]),
    CONSTRAINT [UQ_SchCertVersNorma] UNIQUE NONCLUSTERED ([SchemaCertificazioneVersioneId] ASC, [NormaEdizioneId] ASC, [TipoRelazione] ASC),
    CONSTRAINT [UQ_SchCertVersNorma_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[SchemaCertificazioneVersioneNormaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_SchCertVersNorma_NormaEdizione]
    ON [Standard].[SchemaCertificazioneVersioneNorma]([NormaEdizioneId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_SchCertVersNorma_Versione]
    ON [Standard].[SchemaCertificazioneVersioneNorma]([SchemaCertificazioneVersioneId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Relazione tra versione di schema e Standard.NormaEdizione (componente normativa). Tipi: BASATO_SU (es. FSSC su ISO 22000), RICHIEDE (prerequisito), INTEGRA, RIFERIMENTO.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneVersioneNorma';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso l''edizione di norma tecnica del Modello B.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneVersioneNorma', @level2type = N'COLUMN', @level2name = N'NormaEdizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'BASATO_SU / RICHIEDE / INTEGRA / RIFERIMENTO.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneVersioneNorma', @level2type = N'COLUMN', @level2name = N'TipoRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.SchemaCertificazioneVersione. Identifica la versione di schema che richiama, richiede, integra o si basa sulla norma tecnica collegata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneVersioneNorma', @level2type = N'COLUMN', @level2name = N'SchemaCertificazioneVersioneId';


GO

