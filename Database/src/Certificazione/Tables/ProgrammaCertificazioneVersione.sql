CREATE TABLE [Certificazione].[ProgrammaCertificazioneVersione] (
    [ProgrammaCertificazioneVersioneId] INT                                                IDENTITY (1, 1) NOT NULL,
    [ProgrammaCertificazioneId]         INT                                                NOT NULL,
    [CodiceVersione]                    NVARCHAR (150)                                     NOT NULL,
    [VersioneSchema]                    NVARCHAR (200)                                     NULL,
    [TitoloVersione]                    NVARCHAR (510)                                     NULL,
    [DataEntrataVigore]                 DATE                                               NULL,
    [DataFineValiditaProgramma]         DATE                                               NULL,
    [CicloAnni]                         SMALLINT                                           NULL,
    [RichiedeEsame]                     BIT                                                CONSTRAINT [DF_ProgrammaCertificazioneVersione_RichiedeEsame] DEFAULT ((0)) NOT NULL,
    [RichiedeSorveglianza]              BIT                                                CONSTRAINT [DF_ProgrammaCertificazioneVersione_RichiedeSorveglianza] DEFAULT ((0)) NOT NULL,
    [RichiedeDelibera]                  BIT                                                CONSTRAINT [DF_ProgrammaCertificazioneVersione_RichiedeDelibera] DEFAULT ((1)) NOT NULL,
    [RichiedeCampoProva]                BIT                                                CONSTRAINT [DF_ProgrammaCertificazioneVersione_RichiedeCampoProva] DEFAULT ((0)) NOT NULL,
    [RichiedeDocentiQualificati]        BIT                                                CONSTRAINT [DF_ProgrammaCertificazioneVersione_RichiedeDocentiQualificati] DEFAULT ((0)) NOT NULL,
    [StatoVersioneProgrammaId]          INT                                                NOT NULL,
    [VersioneCorrente]                  BIT                                                CONSTRAINT [DF_ProgrammaCertificazioneVersione_VersioneCorrente] DEFAULT ((0)) NOT NULL,
    [Note]                              NVARCHAR (4000)                                    NULL,
    [Attivo]                            BIT                                                CONSTRAINT [DF_ProgrammaCertificazioneVersione_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                     DATETIME2 (7)                                      CONSTRAINT [DF_ProgrammaCertificazioneVersione_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                          INT                                                NULL,
    [DataModifica]                      DATETIME2 (7)                                      NULL,
    [ModificatoDa]                      INT                                                NULL,
    [DataCancellazione]                 DATETIME2 (7)                                      NULL,
    [CancellatoDa]                      INT                                                NULL,
    [UniqueRowId]                       UNIQUEIDENTIFIER                                   CONSTRAINT [DF_ProgrammaCertificazioneVersione_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita]                DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_ProgrammaCertificazioneVersione_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]                  DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_ProgrammaCertificazioneVersione_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    [SchemaCertificazioneVersioneId]    INT                                                NULL,
    CONSTRAINT [PK_ProgrammaCertificazioneVersione] PRIMARY KEY CLUSTERED ([ProgrammaCertificazioneVersioneId] ASC),
    CONSTRAINT [CK_ProgrammaCertificazioneVersione_Cancellazione] CHECK ([DataCancellazione] IS NULL AND [CancellatoDa] IS NULL OR [DataCancellazione] IS NOT NULL),
    CONSTRAINT [CK_ProgrammaCertificazioneVersione_Ciclo] CHECK ([CicloAnni] IS NULL OR [CicloAnni]>=(1) AND [CicloAnni]<=(20)),
    CONSTRAINT [CK_ProgrammaCertificazioneVersione_CodiceVersione] CHECK (len(ltrim(rtrim([CodiceVersione])))>(0)),
    CONSTRAINT [CK_ProgrammaCertificazioneVersione_Date] CHECK ([DataFineValiditaProgramma] IS NULL OR [DataEntrataVigore] IS NULL OR [DataFineValiditaProgramma]>=[DataEntrataVigore]),
    CONSTRAINT [FK_ProgrammaCertificazioneVersione_Programma] FOREIGN KEY ([ProgrammaCertificazioneId]) REFERENCES [Certificazione].[ProgrammaCertificazione] ([ProgrammaCertificazioneId]),
    CONSTRAINT [FK_ProgrammaCertificazioneVersione_SchCertVersione] FOREIGN KEY ([SchemaCertificazioneVersioneId]) REFERENCES [Standard].[SchemaCertificazioneVersione] ([SchemaCertificazioneVersioneId]),
    CONSTRAINT [FK_ProgrammaCertificazioneVersione_Stato] FOREIGN KEY ([StatoVersioneProgrammaId]) REFERENCES [Certificazione].[StatoVersioneProgramma] ([StatoVersioneProgrammaId]),
    CONSTRAINT [UQ_ProgrammaCertificazioneVersione_Programma_Codice] UNIQUE NONCLUSTERED ([ProgrammaCertificazioneId] ASC, [CodiceVersione] ASC),
    CONSTRAINT [UQ_ProgrammaCertificazioneVersione_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Certificazione].[ProgrammaCertificazioneVersioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_ProgrammaCertificazioneVersione_Programma_Stato]
    ON [Certificazione].[ProgrammaCertificazioneVersione]([ProgrammaCertificazioneId] ASC, [StatoVersioneProgrammaId] ASC)
    INCLUDE([CodiceVersione], [VersioneSchema], [DataEntrataVigore], [DataFineValiditaProgramma], [VersioneCorrente]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ProgrammaCertificazioneVersione_Corrente]
    ON [Certificazione].[ProgrammaCertificazioneVersione]([ProgrammaCertificazioneId] ASC) WHERE ([VersioneCorrente]=(1) AND [DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ProgrammaCertificazioneVersione_ProgrammaVersione]
    ON [Certificazione].[ProgrammaCertificazioneVersione]([ProgrammaCertificazioneId] ASC, [ProgrammaCertificazioneVersioneId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_ProgrammaCertificazioneVersione_SchCertVersione]
    ON [Certificazione].[ProgrammaCertificazioneVersione]([SchemaCertificazioneVersioneId] ASC) WHERE ([SchemaCertificazioneVersioneId] IS NOT NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC di cancellazione logica del record. NULL indica record non cancellato logicamente.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo univoco tecnico stabile della riga, utile per tracciamento, import e integrazione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note di governo o migrazione relative alla versione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC di creazione tecnica del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC dell''ultima modifica applicativa del record, se disponibile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se questa versione del programma richiede un esame.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'RichiedeEsame';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se questa versione del programma richiede una decisione/delibera.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'RichiedeDelibera';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se questa versione del programma richiede docenti qualificati.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'RichiedeDocentiQualificati';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo tecnico della versione del programma di certificazione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'ProgrammaCertificazioneVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Colonna tecnica di fine periodo SYSTEM_VERSIONING (hidden). Non rappresenta validità business.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice stabile della versione nel perimetro del programma. Per versioni migrate dai campi legacy viene usato MIGRATA.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'CodiceVersione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Titolo o descrizione breve della versione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'TitoloVersione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di fine validità/applicabilità della versione del programma.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'DataFineValiditaProgramma';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''utente o processo che ha modificato il record, se disponibile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''utente o processo che ha cancellato logicamente il record, se disponibile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.07', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Colonna tecnica di inizio periodo SYSTEM_VERSIONING (hidden). Non rappresenta validità business.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Versione applicabile di un programma di certificazione. Contiene attributi mutevoli nel tempo quali versione schema, decorrenza, ciclo, flag di processo e stato.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica la versione corrente del programma. Il modello consente una sola versione corrente attiva per programma.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'VersioneCorrente';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se il record è attivo nell''uso applicativo corrente. Non rappresenta cancellazione fisica.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''utente o processo che ha creato il record, se disponibile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Durata del ciclo certificativo in anni prevista da questa versione, se applicabile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'CicloAnni';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se questa versione del programma richiede sorveglianza.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'RichiedeSorveglianza';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se questa versione del programma richiede campo prova.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'RichiedeCampoProva';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stato di ciclo di vita della versione, collegato a Certificazione.StatoVersioneProgramma.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'StatoVersioneProgrammaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Programma di certificazione di cui questa riga rappresenta una versione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'ProgrammaCertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK (nullable) verso Standard.SchemaCertificazioneVersione: versione/revisione autorevole dello schema applicata da questa versione operativa del programma. Mantiene distinta la fonte ufficiale dello schema dalla configurazione SIDAC del programma.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'SchemaCertificazioneVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Etichetta/versione dichiarata dallo schema o dal proprietario schema, quando disponibile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'VersioneSchema';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di entrata in vigore/applicabilità della versione del programma.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneVersione', @level2type = N'COLUMN', @level2name = N'DataEntrataVigore';


GO

