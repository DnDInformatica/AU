CREATE TABLE [Accreditamento].[ScopoDocumento] (
    [ScopoDocumentoId]            INT                                                IDENTITY (1, 1) NOT NULL,
    [ElencoDettaglioFlessibileId] INT                                                NOT NULL,
    [DocumentoVersioneId]         INT                                                NOT NULL,
    [Attivo]                      BIT                                                CONSTRAINT [DF_ScopoDoc_Att] DEFAULT ((1)) NOT NULL,
    [DataCreazione]               DATETIME2 (7)                                      CONSTRAINT [DF_ScopoDoc_DtC] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                    INT                                                NULL,
    [DataModifica]                DATETIME2 (7)                                      NULL,
    [ModificatoDa]                INT                                                NULL,
    [DataCancellazione]           DATETIME2 (7)                                      NULL,
    [CancellatoDa]                INT                                                NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER                                   CONSTRAINT [DF_ScopoDoc_URI] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]          DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]            DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [TipoLegameScopoDocumentoId]  INT                                                NOT NULL,
    CONSTRAINT [PK_ScopoDocumento] PRIMARY KEY CLUSTERED ([ScopoDocumentoId] ASC),
    CONSTRAINT [FK_ScopoDoc_DocVer] FOREIGN KEY ([DocumentoVersioneId]) REFERENCES [Documentale].[DocumentoVersione] ([DocumentoVersioneId]),
    CONSTRAINT [FK_ScopoDoc_Flex] FOREIGN KEY ([ElencoDettaglioFlessibileId]) REFERENCES [Accreditamento].[ElencoDettaglioFlessibile] ([ElencoDettaglioFlessibileId]),
    CONSTRAINT [FK_ScopoDocumento_TipoLegameScopoDocumento] FOREIGN KEY ([TipoLegameScopoDocumentoId]) REFERENCES [Tipologica].[TipoLegameScopoDocumento] ([TipoLegameScopoDocumentoId]),
    CONSTRAINT [UQ_ScopoDoc_Flex_Tipo] UNIQUE NONCLUSTERED ([ElencoDettaglioFlessibileId] ASC, [TipoLegameScopoDocumentoId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Accreditamento].[ScopoDocumentoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_ScopoDocumento_TipoLegameScopoDocumentoId]
    ON [Accreditamento].[ScopoDocumento]([TipoLegameScopoDocumentoId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso la voce di dettaglio dello scopo flessibile. Collega il dato strutturato al documento che lo rappresenta.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ScopoDocumento', @level2type = N'COLUMN', @level2name = N'ElencoDettaglioFlessibileId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di validita del legame documento-scopo. Non identifica da solo la versione corrente pubblicata senza date e stato di pubblicazione.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ScopoDocumento', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine validita business del legame fra voce di scopo e documento.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ScopoDocumento', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso la versione del documento generato o pubblicato. Il documento e una rappresentazione del dato strutturato approvato, non la fonte primaria dello scopo.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ScopoDocumento', @level2type = N'COLUMN', @level2name = N'DocumentoVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata del legame fra voce di scopo e versione documentale.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ScopoDocumento', @level2type = N'COLUMN', @level2name = N'ScopoDocumentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio validita business del legame fra voce di scopo e documento.', @level0type = N'SCHEMA', @level0name = N'Accreditamento', @level1type = N'TABLE', @level1name = N'ScopoDocumento', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

