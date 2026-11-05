CREATE TABLE [Standard].[NormaEdizioneRelazione] (
    [NormaEdizioneRelazioneId] INT                                                IDENTITY (1, 1) NOT NULL,
    [PadreEdizioneId]          INT                                                NOT NULL,
    [FiglioEdizioneId]         INT                                                NOT NULL,
    [Profondita]               INT                                                NOT NULL,
    [TipoRelazioneNormaId]     INT                                                NOT NULL,
    [NoteRelazione]            NVARCHAR (1000)                                    NULL,
    [DataInizioRelazione]      DATE                                               NULL,
    [DataFineRelazione]        DATE                                               NULL,
    [Attivo]                   BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]            DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                 INT                                                NULL,
    [DataModifica]             DATETIME2 (7)                                      NULL,
    [ModificatoDa]             INT                                                NULL,
    [DataCancellazione]        DATETIME2 (7)                                      NULL,
    [CancellatoDa]             INT                                                NULL,
    [UniqueRowId]              UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]         DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_NormaEdizioneRelazione] PRIMARY KEY CLUSTERED ([NormaEdizioneRelazioneId] ASC),
    CONSTRAINT [CK_NormaEdizioneRelazione_Date] CHECK ([DataInizioRelazione] IS NULL OR [DataFineRelazione] IS NULL OR [DataInizioRelazione]<=[DataFineRelazione]),
    CONSTRAINT [CK_NormaEdizioneRelazione_Profondita] CHECK ([Profondita]>=(0)),
    CONSTRAINT [CK_NormaEdizioneRelazione_Self] CHECK ([Profondita]=(0) AND [PadreEdizioneId]=[FiglioEdizioneId] OR [Profondita]>(0) AND [PadreEdizioneId]<>[FiglioEdizioneId]),
    CONSTRAINT [FK_NormaEdizioneRelazione_Figlio] FOREIGN KEY ([FiglioEdizioneId]) REFERENCES [Standard].[NormaEdizione] ([NormaEdizioneId]),
    CONSTRAINT [FK_NormaEdizioneRelazione_Padre] FOREIGN KEY ([PadreEdizioneId]) REFERENCES [Standard].[NormaEdizione] ([NormaEdizioneId]),
    CONSTRAINT [FK_NormaEdizioneRelazione_Tipo] FOREIGN KEY ([TipoRelazioneNormaId]) REFERENCES [Standard].[TipoRelazioneNorma] ([TipoRelazioneNormaId]),
    CONSTRAINT [UQ_NormaEdizioneRelazione_CoppiaTipo] UNIQUE NONCLUSTERED ([PadreEdizioneId] ASC, [FiglioEdizioneId] ASC, [TipoRelazioneNormaId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[NormaEdizioneRelazioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipologia della relazione fra edizioni: sostituisce, sostituita da, emendamento, rettifica, recepimento, corequisito o altra relazione codificata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneRelazione', @level2type = N'COLUMN', @level2name = N'TipoRelazioneNormaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Edizione origine, antenata o sostituita nella relazione. Nelle closure table la self-row ha PadreEdizioneId = FiglioEdizioneId e Profondita = 0.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneRelazione', @level2type = N'COLUMN', @level2name = N'PadreEdizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Relazioni gerarchiche e di successione tra edizioni normative; implementa closure table.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data da cui la relazione normativa e applicabile, se nota. Distinta dalla validita business del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneRelazione', @level2type = N'COLUMN', @level2name = N'DataInizioRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Edizione dipendente, discendente o sostitutiva nella relazione. Usare per ricostruire successioni, sostituzioni e percorsi normativi.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneRelazione', @level2type = N'COLUMN', @level2name = N'FiglioEdizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di fine applicabilita della relazione normativa, se nota.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneRelazione', @level2type = N'COLUMN', @level2name = N'DataFineRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Profondita della relazione nella closure table: 0 per self-row, 1 per relazione diretta, valori maggiori per discendenza transitiva.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneRelazione', @level2type = N'COLUMN', @level2name = N'Profondita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata della relazione gerarchica o successoria fra edizioni normative nel Modello B.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizioneRelazione', @level2type = N'COLUMN', @level2name = N'NormaEdizioneRelazioneId';


GO

