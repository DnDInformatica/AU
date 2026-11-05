CREATE TABLE [Standard].[OggettoFonteNormativaStorico] (
    [OggettoFonteNormativaId] INT              NOT NULL,
    [OggettoSchema]           NVARCHAR (128)   NOT NULL,
    [OggettoNome]             NVARCHAR (256)   NOT NULL,
    [OggettoColonna]          NVARCHAR (256)   NULL,
    [NormaAccreditamentoId]   INT              NULL,
    [FonteEsterna]            NVARCHAR (300)   NULL,
    [Clausola]                NVARCHAR (100)   NULL,
    [FonteDocumentoCorpus]    NVARCHAR (50)    NULL,
    [FonteDocumentoCodice]    NVARCHAR (100)   NULL,
    [FonteDocumentoId]        INT              NULL,
    [TipoRelazione]           NVARCHAR (30)    NOT NULL,
    [Note]                    NVARCHAR (MAX)   NULL,
    [DataCreazione]           DATETIME2 (7)    NOT NULL,
    [CreatoDa]                INT              NULL,
    [DataModifica]            DATETIME2 (7)    NULL,
    [ModificatoDa]            INT              NULL,
    [DataCancellazione]       DATETIME2 (7)    NULL,
    [CancellatoDa]            INT              NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]      DATETIME2 (7)    NOT NULL,
    [DataFineValidita]        DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_OggettoFonteNormativaStorico]
    ON [Standard].[OggettoFonteNormativaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

CREATE NONCLUSTERED INDEX [IX_OggettoFonteNormativaStorico_Periodo]
    ON [Standard].[OggettoFonteNormativaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC, [OggettoFonteNormativaId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'STORICO', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativaStorico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'governance,tracciabilita,fonte-normativa,requisiti,storico,temporal', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativaStorico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativaStorico';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tabella di storico tecnico system-versioned associata a Standard.OggettoFonteNormativa. Le righe sono mantenute automaticamente da SQL Server.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'OggettoFonteNormativaStorico';


GO

