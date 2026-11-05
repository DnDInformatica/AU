CREATE TABLE [Certificazione].[ProgrammaCertificazioneVersioneIdentificativo] (
    [ProgrammaCertificazioneVersioneIdentificativoId] INT                                                IDENTITY (1, 1) NOT NULL,
    [ProgrammaCertificazioneVersioneId]               INT                                                NOT NULL,
    [TipoIdentificativo]                              NVARCHAR (400)                                     NOT NULL,
    [ValoreIdentificativo]                            NVARCHAR (2400)                                    NOT NULL,
    [OrigineSistema]                                  NVARCHAR (800)                                     NOT NULL,
    [NormaFamigliaIdOrigine]                          INT                                                NULL,
    [NormaEdizioneIdOrigine]                          INT                                                NULL,
    [NormaAccreditamentoIdOrigine]                    INT                                                NULL,
    [NormaAccreditamentoSchemaIdOrigine]              INT                                                NULL,
    [CodiceSPOrigine]                                 NVARCHAR (200)                                     NULL,
    [NomeProgrammaOrigine]                            NVARCHAR (1020)                                    NULL,
    [RiferimentoEdizioneOrigine]                      NVARCHAR (1200)                                    NULL,
    [RiferimentoDesignazioneOrigine]                  NVARCHAR (1200)                                    NULL,
    [Note]                                            NVARCHAR (4000)                                    NULL,
    [Attivo]                                          BIT                                                CONSTRAINT [DF_ProgrammaCertificazioneVersioneIdentificativo_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                                   DATETIME2 (7)                                      CONSTRAINT [DF_ProgrammaCertificazioneVersioneIdentificativo_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                                        INT                                                NULL,
    [DataModifica]                                    DATETIME2 (7)                                      NULL,
    [ModificatoDa]                                    INT                                                NULL,
    [DataCancellazione]                               DATETIME2 (7)                                      NULL,
    [CancellatoDa]                                    INT                                                NULL,
    [UniqueRowId]                                     UNIQUEIDENTIFIER                                   CONSTRAINT [DF_ProgrammaCertificazioneVersioneIdentificativo_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita]                              DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_ProgrammaCertificazioneVersioneIdentificativo_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]                                DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_ProgrammaCertificazioneVersioneIdentificativo_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_ProgrammaCertificazioneVersioneIdentificativo] PRIMARY KEY CLUSTERED ([ProgrammaCertificazioneVersioneIdentificativoId] ASC),
    CONSTRAINT [CK_ProgrammaCertificazioneVersioneIdentificativo_Cancellazione] CHECK ([DataCancellazione] IS NULL AND [CancellatoDa] IS NULL OR [DataCancellazione] IS NOT NULL),
    CONSTRAINT [CK_ProgrammaCertificazioneVersioneIdentificativo_Origine] CHECK (len(ltrim(rtrim([OrigineSistema])))>(0)),
    CONSTRAINT [CK_ProgrammaCertificazioneVersioneIdentificativo_Tipo] CHECK (len(ltrim(rtrim([TipoIdentificativo])))>(0)),
    CONSTRAINT [CK_ProgrammaCertificazioneVersioneIdentificativo_Valore] CHECK (len(ltrim(rtrim([ValoreIdentificativo])))>(0)),
    CONSTRAINT [FK_ProgrammaCertificazioneVersioneIdentificativo_Versione] FOREIGN KEY ([ProgrammaCertificazioneVersioneId]) REFERENCES [Certificazione].[ProgrammaCertificazioneVersione] ([ProgrammaCertificazioneVersioneId]),
    CONSTRAINT [UQ_ProgrammaCertificazioneVersioneIdentificativo_TargetTipoValoreOrigine] UNIQUE NONCLUSTERED ([ProgrammaCertificazioneVersioneId] ASC, [TipoIdentificativo] ASC, [ValoreIdentificativo] ASC, [OrigineSistema] ASC),
    CONSTRAINT [UQ_ProgrammaCertificazioneVersioneIdentificativo_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Certificazione].[ProgrammaCertificazioneVersioneIdentificativoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_ProgrammaCertificazioneVersioneIdentificativo_Versione]
    ON [Certificazione].[ProgrammaCertificazioneVersioneIdentificativo]([ProgrammaCertificazioneVersioneId] ASC, [TipoIdentificativo] ASC)
    INCLUDE([ValoreIdentificativo], [OrigineSistema]);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo legacy di NormaAccreditamento da cui deriva il riferimento, se applicabile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'NormaAccreditamentoIdOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Colonna tecnica di inizio periodo SYSTEM_VERSIONING (hidden). Non rappresenta validità business.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice programma/schema legacy, se applicabile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'CodiceSPOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''utente o processo che ha modificato il record, se disponibile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Valore dell''identificativo o riferimento di origine.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'ValoreIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo legacy di NormaFamiglia da cui deriva il riferimento, se applicabile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'NormaFamigliaIdOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''utente o processo che ha cancellato logicamente il record, se disponibile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC di creazione tecnica del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo tecnico dell''identificativo versione programma.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'ProgrammaCertificazioneVersioneIdentificativoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC dell''ultima modifica applicativa del record, se disponibile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo dell''identificativo o riferimento di origine.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'TipoIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento edizione legacy, se applicabile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'RiferimentoEdizioneOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note di migrazione o governo dell''identificativo versione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo legacy di NormaAccreditamentoSchema da cui deriva il riferimento, se applicabile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'NormaAccreditamentoSchemaIdOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Colonna tecnica di fine periodo SYSTEM_VERSIONING (hidden). Non rappresenta validità business.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nome programma/schema legacy, se applicabile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'NomeProgrammaOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC di cancellazione logica del record. NULL indica record non cancellato logicamente.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sistema, tabella o processo da cui deriva l''identificativo.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'OrigineSistema';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo legacy di NormaEdizione da cui deriva il riferimento, se applicabile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'NormaEdizioneIdOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo univoco tecnico stabile della riga, utile per tracciamento, import e integrazione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativi e riferimenti legacy o di origine associati alla versione del programma di certificazione. Separata dagli identificativi dell''identita programma.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''utente o processo che ha creato il record, se disponibile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Versione programma a cui appartiene l''identificativo.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'ProgrammaCertificazioneVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Designazione legacy o riferimento testuale di origine, se applicabile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'RiferimentoDesignazioneOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se il record è attivo nell''uso applicativo corrente. Non rappresenta cancellazione fisica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersioneIdentificativo', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

