CREATE TABLE [Standard].[VoceClassificazione] (
    [VoceClassificazioneId]     INT                                         IDENTITY (1, 1) NOT NULL,
    [ClassificazioneVersioneId] INT                                         NOT NULL,
    [ClassificazioneId]         INT                                         NOT NULL,
    [Codice]                    NVARCHAR (100)                              NOT NULL,
    [Denominazione]             NVARCHAR (1000)                             NOT NULL,
    [DescrizioneEstesa]         NVARCHAR (2000)                             NULL,
    [TipoVoce]                  NVARCHAR (30)                               CONSTRAINT [DF_VoceClassificazione_TipoVoce] DEFAULT (N'Canonica') NOT NULL,
    [Livello]                   SMALLINT                                    CONSTRAINT [DF_VoceClassificazione_Livello] DEFAULT ((1)) NOT NULL,
    [Ordine]                    INT                                         NOT NULL,
    [IdentificatoreEsterno]     NVARCHAR (200)                              NULL,
    [UriIdentificatore]         NVARCHAR (1000)                             NULL,
    [Note]                      NVARCHAR (2000)                             NULL,
    [VoceTecnicaRichiesta]      BIT                                         NULL,
    [Attivo]                    BIT                                         CONSTRAINT [DF_VoceClassificazione_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]             DATETIME2 (7)                               CONSTRAINT [DF_VoceClassificazione_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                  INT                                         NULL,
    [DataModifica]              DATETIME2 (7)                               NULL,
    [ModificatoDa]              INT                                         NULL,
    [DataCancellazione]         DATETIME2 (7)                               NULL,
    [CancellatoDa]              INT                                         NULL,
    [UniqueRowId]               UNIQUEIDENTIFIER                            CONSTRAINT [DF_VoceClassificazione_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_VoceClassificazione] PRIMARY KEY CLUSTERED ([VoceClassificazioneId] ASC),
    CONSTRAINT [CK_VoceClassificazione_Codice] CHECK (len(ltrim(rtrim([Codice])))>(0)),
    CONSTRAINT [CK_VoceClassificazione_Denominazione] CHECK (len(ltrim(rtrim([Denominazione])))>(0)),
    CONSTRAINT [CK_VoceClassificazione_GateVoceTecnica] CHECK ([TipoVoce]=N'Tecnica' AND [VoceTecnicaRichiesta]=(1) OR [TipoVoce]<>N'Tecnica' AND [VoceTecnicaRichiesta] IS NULL),
    CONSTRAINT [CK_VoceClassificazione_Identificatore] CHECK (([IdentificatoreEsterno] IS NULL OR len(ltrim(rtrim([IdentificatoreEsterno])))>(0)) AND ([UriIdentificatore] IS NULL OR [IdentificatoreEsterno] IS NOT NULL AND len(ltrim(rtrim([UriIdentificatore])))>(0))),
    CONSTRAINT [CK_VoceClassificazione_Livello] CHECK ([Livello]>=(0)),
    CONSTRAINT [CK_VoceClassificazione_Ordine] CHECK ([Ordine]>=(0)),
    CONSTRAINT [CK_VoceClassificazione_TipoVoce] CHECK ([TipoVoce]=N'Sentinella' OR [TipoVoce]=N'Raggruppamento' OR [TipoVoce]=N'Tecnica' OR [TipoVoce]=N'Canonica'),
    CONSTRAINT [FK_VoceClassificazione_GovernanceVoceTecnica] FOREIGN KEY ([ClassificazioneId], [VoceTecnicaRichiesta]) REFERENCES [Standard].[ClassificazioneGovernance] ([ClassificazioneId], [ConsenteVoceTecnica]),
    CONSTRAINT [FK_VoceClassificazione_Versione] FOREIGN KEY ([ClassificazioneVersioneId], [ClassificazioneId]) REFERENCES [Standard].[ClassificazioneVersione] ([ClassificazioneVersioneId], [ClassificazioneId]),
    CONSTRAINT [UQ_VoceClassificazione_IdVersioneClassificazione] UNIQUE NONCLUSTERED ([VoceClassificazioneId] ASC, [ClassificazioneVersioneId] ASC, [ClassificazioneId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[VoceClassificazioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_VoceClassificazione_DataCancellazione]
    ON [Standard].[VoceClassificazione]([DataCancellazione] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_VoceClassificazione_Versione_Codice]
    ON [Standard].[VoceClassificazione]([ClassificazioneVersioneId] ASC, [Codice] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_VoceClassificazione_CreatoDa]
    ON [Standard].[VoceClassificazione]([CreatoDa] ASC);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_VoceClassificazione_Versione_IdEsterno]
    ON [Standard].[VoceClassificazione]([ClassificazioneVersioneId] ASC, [IdentificatoreEsterno] ASC) WHERE ([IdentificatoreEsterno] IS NOT NULL AND [DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_VoceClassificazione_Ordinamento]
    ON [Standard].[VoceClassificazione]([ClassificazioneVersioneId] ASC, [Livello] ASC, [Ordine] ASC)
    INCLUDE([Codice], [Denominazione], [TipoVoce], [Attivo]) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_VoceClassificazione_Classificazione]
    ON [Standard].[VoceClassificazione]([ClassificazioneId] ASC, [ClassificazioneVersioneId] ASC)
    INCLUDE([Codice], [TipoVoce], [Attivo]) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine del periodo di validita di sistema gestito da Azure SQL temporal.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ordine stabile di presentazione all interno della versione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'Ordine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Parte della FK composta verso la versione cui appartiene la voce.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'ClassificazioneVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo applicativo del soggetto che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore assegnato da un registro esterno, valorizzato solo quando effettivamente pubblicato.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'IdentificatoreEsterno';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell ultima modifica applicativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ridondanza controllata usata per garantire la coerenza con la versione e applicare i gate dichiarativi della governance.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'ClassificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Catalogo generico e temporalmente versionato delle voci appartenenti a una specifica versione di classificazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore GUID stabile del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di attivazione logica della voce, indipendente dalla validita temporale e dall applicabilita della versione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ruolo della voce: Canonica, Tecnica, Raggruppamento o Sentinella.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'TipoVoce';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore surrogato della voce di classificazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'VoceClassificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Livello convenzionale della voce nella classificazione; non sostituisce la relazione gerarchica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'Livello';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio del periodo di validita di sistema gestito da Azure SQL temporal.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Denominazione ufficiale della voce nella lingua della fonte canonica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo applicativo del soggetto che ha cancellato logicamente il record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Colonna tecnica nullable usata dalla FK composta: vale 1 solo per TipoVoce Tecnica e richiede ConsenteVoceTecnica=1.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'VoceTecnicaRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione ufficiale o esplicativa distinta dalla denominazione breve.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'DescrizioneEstesa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'URI risolvibile dell identificatore esterno; richiede IdentificatoreEsterno valorizzato.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'UriIdentificatore';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo applicativo del soggetto che ha modificato il record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice ufficiale della voce nel contesto della versione; e univoco tra le righe non cancellate della stessa versione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC della cancellazione logica; NULL identifica la riga corrente non cancellata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Annotazioni motivate sulla singola voce; non deve contenere corrispondenze strutturate verso altre classificazioni.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'VoceClassificazione', @level2type = N'COLUMN', @level2name = N'Note';


GO

