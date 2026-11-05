CREATE TABLE [Standard].[SchemaCertificazioneDocumento] (
    [SchemaCertificazioneDocumentoId] INT                                                IDENTITY (1, 1) NOT NULL,
    [SchemaCertificazioneVersioneId]  INT                                                NOT NULL,
    [CodiceDocumento]                 NVARCHAR (200)                                     NOT NULL,
    [Titolo]                          NVARCHAR (1000)                                    NOT NULL,
    [UrlDocumento]                    NVARCHAR (2000)                                    NULL,
    [Note]                            NVARCHAR (4000)                                    NULL,
    [Attivo]                          BIT                                                CONSTRAINT [DF_SchCertDocumento_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                   DATETIME2 (7)                                      CONSTRAINT [DF_SchCertDocumento_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                        INT                                                NULL,
    [DataModifica]                    DATETIME2 (7)                                      NULL,
    [ModificatoDa]                    INT                                                NULL,
    [DataCancellazione]               DATETIME2 (7)                                      NULL,
    [CancellatoDa]                    INT                                                NULL,
    [UniqueRowId]                     UNIQUEIDENTIFIER                                   CONSTRAINT [DF_SchCertDocumento_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]              DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]                DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [TipoDocumentoId]                 INT                                                NOT NULL,
    CONSTRAINT [PK_SchemaCertificazioneDocumento] PRIMARY KEY CLUSTERED ([SchemaCertificazioneDocumentoId] ASC),
    CONSTRAINT [FK_SchCertDocumento_TipoDocumento] FOREIGN KEY ([TipoDocumentoId]) REFERENCES [Standard].[TipoDocumento] ([TipoDocumentoId]),
    CONSTRAINT [FK_SchCertDocumento_Versione] FOREIGN KEY ([SchemaCertificazioneVersioneId]) REFERENCES [Standard].[SchemaCertificazioneVersione] ([SchemaCertificazioneVersioneId]),
    CONSTRAINT [UQ_SchCertDocumento_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    CONSTRAINT [UQ_SchCertDocumento_Versione_Codice] UNIQUE NONCLUSTERED ([SchemaCertificazioneVersioneId] ASC, [CodiceDocumento] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[SchemaCertificazioneDocumentoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_SchCertDocumento_Versione]
    ON [Standard].[SchemaCertificazioneDocumento]([SchemaCertificazioneVersioneId] ASC)
    INCLUDE([CodiceDocumento], [TipoDocumentoId], [Attivo]);


GO

CREATE NONCLUSTERED INDEX [IX_SchCertDocumento_TipoDocumentoId]
    ON [Standard].[SchemaCertificazioneDocumento]([TipoDocumentoId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Documenti ufficiali che definiscono il contenuto della versione di schema (ISO/IEC 17067 par.6.3.7: the scheme owner should document the content of the scheme).', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneDocumento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.TipoDocumento: tipologia normalizzata del documento (REGOLAMENTO_SCHEMA/REQUISITI/GUIDA/LISTA_PARTI/ALTRO). Sostituisce il precedente TipoDocumento varchar con CHECK inline.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneDocumento', @level2type = N'COLUMN', @level2name = N'TipoDocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso la versione di schema documentata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneDocumento', @level2type = N'COLUMN', @level2name = N'SchemaCertificazioneVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice o riferimento univoco del documento ufficiale nel perimetro della versione di schema.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'SchemaCertificazioneDocumento', @level2type = N'COLUMN', @level2name = N'CodiceDocumento';


GO

