CREATE TABLE [Standard].[ProfiloTecnicoProgramma] (
    [ProfiloTecnicoProgrammaId]         INT                                                IDENTITY (1, 1) NOT NULL,
    [ProgrammaCertificazioneVersioneId] INT                                                NOT NULL,
    [CodiceSpecificaTecnica]            NVARCHAR (50)                                      NOT NULL,
    [Codice]                            NVARCHAR (100)                                     NOT NULL,
    [DescrizioneIta]                    NVARCHAR (2000)                                    NOT NULL,
    [Ordinale]                          SMALLINT                                           NOT NULL,
    [StatoQualificazione]               NVARCHAR (30)                                      NOT NULL,
    [OrigineSistema]                    NVARCHAR (200)                                     NOT NULL,
    [RiferimentoOrigine]                NVARCHAR (500)                                     NULL,
    [Attivo]                            BIT                                                CONSTRAINT [DF_ProfiloTecnicoProgramma_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                     DATETIME2 (7)                                      CONSTRAINT [DF_ProfiloTecnicoProgramma_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                          INT                                                NULL,
    [DataModifica]                      DATETIME2 (7)                                      NULL,
    [ModificatoDa]                      INT                                                NULL,
    [DataCancellazione]                 DATETIME2 (7)                                      NULL,
    [CancellatoDa]                      INT                                                NULL,
    [UniqueRowId]                       UNIQUEIDENTIFIER                                   CONSTRAINT [DF_ProfiloTecnicoProgramma_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_ProfiloTecnicoProgramma_ValiditaInizio] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]                  DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_ProfiloTecnicoProgramma_ValiditaFine] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    [DescrizioneEng]                    NVARCHAR (2000)                                    NULL,
    CONSTRAINT [PK_ProfiloTecnicoProgramma] PRIMARY KEY CLUSTERED ([ProfiloTecnicoProgrammaId] ASC),
    CONSTRAINT [CK_ProfiloTecnicoProgramma_Cancellazione] CHECK ([DataCancellazione] IS NULL AND [CancellatoDa] IS NULL OR [DataCancellazione] IS NOT NULL),
    CONSTRAINT [CK_ProfiloTecnicoProgramma_Codice] CHECK (len(ltrim(rtrim([Codice])))>(0)),
    CONSTRAINT [CK_ProfiloTecnicoProgramma_Descrizione] CHECK (len(ltrim(rtrim([DescrizioneIta])))>(0)),
    CONSTRAINT [CK_ProfiloTecnicoProgramma_DescrizioneEng] CHECK ([DescrizioneEng] IS NULL OR len(ltrim(rtrim([DescrizioneEng])))>(0)),
    CONSTRAINT [CK_ProfiloTecnicoProgramma_Ordinale] CHECK ([Ordinale]>(0)),
    CONSTRAINT [CK_ProfiloTecnicoProgramma_Origine] CHECK (len(ltrim(rtrim([OrigineSistema])))>(0)),
    CONSTRAINT [CK_ProfiloTecnicoProgramma_Qualificazione] CHECK ([StatoQualificazione]=N'LEGACY_DA_QUALIFICARE' OR [StatoQualificazione]=N'DOCUMENTATO'),
    CONSTRAINT [CK_ProfiloTecnicoProgramma_Specifica] CHECK (len(ltrim(rtrim([CodiceSpecificaTecnica])))>(0)),
    CONSTRAINT [FK_ProfiloTecnicoProgramma_ProgrammaVersione] FOREIGN KEY ([ProgrammaCertificazioneVersioneId]) REFERENCES [Certificazione].[ProgrammaCertificazioneVersione] ([ProgrammaCertificazioneVersioneId]),
    CONSTRAINT [UQ_ProfiloTecnicoProgramma_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[ProfiloTecnicoProgrammaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ProfiloTecnicoProgramma_ProgrammaVersione_Codice]
    ON [Standard].[ProfiloTecnicoProgramma]([ProgrammaCertificazioneVersioneId] ASC, [Codice] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ProfiloTecnicoProgramma_Specifica_Qualificazione]
    ON [Standard].[ProfiloTecnicoProgramma]([CodiceSpecificaTecnica] ASC, [StatoQualificazione] ASC)
    INCLUDE([ProgrammaCertificazioneVersioneId], [Codice], [DescrizioneIta], [DescrizioneEng]);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contesto documentale della decodifica, ad esempio ST_ENEL o ST_TERNA.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloTecnicoProgramma', @level2type = N'COLUMN', @level2name = N'CodiceSpecificaTecnica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'DOCUMENTATO per la rev. 25; LEGACY_DA_QUALIFICARE per codici presenti negli snapshot ma non nella decodifica corrente.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloTecnicoProgramma', @level2type = N'COLUMN', @level2name = N'StatoQualificazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fonte dalla quale e stata acquisita la voce.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloTecnicoProgramma', @level2type = N'COLUMN', @level2name = N'OrigineSistema';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Catalogo dei profili tecnici PRD contestualizzati a una versione del programma ENEL, ENEL2 o TERNA. Non rappresenta i profili professionali FPC.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloTecnicoProgramma';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice del profilo tecnico ammesso nel contesto della versione del programma.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloTecnicoProgramma', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento al documento o allo snapshot sorgente.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloTecnicoProgramma', @level2type = N'COLUMN', @level2name = N'RiferimentoOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo tecnico del profilo contestuale al programma.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloTecnicoProgramma', @level2type = N'COLUMN', @level2name = N'ProfiloTecnicoProgrammaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione italiana documentata oppure segnaposto esplicito per un codice storico da qualificare.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloTecnicoProgramma', @level2type = N'COLUMN', @level2name = N'DescrizioneIta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione inglese da fonte attendibile. NULL se la traduzione non e disponibile; non duplicare automaticamente il testo italiano.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloTecnicoProgramma', @level2type = N'COLUMN', @level2name = N'DescrizioneEng';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Versione del programma nella quale il codice del profilo assume significato.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloTecnicoProgramma', @level2type = N'COLUMN', @level2name = N'ProgrammaCertificazioneVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Posizione nella decodifica; i residui storici usano ordinali superiori a 1000.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloTecnicoProgramma', @level2type = N'COLUMN', @level2name = N'Ordinale';


GO

