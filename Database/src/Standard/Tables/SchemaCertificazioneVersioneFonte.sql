CREATE TABLE [Standard].[SchemaCertificazioneVersioneFonte] (
    [SchemaCertificazioneVersioneFonteId] INT                                                IDENTITY (1, 1) NOT NULL,
    [SchemaCertificazioneVersioneId]      INT                                                NOT NULL,
    [FonteLegislativaPartizioneId]        INT                                                NOT NULL,
    [TipoRelazione]                       VARCHAR (30)                                       NOT NULL,
    [Ordine]                              SMALLINT                                           NULL,
    [Note]                                NVARCHAR (2000)                                    NULL,
    [Attivo]                              BIT                                                CONSTRAINT [DF_SchCertVersFonte_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                       DATETIME2 (7)                                      CONSTRAINT [DF_SchCertVersFonte_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                            INT                                                NULL,
    [DataModifica]                        DATETIME2 (7)                                      NULL,
    [ModificatoDa]                        INT                                                NULL,
    [DataCancellazione]                   DATETIME2 (7)                                      NULL,
    [CancellatoDa]                        INT                                                NULL,
    [UniqueRowId]                         UNIQUEIDENTIFIER                                   CONSTRAINT [DF_SchCertVersFonte_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                  DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]                    DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_SchemaCertificazioneVersioneFonte] PRIMARY KEY CLUSTERED ([SchemaCertificazioneVersioneFonteId] ASC),
    CONSTRAINT [CK_SchCertVersFonte_TipoRel] CHECK ([TipoRelazione]='RIFERIMENTO' OR [TipoRelazione]='ATTUAZIONE_DI' OR [TipoRelazione]='DISCIPLINATO_DA'),
    CONSTRAINT [FK_SchCertVersFonte_Partizione] FOREIGN KEY ([FonteLegislativaPartizioneId]) REFERENCES [Standard].[FonteLegislativaPartizione] ([FonteLegislativaPartizioneId]),
    CONSTRAINT [FK_SchCertVersFonte_Versione] FOREIGN KEY ([SchemaCertificazioneVersioneId]) REFERENCES [Standard].[SchemaCertificazioneVersione] ([SchemaCertificazioneVersioneId]),
    CONSTRAINT [UQ_SchCertVersFonte] UNIQUE NONCLUSTERED ([SchemaCertificazioneVersioneId] ASC, [FonteLegislativaPartizioneId] ASC, [TipoRelazione] ASC),
    CONSTRAINT [UQ_SchCertVersFonte_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[SchemaCertificazioneVersioneFonteStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_SchCertVersFonte_Versione]
    ON [Standard].[SchemaCertificazioneVersioneFonte]([SchemaCertificazioneVersioneId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_SchCertVersFonte_Partizione]
    ON [Standard].[SchemaCertificazioneVersioneFonte]([FonteLegislativaPartizioneId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'DISCIPLINATO_DA / ATTUAZIONE_DI / RIFERIMENTO.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneVersioneFonte', @level2type = N'COLUMN', @level2name = N'TipoRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso la partizione della fonte legislativa (es. Direttiva 2014/68/UE, Allegato I, punto 3.1.2).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneVersioneFonte', @level2type = N'COLUMN', @level2name = N'FonteLegislativaPartizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Relazione tra versione di schema e Standard.FonteLegislativaPartizione (base giuridica). Il caso intera fonte usa la partizione canonica FONTE_INTERA. Tipi: DISCIPLINATO_DA (es. Schema Fgas ex DPR 146/2018), ATTUAZIONE_DI, RIFERIMENTO. Media il rapporto norma-legge: decade il ponte diretto NormaEdizione-FonteLegislativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneVersioneFonte';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.SchemaCertificazioneVersione. Identifica la versione di schema disciplinata, attuata o riferita dalla partizione di fonte legislativa collegata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneVersioneFonte', @level2type = N'COLUMN', @level2name = N'SchemaCertificazioneVersioneId';


GO

