CREATE TABLE [Standard].[ProfiloProfessionaleVersione] (
    [ProfiloProfessionaleVersioneId] INT                                                IDENTITY (1, 1) NOT NULL,
    [ProfiloProfessionaleId]         INT                                                NOT NULL,
    [CodiceVersione]                 NVARCHAR (100)                                     NOT NULL,
    [DescrizioneIta]                 NVARCHAR (2000)                                    NOT NULL,
    [DescrizioneEng]                 NVARCHAR (2000)                                    NULL,
    [ScopoFlessibile]                BIT                                                CONSTRAINT [DF_ProfiloProfessionaleVersione_ScopoFlessibile] DEFAULT ((0)) NOT NULL,
    [DataInizioApplicabilita]        DATE                                               NULL,
    [DataFineApplicabilita]          DATE                                               NULL,
    [VersioneCorrente]               BIT                                                CONSTRAINT [DF_ProfiloProfessionaleVersione_Corrente] DEFAULT ((0)) NOT NULL,
    [OrigineSistema]                 NVARCHAR (200)                                     NOT NULL,
    [ProfiloProfessionaleIdOrigine]  INT                                                NULL,
    [DataInizioValiditaOrigine]      DATETIME2 (7)                                      NULL,
    [DataFineValiditaOrigine]        DATETIME2 (7)                                      NULL,
    [Attivo]                         BIT                                                CONSTRAINT [DF_ProfiloProfessionaleVersione_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                  DATETIME2 (7)                                      CONSTRAINT [DF_ProfiloProfessionaleVersione_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                       INT                                                NULL,
    [DataModifica]                   DATETIME2 (7)                                      NULL,
    [ModificatoDa]                   INT                                                NULL,
    [DataCancellazione]              DATETIME2 (7)                                      NULL,
    [CancellatoDa]                   INT                                                NULL,
    [UniqueRowId]                    UNIQUEIDENTIFIER                                   CONSTRAINT [DF_ProfiloProfessionaleVersione_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]             DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_ProfiloProfessionaleVersione_ValiditaInizio] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]               DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_ProfiloProfessionaleVersione_ValiditaFine] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_ProfiloProfessionaleVersione] PRIMARY KEY CLUSTERED ([ProfiloProfessionaleVersioneId] ASC),
    CONSTRAINT [CK_ProfiloProfessionaleVersione_Applicabilita] CHECK ([DataFineApplicabilita] IS NULL OR [DataInizioApplicabilita] IS NULL OR [DataFineApplicabilita]>=[DataInizioApplicabilita]),
    CONSTRAINT [CK_ProfiloProfessionaleVersione_Cancellazione] CHECK ([DataCancellazione] IS NULL AND [CancellatoDa] IS NULL OR [DataCancellazione] IS NOT NULL),
    CONSTRAINT [CK_ProfiloProfessionaleVersione_Codice] CHECK (len(ltrim(rtrim([CodiceVersione])))>(0)),
    CONSTRAINT [CK_ProfiloProfessionaleVersione_Origine] CHECK (len(ltrim(rtrim([OrigineSistema])))>(0)),
    CONSTRAINT [FK_ProfiloProfessionaleVersione_Profilo] FOREIGN KEY ([ProfiloProfessionaleId]) REFERENCES [Standard].[ProfiloProfessionale] ([ProfiloProfessionaleId]),
    CONSTRAINT [UQ_ProfiloProfessionaleVersione_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[ProfiloProfessionaleVersioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ProfiloProfessionaleVersione_Corrente]
    ON [Standard].[ProfiloProfessionaleVersione]([ProfiloProfessionaleId] ASC) WHERE ([VersioneCorrente]=(1) AND [DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ProfiloProfessionaleVersione_DataCancellazione]
    ON [Standard].[ProfiloProfessionaleVersione]([DataCancellazione] ASC)
    INCLUDE([ProfiloProfessionaleId], [CodiceVersione], [Attivo]) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ProfiloProfessionaleVersione_CreatoDa]
    ON [Standard].[ProfiloProfessionaleVersione]([CreatoDa] ASC) WHERE ([CreatoDa] IS NOT NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ProfiloProfessionaleVersione_Codice]
    ON [Standard].[ProfiloProfessionaleVersione]([ProfiloProfessionaleId] ASC, [CodiceVersione] ASC) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''autore dell''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di inizio applicabilita di dominio; NULL quando non ancora qualificata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'DataInizioApplicabilita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice della versione nel contesto del profilo. MIGRATA-1 identifica la fotografia iniziale importata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'CodiceVersione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se la riga e utilizzabile nei processi correnti.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sistema o tabella da cui proviene la versione durante la riconciliazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'OrigineSistema';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante UTC della cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante UTC di creazione della riga.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Denominazione italiana applicabile nella versione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'DescrizioneIta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del profilo nel sistema di origine cui appartiene la versione migrata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'ProfiloProfessionaleIdOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Versione funzionale identificata di un profilo professionale FPC.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio tecnico della validita temporal SQL.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Denominazione inglese applicabile nella versione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'DescrizioneEng';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''autore della cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''autore della creazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio della validita temporal della riga sorgente; non e una data di applicabilita di dominio.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'DataInizioValiditaOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo tecnico della versione funzionale.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'ProfiloProfessionaleVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di fine applicabilita di dominio; NULL quando aperta o non ancora qualificata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'DataFineApplicabilita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine tecnica della validita temporal SQL.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se la versione del profilo ammette la gestione dello scopo flessibile.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'ScopoFlessibile';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo univoco della riga per integrazioni distribuite.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identita stabile del profilo cui appartiene la versione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'ProfiloProfessionaleId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante UTC dell''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine della validita temporal della riga sorgente; non e una data di applicabilita di dominio.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'DataFineValiditaOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica la versione corrente del profilo nel catalogo governato.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersione', @level2type = N'COLUMN', @level2name = N'VersioneCorrente';


GO

