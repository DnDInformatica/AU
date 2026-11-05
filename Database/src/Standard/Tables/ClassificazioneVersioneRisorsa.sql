CREATE TABLE [Standard].[ClassificazioneVersioneRisorsa] (
    [ClassificazioneVersioneRisorsaId] INT                                         IDENTITY (1, 1) NOT NULL,
    [ClassificazioneVersioneId]        INT                                         NOT NULL,
    [ClassificazioneId]                INT                                         NOT NULL,
    [SoggettoFonteId]                  INT                                         NOT NULL,
    [TipoRisorsa]                      NVARCHAR (40)                               NOT NULL,
    [VersioneRisorsa]                  NVARCHAR (50)                               NULL,
    [Formato]                          NVARCHAR (100)                              NOT NULL,
    [Lingua]                           NVARCHAR (10)                               NULL,
    [UriRisorsa]                       NVARCHAR (1000)                             NOT NULL,
    [UrlAccesso]                       NVARCHAR (1000)                             NOT NULL,
    [EndpointAccesso]                  NVARCHAR (1000)                             NULL,
    [RepositoryFonte]                  NVARCHAR (200)                              NULL,
    [DataAcquisizione]                 DATETIME2 (7)                               NOT NULL,
    [HashSHA256]                       CHAR (64)                                   NOT NULL,
    [NumeroVoci]                       INT                                         NOT NULL,
    [Note]                             NVARCHAR (2000)                             NULL,
    [Attivo]                           BIT                                         CONSTRAINT [DF_ClassificazioneVersioneRisorsa_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                    DATETIME2 (7)                               CONSTRAINT [DF_ClassificazioneVersioneRisorsa_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                         INT                                         NULL,
    [DataModifica]                     DATETIME2 (7)                               NULL,
    [ModificatoDa]                     INT                                         NULL,
    [DataCancellazione]                DATETIME2 (7)                               NULL,
    [CancellatoDa]                     INT                                         NULL,
    [UniqueRowId]                      UNIQUEIDENTIFIER                            CONSTRAINT [DF_ClassificazioneVersioneRisorsa_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]               DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]                 DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_ClassificazioneVersioneRisorsa] PRIMARY KEY CLUSTERED ([ClassificazioneVersioneRisorsaId] ASC),
    CONSTRAINT [CK_ClassificazioneVersioneRisorsa_Hash] CHECK (len([HashSHA256])=(64) AND NOT [HashSHA256] like '%[^0-9a-f]%'),
    CONSTRAINT [CK_ClassificazioneVersioneRisorsa_NumeroVoci] CHECK ([NumeroVoci]>=(0)),
    CONSTRAINT [CK_ClassificazioneVersioneRisorsa_Tipo] CHECK ([TipoRisorsa]=N'API' OR [TipoRisorsa]=N'DATASET_TABELLARE' OR [TipoRisorsa]=N'CODELIST' OR [TipoRisorsa]=N'CONCEPT_SCHEME_SKOS'),
    CONSTRAINT [CK_ClassificazioneVersioneRisorsa_Uri] CHECK (len(ltrim(rtrim([UriRisorsa])))>(0) AND len(ltrim(rtrim([UrlAccesso])))>(0)),
    CONSTRAINT [FK_ClassificazioneVersioneRisorsa_SoggettoFonte] FOREIGN KEY ([SoggettoFonteId]) REFERENCES [Standard].[SoggettoFonte] ([SoggettoFonteId]),
    CONSTRAINT [FK_ClassificazioneVersioneRisorsa_Versione] FOREIGN KEY ([ClassificazioneVersioneId], [ClassificazioneId]) REFERENCES [Standard].[ClassificazioneVersione] ([ClassificazioneVersioneId], [ClassificazioneId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[ClassificazioneVersioneRisorsaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_ClassificazioneVersioneRisorsa_Fonte]
    ON [Standard].[ClassificazioneVersioneRisorsa]([SoggettoFonteId] ASC, [ClassificazioneVersioneId] ASC)
    INCLUDE([TipoRisorsa], [Formato], [Lingua], [Attivo]) WHERE ([DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ClassificazioneVersioneRisorsa_TipoLingua]
    ON [Standard].[ClassificazioneVersioneRisorsa]([ClassificazioneVersioneId] ASC, [TipoRisorsa] ASC, [Lingua] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ClassificazioneVersioneRisorsa_Uri]
    ON [Standard].[ClassificazioneVersioneRisorsa]([ClassificazioneVersioneId] ASC, [UriRisorsa] ASC) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'URI persistente che identifica la risorsa o il concept scheme.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRisorsa', @level2type = N'COLUMN', @level2name = N'UriRisorsa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Versione dichiarata dal repository per la risorsa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRisorsa', @level2type = N'COLUMN', @level2name = N'VersioneRisorsa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Lingua delle etichette acquisite dalla risorsa, se applicabile.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRisorsa', @level2type = N'COLUMN', @level2name = N'Lingua';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipologia tecnica controllata della risorsa machine-readable.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRisorsa', @level2type = N'COLUMN', @level2name = N'TipoRisorsa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero di voci presenti nello snapshot acquisito.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRisorsa', @level2type = N'COLUMN', @level2name = N'NumeroVoci';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Denominazione del repository ufficiale che pubblica la risorsa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRisorsa', @level2type = N'COLUMN', @level2name = N'RepositoryFonte';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Versione della classificazione resa disponibile dalla risorsa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRisorsa', @level2type = N'COLUMN', @level2name = N'ClassificazioneVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Hash SHA-256 esadecimale del contenuto normalizzato descritto nelle note.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRisorsa', @level2type = N'COLUMN', @level2name = N'HashSHA256';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Soggetto responsabile o custode della fonte dati ufficiale.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRisorsa', @level2type = N'COLUMN', @level2name = N'SoggettoFonteId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Risorsa ufficiale machine-readable che realizza una versione di classificazione. Distinta dai riferimenti normativi e documentali.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRisorsa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Endpoint machine-to-machine usato per acquisire il contenuto.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRisorsa', @level2type = N'COLUMN', @level2name = N'EndpointAccesso';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante UTC in cui e stato acquisito lo snapshot normalizzato.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRisorsa', @level2type = N'COLUMN', @level2name = N'DataAcquisizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Classificazione ripetuta per garantire con FK composta la coerenza con la versione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRisorsa', @level2type = N'COLUMN', @level2name = N'ClassificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Pagina ufficiale di accesso o consultazione della risorsa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRisorsa', @level2type = N'COLUMN', @level2name = N'UrlAccesso';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Formato o modello di rappresentazione della risorsa, ad esempio SKOS/RDF.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneRisorsa', @level2type = N'COLUMN', @level2name = N'Formato';


GO

