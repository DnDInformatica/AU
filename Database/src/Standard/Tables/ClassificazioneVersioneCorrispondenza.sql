CREATE TABLE [Standard].[ClassificazioneVersioneCorrispondenza] (
    [ClassificazioneVersioneCorrispondenzaId] INT                                         IDENTITY (1, 1) NOT NULL,
    [Codice]                                  NVARCHAR (150)                              NOT NULL,
    [ClassificazioneVersioneOrigineId]        INT                                         NOT NULL,
    [ClassificazioneOrigineId]                INT                                         NOT NULL,
    [ClassificazioneVersioneDestinazioneId]   INT                                         NOT NULL,
    [ClassificazioneDestinazioneId]           INT                                         NOT NULL,
    [RiferimentoDocumentaleId]                INT                                         NOT NULL,
    [TipoCorrispondenza]                      NVARCHAR (40)                               NOT NULL,
    [DataDecorrenza]                          DATE                                        NULL,
    [RiferimentoPuntuale]                     NVARCHAR (300)                              NULL,
    [Descrizione]                             NVARCHAR (1000)                             NULL,
    [ConsenteSovrapposizioni]                 BIT                                         CONSTRAINT [DF_ClassVersCorr_ConsenteSovrapposizioni] DEFAULT ((1)) NOT NULL,
    [NumeroRegoleAtteso]                      INT                                         NULL,
    [NumeroTerminiAtteso]                     INT                                         NULL,
    [NumeroAssociazioniEffettiveAtteso]       INT                                         NULL,
    [HashRegoleSHA256]                        CHAR (64)                                   NULL,
    [HashAssociazioniEffettiveSHA256]         CHAR (64)                                   NULL,
    [CorrispondenzeOrigineRichieste]          BIT                                         CONSTRAINT [DF_ClassVersCorr_OrigineRichiesta] DEFAULT ((1)) NOT NULL,
    [CorrispondenzeDestinazioneRichieste]     BIT                                         CONSTRAINT [DF_ClassVersCorr_DestinazioneRichiesta] DEFAULT ((1)) NOT NULL,
    [Note]                                    NVARCHAR (2000)                             NULL,
    [Attivo]                                  BIT                                         CONSTRAINT [DF_ClassificazioneVersioneCorrispondenza_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                           DATETIME2 (7)                               CONSTRAINT [DF_ClassificazioneVersioneCorrispondenza_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                                INT                                         NULL,
    [DataModifica]                            DATETIME2 (7)                               NULL,
    [ModificatoDa]                            INT                                         NULL,
    [DataCancellazione]                       DATETIME2 (7)                               NULL,
    [CancellatoDa]                            INT                                         NULL,
    [UniqueRowId]                             UNIQUEIDENTIFIER                            CONSTRAINT [DF_ClassificazioneVersioneCorrispondenza_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                      DATETIME2 (7) GENERATED ALWAYS AS ROW START CONSTRAINT [DF_ClassVersCorr_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]                        DATETIME2 (7) GENERATED ALWAYS AS ROW END   CONSTRAINT [DF_ClassVersCorr_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_ClassificazioneVersioneCorrispondenza] PRIMARY KEY CLUSTERED ([ClassificazioneVersioneCorrispondenzaId] ASC),
    CONSTRAINT [CK_ClassVersCorr_Codice] CHECK (len(ltrim(rtrim([Codice])))>(0)),
    CONSTRAINT [CK_ClassVersCorr_Conteggi] CHECK (([NumeroRegoleAtteso] IS NULL OR [NumeroRegoleAtteso]>=(0)) AND ([NumeroTerminiAtteso] IS NULL OR [NumeroTerminiAtteso]>=(0)) AND ([NumeroAssociazioniEffettiveAtteso] IS NULL OR [NumeroAssociazioniEffettiveAtteso]>=(0))),
    CONSTRAINT [CK_ClassVersCorr_Gate] CHECK ([CorrispondenzeOrigineRichieste]=(1) AND [CorrispondenzeDestinazioneRichieste]=(1)),
    CONSTRAINT [CK_ClassVersCorr_HashEffettivo] CHECK ([HashAssociazioniEffettiveSHA256] IS NULL OR len([HashAssociazioniEffettiveSHA256])=(64) AND NOT [HashAssociazioniEffettiveSHA256] like '%[^0-9a-f]%'),
    CONSTRAINT [CK_ClassVersCorr_HashRegole] CHECK ([HashRegoleSHA256] IS NULL OR len([HashRegoleSHA256])=(64) AND NOT [HashRegoleSHA256] like '%[^0-9a-f]%'),
    CONSTRAINT [CK_ClassVersCorr_Tipo] CHECK ([TipoCorrispondenza]=N'RICONCILIAZIONE_OPERATIVA' OR [TipoCorrispondenza]=N'EQUIVALENZA' OR [TipoCorrispondenza]=N'TAVOLA_CORRISPONDENZA' OR [TipoCorrispondenza]=N'MAPPATURA_NORMATIVA'),
    CONSTRAINT [CK_ClassVersCorr_VersioniDistinte] CHECK ([ClassificazioneVersioneOrigineId]<>[ClassificazioneVersioneDestinazioneId]),
    CONSTRAINT [FK_ClassVersCorr_GovernanceDestinazione] FOREIGN KEY ([ClassificazioneDestinazioneId], [CorrispondenzeDestinazioneRichieste]) REFERENCES [Standard].[ClassificazioneGovernance] ([ClassificazioneId], [ConsenteCorrispondenze]),
    CONSTRAINT [FK_ClassVersCorr_GovernanceOrigine] FOREIGN KEY ([ClassificazioneOrigineId], [CorrispondenzeOrigineRichieste]) REFERENCES [Standard].[ClassificazioneGovernance] ([ClassificazioneId], [ConsenteCorrispondenze]),
    CONSTRAINT [FK_ClassVersCorr_RiferimentoDocumentale] FOREIGN KEY ([RiferimentoDocumentaleId]) REFERENCES [Standard].[RiferimentoDocumentale] ([RiferimentoDocumentaleId]),
    CONSTRAINT [FK_ClassVersCorr_VersioneDestinazione] FOREIGN KEY ([ClassificazioneVersioneDestinazioneId], [ClassificazioneDestinazioneId]) REFERENCES [Standard].[ClassificazioneVersione] ([ClassificazioneVersioneId], [ClassificazioneId]),
    CONSTRAINT [FK_ClassVersCorr_VersioneOrigine] FOREIGN KEY ([ClassificazioneVersioneOrigineId], [ClassificazioneOrigineId]) REFERENCES [Standard].[ClassificazioneVersione] ([ClassificazioneVersioneId], [ClassificazioneId]),
    CONSTRAINT [UQ_ClassVersCorr_IdContesto] UNIQUE NONCLUSTERED ([ClassificazioneVersioneCorrispondenzaId] ASC, [ClassificazioneVersioneOrigineId] ASC, [ClassificazioneOrigineId] ASC, [ClassificazioneVersioneDestinazioneId] ASC, [ClassificazioneDestinazioneId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[ClassificazioneVersioneCorrispondenzaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ClassVersCorr_Codice]
    ON [Standard].[ClassificazioneVersioneCorrispondenza]([Codice] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ClassVersCorr_Direzione]
    ON [Standard].[ClassificazioneVersioneCorrispondenza]([ClassificazioneVersioneOrigineId] ASC, [ClassificazioneVersioneDestinazioneId] ASC)
    INCLUDE([Codice], [TipoCorrispondenza], [RiferimentoDocumentaleId], [Attivo]) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Hash SHA-256 delle coppie effettive dopo espansione ed esclusioni.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneCorrispondenza', @level2type = N'COLUMN', @level2name = N'HashAssociazioniEffettiveSHA256';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Hash SHA-256 dei termini espliciti normalizzati estratti dalla fonte.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneCorrispondenza', @level2type = N'COLUMN', @level2name = N'HashRegoleSHA256';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se una voce destinazione puo risultare associata a piu voci origine nella stessa corrispondenza.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneCorrispondenza', @level2type = N'COLUMN', @level2name = N'ConsenteSovrapposizioni';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine UTC del periodo di validita di sistema gestito da Azure SQL temporal.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneCorrispondenza', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Header direzionale e documentato di una corrispondenza fra due versioni di classificazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneCorrispondenza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio UTC del periodo di validita di sistema gestito da Azure SQL temporal.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazioneVersioneCorrispondenza', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

