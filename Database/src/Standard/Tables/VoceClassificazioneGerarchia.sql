CREATE TABLE [Standard].[VoceClassificazioneGerarchia] (
    [VoceClassificazioneGerarchiaId] INT                                         IDENTITY (1, 1) NOT NULL,
    [ClassificazioneVersioneId]      INT                                         NOT NULL,
    [ClassificazioneId]              INT                                         NOT NULL,
    [VocePadreId]                    INT                                         NOT NULL,
    [VoceFiglioId]                   INT                                         NOT NULL,
    [GerarchiaRichiesta]             BIT                                         CONSTRAINT [DF_VoceClassificazioneGerarchia_GerarchiaRichiesta] DEFAULT ((1)) NOT NULL,
    [ConsentePiuPadri]               BIT                                         NOT NULL,
    [Note]                           NVARCHAR (2000)                             NULL,
    [Attivo]                         BIT                                         CONSTRAINT [DF_VoceClassificazioneGerarchia_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                  DATETIME2 (7)                               CONSTRAINT [DF_VoceClassificazioneGerarchia_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                       INT                                         NULL,
    [DataModifica]                   DATETIME2 (7)                               NULL,
    [ModificatoDa]                   INT                                         NULL,
    [DataCancellazione]              DATETIME2 (7)                               NULL,
    [CancellatoDa]                   INT                                         NULL,
    [UniqueRowId]                    UNIQUEIDENTIFIER                            CONSTRAINT [DF_VoceClassificazioneGerarchia_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]             DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]               DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_VoceClassificazioneGerarchia] PRIMARY KEY CLUSTERED ([VoceClassificazioneGerarchiaId] ASC),
    CONSTRAINT [CK_VoceClassificazioneGerarchia_Diretta] CHECK ([VocePadreId]<>[VoceFiglioId]),
    CONSTRAINT [CK_VoceClassificazioneGerarchia_Richiesta] CHECK ([GerarchiaRichiesta]=(1)),
    CONSTRAINT [FK_VoceClassificazioneGerarchia_Figlio] FOREIGN KEY ([VoceFiglioId], [ClassificazioneVersioneId], [ClassificazioneId]) REFERENCES [Standard].[VoceClassificazione] ([VoceClassificazioneId], [ClassificazioneVersioneId], [ClassificazioneId]),
    CONSTRAINT [FK_VoceClassificazioneGerarchia_Governance] FOREIGN KEY ([ClassificazioneId], [GerarchiaRichiesta], [ConsentePiuPadri]) REFERENCES [Standard].[ClassificazioneGovernance] ([ClassificazioneId], [ConsenteGerarchia], [ConsentePiuPadri]),
    CONSTRAINT [FK_VoceClassificazioneGerarchia_Padre] FOREIGN KEY ([VocePadreId], [ClassificazioneVersioneId], [ClassificazioneId]) REFERENCES [Standard].[VoceClassificazione] ([VoceClassificazioneId], [ClassificazioneVersioneId], [ClassificazioneId]),
    CONSTRAINT [FK_VoceClassificazioneGerarchia_Versione] FOREIGN KEY ([ClassificazioneVersioneId], [ClassificazioneId]) REFERENCES [Standard].[ClassificazioneVersione] ([ClassificazioneVersioneId], [ClassificazioneId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[VoceClassificazioneGerarchiaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_VoceClassificazioneGerarchia_CreatoDa]
    ON [Standard].[VoceClassificazioneGerarchia]([CreatoDa] ASC);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_VoceClassificazioneGerarchia_FiglioPadreUnico]
    ON [Standard].[VoceClassificazioneGerarchia]([ClassificazioneVersioneId] ASC, [VoceFiglioId] ASC) WHERE ([ConsentePiuPadri]=(0) AND [DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_VoceClassificazioneGerarchia_Padre]
    ON [Standard].[VoceClassificazioneGerarchia]([ClassificazioneVersioneId] ASC, [VocePadreId] ASC)
    INCLUDE([VoceFiglioId], [Attivo]) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_VoceClassificazioneGerarchia_Figlio]
    ON [Standard].[VoceClassificazioneGerarchia]([ClassificazioneVersioneId] ASC, [VoceFiglioId] ASC)
    INCLUDE([VocePadreId], [Attivo]) WHERE ([DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_VoceClassificazioneGerarchia_Arco]
    ON [Standard].[VoceClassificazioneGerarchia]([ClassificazioneVersioneId] ASC, [VocePadreId] ASC, [VoceFiglioId] ASC) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Adjacency list temporal delle sole relazioni gerarchiche dirette fra voci della stessa versione. Fonte di verita della gerarchia.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazioneGerarchia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Voce padre immediata. I self-edge non sono ammessi.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazioneGerarchia', @level2type = N'COLUMN', @level2name = N'VocePadreId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Voce figlia immediata della relazione diretta.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazioneGerarchia', @level2type = N'COLUMN', @level2name = N'VoceFiglioId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Copia governata del flag omonimo; abilita dichiarativamente foreste o DAG.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazioneGerarchia', @level2type = N'COLUMN', @level2name = N'ConsentePiuPadri';


GO

