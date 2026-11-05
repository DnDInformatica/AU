CREATE TABLE [Standard].[ProfiloProfessionaleIdentificativo] (
    [ProfiloProfessionaleIdentificativoId]        INT                                                IDENTITY (1, 1) NOT NULL,
    [ProfiloProfessionaleId]                      INT                                                NOT NULL,
    [TipoIdentificativo]                          NVARCHAR (50)                                      NOT NULL,
    [ValoreIdentificativo]                        NVARCHAR (600)                                     NOT NULL,
    [OrigineSistema]                              NVARCHAR (100)                                     NOT NULL,
    [ProfiloProfessionaleIdentificativoIdOrigine] INT                                                NULL,
    [NormaFamigliaIdOrigine]                      INT                                                NULL,
    [NormaEdizioneIdOrigine]                      INT                                                NULL,
    [CodiceFamigliaOrigine]                       NVARCHAR (200)                                     NULL,
    [SiglaBaseOrigine]                            NVARCHAR (400)                                     NULL,
    [RiferimentoEdizioneOrigine]                  NVARCHAR (600)                                     NULL,
    [RiferimentoDesignazioneOrigine]              NVARCHAR (600)                                     NULL,
    [TitoloBaseItaOrigine]                        NVARCHAR (2000)                                    NULL,
    [Note]                                        NVARCHAR (2000)                                    NULL,
    [Attivo]                                      BIT                                                CONSTRAINT [DF_StandardProfiloProfessionaleId_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                               DATETIME2 (7)                                      CONSTRAINT [DF_StandardProfiloProfessionaleId_Creazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                                    INT                                                NULL,
    [DataModifica]                                DATETIME2 (7)                                      NULL,
    [ModificatoDa]                                INT                                                NULL,
    [DataCancellazione]                           DATETIME2 (7)                                      NULL,
    [CancellatoDa]                                INT                                                NULL,
    [UniqueRowId]                                 UNIQUEIDENTIFIER                                   CONSTRAINT [DF_StandardProfiloProfessionaleId_RowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                          DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_StandardProfiloProfessionaleId_Inizio] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]                            DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_StandardProfiloProfessionaleId_Fine] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    [SorgenteRecordMigrazione]                    NVARCHAR (200)                                     NULL,
    CONSTRAINT [PK_StandardProfiloProfessionaleIdentificativo] PRIMARY KEY CLUSTERED ([ProfiloProfessionaleIdentificativoId] ASC),
    CONSTRAINT [CK_StandardProfiloProfessionaleId_Cancellazione] CHECK ([DataCancellazione] IS NULL AND [CancellatoDa] IS NULL OR [DataCancellazione] IS NOT NULL),
    CONSTRAINT [CK_StandardProfiloProfessionaleId_Origine] CHECK (len(ltrim(rtrim([OrigineSistema])))>(0)),
    CONSTRAINT [CK_StandardProfiloProfessionaleId_RecordMigrazione] CHECK ([SorgenteRecordMigrazione] IS NULL AND [ProfiloProfessionaleIdentificativoIdOrigine] IS NULL OR len(ltrim(rtrim([SorgenteRecordMigrazione])))>(0) AND [ProfiloProfessionaleIdentificativoIdOrigine] IS NOT NULL),
    CONSTRAINT [CK_StandardProfiloProfessionaleId_Tipo] CHECK (len(ltrim(rtrim([TipoIdentificativo])))>(0)),
    CONSTRAINT [CK_StandardProfiloProfessionaleId_Valore] CHECK (len(ltrim(rtrim([ValoreIdentificativo])))>(0)),
    CONSTRAINT [FK_StandardProfiloProfessionaleId_Profilo] FOREIGN KEY ([ProfiloProfessionaleId]) REFERENCES [Standard].[ProfiloProfessionale] ([ProfiloProfessionaleId]),
    CONSTRAINT [UQ_StandardProfiloProfessionaleId_RowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[ProfiloProfessionaleIdentificativoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_StandardProfiloProfessionaleId_CreatoDa]
    ON [Standard].[ProfiloProfessionaleIdentificativo]([CreatoDa] ASC) WHERE ([CreatoDa] IS NOT NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_StandardProfiloProfessionaleId_Business]
    ON [Standard].[ProfiloProfessionaleIdentificativo]([ProfiloProfessionaleId] ASC, [TipoIdentificativo] ASC, [ValoreIdentificativo] ASC, [OrigineSistema] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_StandardProfiloProfessionaleId_RecordMigrazione]
    ON [Standard].[ProfiloProfessionaleIdentificativo]([SorgenteRecordMigrazione] ASC, [ProfiloProfessionaleIdentificativoIdOrigine] ASC) WHERE ([SorgenteRecordMigrazione] IS NOT NULL AND [ProfiloProfessionaleIdentificativoIdOrigine] IS NOT NULL AND [DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_StandardProfiloProfessionaleId_DataCancellazione]
    ON [Standard].[ProfiloProfessionaleIdentificativo]([DataCancellazione] ASC)
    INCLUDE([ProfiloProfessionaleId], [TipoIdentificativo], [Attivo]) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fonte diretta e puntuale del valore identificativo. Non deve contenere il passaggio tecnico usato dalla migrazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'OrigineSistema';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio tecnico della validita temporal SQL.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento legacy alla designazione conservato per riconciliazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'RiferimentoDesignazioneOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo tecnico della chiave di riconciliazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'ProfiloProfessionaleIdentificativoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''autore dell''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se la riga e utilizzabile nei processi correnti.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo legacy di edizione normativa conservato come dato di origine e non come FK canonica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'NormaEdizioneIdOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Titolo italiano legacy conservato per riconciliazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'TitoloBaseItaOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del record nella SorgenteRecordMigrazione; non e una FK verso il catalogo normativo corrente.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'ProfiloProfessionaleIdentificativoIdOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.ProvenancePolicy', @value = N'{"value_origin":"OrigineSistema","technical_record_source":"SorgenteRecordMigrazione","technical_record_id":"ProfiloProfessionaleIdentificativoIdOrigine","normative_origin_fields":"historical_snapshot_not_fk"}', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante UTC della cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice legacy della famiglia normativa conservato per riconciliazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'CodiceFamigliaOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identita stabile del profilo cui appartiene l''identificativo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'ProfiloProfessionaleId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante UTC di creazione della riga.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note di migrazione o riconciliazione dell''identificativo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo della chiave o dell''alias proveniente dal sistema sorgente.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'TipoIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''autore della cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''autore della creazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sigla base legacy conservata per riconciliazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'SiglaBaseOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine tecnica della validita temporal SQL.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo univoco della riga per integrazioni distribuite.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento legacy all''edizione conservato per riconciliazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'RiferimentoEdizioneOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Valore della chiave o dell''alias proveniente dal sistema sorgente.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'ValoreIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante UTC dell''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo legacy di famiglia normativa conservato come dato di origine e non come FK canonica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'NormaFamigliaIdOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice alternativo o chiave di riconciliazione associata all''identita stabile del profilo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tabella o sistema tecnico dal quale e stato materializzato il record canonico; distinta dalla fonte diretta del valore.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleIdentificativo', @level2type = N'COLUMN', @level2name = N'SorgenteRecordMigrazione';


GO

