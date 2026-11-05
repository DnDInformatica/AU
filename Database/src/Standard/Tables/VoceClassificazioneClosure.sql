CREATE TABLE [Standard].[VoceClassificazioneClosure] (
    [ClassificazioneVersioneId] INT           NOT NULL,
    [ClassificazioneId]         INT           NOT NULL,
    [VoceAntenatoId]            INT           NOT NULL,
    [VoceDiscendenteId]         INT           NOT NULL,
    [Profondita]                INT           NOT NULL,
    [DataCalcolo]               DATETIME2 (7) CONSTRAINT [DF_VoceClassificazioneClosure_DataCalcolo] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_VoceClassificazioneClosure] PRIMARY KEY CLUSTERED ([ClassificazioneVersioneId] ASC, [VoceAntenatoId] ASC, [VoceDiscendenteId] ASC),
    CONSTRAINT [CK_VoceClassificazioneClosure_Profondita] CHECK ([VoceAntenatoId]=[VoceDiscendenteId] AND [Profondita]=(0) OR [VoceAntenatoId]<>[VoceDiscendenteId] AND [Profondita]>(0)),
    CONSTRAINT [FK_VoceClassificazioneClosure_Antenato] FOREIGN KEY ([VoceAntenatoId], [ClassificazioneVersioneId], [ClassificazioneId]) REFERENCES [Standard].[VoceClassificazione] ([VoceClassificazioneId], [ClassificazioneVersioneId], [ClassificazioneId]),
    CONSTRAINT [FK_VoceClassificazioneClosure_Discendente] FOREIGN KEY ([VoceDiscendenteId], [ClassificazioneVersioneId], [ClassificazioneId]) REFERENCES [Standard].[VoceClassificazione] ([VoceClassificazioneId], [ClassificazioneVersioneId], [ClassificazioneId]),
    CONSTRAINT [FK_VoceClassificazioneClosure_Versione] FOREIGN KEY ([ClassificazioneVersioneId], [ClassificazioneId]) REFERENCES [Standard].[ClassificazioneVersione] ([ClassificazioneVersioneId], [ClassificazioneId])
);


GO

CREATE NONCLUSTERED INDEX [IX_VoceClassificazioneClosure_Discendente]
    ON [Standard].[VoceClassificazioneClosure]([ClassificazioneVersioneId] ASC, [VoceDiscendenteId] ASC, [Profondita] ASC)
    INCLUDE([VoceAntenatoId], [ClassificazioneId]);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Read model derivato con self-pair e chiusura transitiva delle gerarchie delle classificazioni. Non e fonte di verita.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazioneClosure';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante UTC della ricostruzione transazionale della closure.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazioneClosure', @level2type = N'COLUMN', @level2name = N'DataCalcolo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Distanza minima tra antenato e discendente; zero esclusivamente per il self-pair.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazioneClosure', @level2type = N'COLUMN', @level2name = N'Profondita';


GO

