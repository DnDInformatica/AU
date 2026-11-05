CREATE TABLE [Standard].[NormaAccreditamentoRelazione] (
    [NormaAccreditamentoRelazioneId] INT                                                IDENTITY (1, 1) NOT NULL,
    [PadreNormaId]                   INT                                                NOT NULL,
    [FiglioNormaId]                  INT                                                NOT NULL,
    [TipoRelazioneNormaId]           INT                                                NOT NULL,
    [Profondita]                     INT                                                CONSTRAINT [DF_NAR_Prof] DEFAULT ((1)) NOT NULL,
    [NoteRelazione]                  NVARCHAR (2000)                                    NULL,
    [DataInizioRelazione]            DATE                                               NULL,
    [DataFineRelazione]              DATE                                               NULL,
    [Attivo]                         BIT                                                CONSTRAINT [DF_NAR_Att] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                  DATETIME2 (7)                                      CONSTRAINT [DF_NAR_DtC] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                       INT                                                NULL,
    [DataModifica]                   DATETIME2 (7)                                      NULL,
    [ModificatoDa]                   INT                                                NULL,
    [DataCancellazione]              DATETIME2 (7)                                      NULL,
    [CancellatoDa]                   INT                                                NULL,
    [UniqueRowId]                    UNIQUEIDENTIFIER                                   CONSTRAINT [DF_NAR_URI] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]             DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]               DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_NormaAccreditamentoRelazione] PRIMARY KEY CLUSTERED ([NormaAccreditamentoRelazioneId] ASC),
    CONSTRAINT [CK_NAR_NoSelf] CHECK ([PadreNormaId]<>[FiglioNormaId]),
    CONSTRAINT [FK_NAR_Figlio] FOREIGN KEY ([FiglioNormaId]) REFERENCES [Standard].[NormaAccreditamento] ([NormaAccreditamentoId]),
    CONSTRAINT [FK_NAR_Padre] FOREIGN KEY ([PadreNormaId]) REFERENCES [Standard].[NormaAccreditamento] ([NormaAccreditamentoId]),
    CONSTRAINT [FK_NAR_Tipo] FOREIGN KEY ([TipoRelazioneNormaId]) REFERENCES [Standard].[TipoRelazioneNorma] ([TipoRelazioneNormaId]),
    CONSTRAINT [UQ_NAR_CoppiaTipo] UNIQUE NONCLUSTERED ([PadreNormaId] ASC, [FiglioNormaId] ASC, [TipoRelazioneNormaId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[NormaAccreditamentoRelazioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Registro semantico point-to-point delle relazioni documentate tra norme (revisione, sostituzione, corequisito), con note, fonti e date. Regola di collocazione: qui vivono i rapporti "B ha una relazione documentata con A" che NON comportano espansione automatica nelle interrogazioni — es. i certificati emessi sotto la norma sostituita non confluiscono nella sostituta (catene F-gas 04.014.*); ISO 14025, co-requisito di ISO/IEC 17065 per lo schema EPD, non entra nei conteggi della 17065. Le identità/varianti denominative che richiedono espansione automatica stanno invece nella Closure Table NormaAccreditamentoGerarchia. Test decisionale: "interrogando la norma A, le righe agganciate a B devono essere incluse automaticamente come se fossero A?" Sì -> Gerarchia; No -> Relazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaAccreditamentoRelazione';


GO

