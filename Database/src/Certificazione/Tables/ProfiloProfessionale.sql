CREATE TABLE [Certificazione].[ProfiloProfessionale] (
    [ProfiloProfessionaleId] INT                                                NOT NULL,
    [Codice]                 NVARCHAR (100)                                     NOT NULL,
    [Descrizione]            NVARCHAR (2000)                                    NOT NULL,
    [DescrizioneEng]         NVARCHAR (2000)                                    NULL,
    [Attivo]                 BIT                                                CONSTRAINT [DF_ProfiloProfessionale_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]          DATETIME2 (7)                                      CONSTRAINT [DF_ProfiloProfessionale_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]               INT                                                NULL,
    [DataModifica]           DATETIME2 (7)                                      NULL,
    [ModificatoDa]           INT                                                NULL,
    [DataCancellazione]      DATETIME2 (7)                                      NULL,
    [CancellatoDa]           INT                                                NULL,
    [UniqueRowId]            UNIQUEIDENTIFIER                                   CONSTRAINT [DF_ProfiloProfessionale_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]     DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [ScopoFlessibile]        BIT                                                CONSTRAINT [DF_ProfiloProfessionale_ScopoFlessibile] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ProfiloProfessionale] PRIMARY KEY CLUSTERED ([ProfiloProfessionaleId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Certificazione].[ProfiloProfessionaleStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_ProfiloProfessionale_Codice]
    ON [Certificazione].[ProfiloProfessionale]([Codice] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE   TRIGGER [Certificazione].[TR_MIG123_Freeze_ProfiloProfessionale] ON [Certificazione].[ProfiloProfessionale] AFTER INSERT, UPDATE, DELETE AS
                   BEGIN
                       SET NOCOUNT ON;
                       THROW 62331,
                           'MIG_123: catalogo legacy congelato; usare Standard.',
                           1;
                   END;

GO

EXECUTE sp_addextendedproperty @name = N'Accredia.ArchiveTable', @value = N'[ArchiveSIAC].[Legacy_Certificazione_ProfiloProfessionale]', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC - Dipartimento Certificazione e Ispezione', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.06', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio del periodo di validita'' della versione corrente (GENERATED ALWAYS - gestito da SQL Server).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica che la figura e'' oggetto di accreditamento a scopo flessibile (flexible scope): il dettaglio del riferimento normativo non e'' fissato a catalogo ma e'' demandato all''Organismo accreditato. Origine: nota redazionale bilingue dell''anagrafe FPC (fpc.professional_description).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'ScopoFlessibile';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di attivazione logica del profilo. 0 = disattivato, non selezionabile per nuovi programmi.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record (FK logica su IAM.Utente).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica. NULL se mai modificato.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione logica. NULL se non cancellato.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogata del profilo professionale.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'ProfiloProfessionaleId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione estesa del profilo professionale (italiano).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.DecommissionState', @value = N'ARCHIVED_AWAITING_EXTERNAL_APPROVAL', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"status":"Deprecated","reason":"Catalogo profilo professionale legacy duplicato nel modello canonico Standard","replacement":"Standard.ProfiloProfessionale + Standard.ProfiloProfessionaleVersione","write_policy":"Nessun nuovo consumer o nuovo utilizzo; sola conservazione transitoria","decommission_gate":"Preservare provenienza identificativi, classificare history system-time e verificare consumer esterni prima della rimozione"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Deprecated', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale della riga (GUID). Usato per referenze cross-sistema e API esterne.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine del periodo di validita'' della versione corrente (GENERATED ALWAYS - gestito da SQL Server).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di inserimento del record.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record. NULL se mai modificato.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete). NULL = record attivo.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ANAGRAFICA', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Profilo professionale di riferimento per la certificazione FPC. Definisce il codice identificativo e la descrizione (IT/EN) del profilo; le specifiche tecniche/base normativa sono normalizzate nella tabella di dettaglio ProfiloProfessionaleSpecificaTecnica. Utilizzato come anagrafica master per i programmi di certificazione di figure professionali (FPC).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice identificativo univoco del profilo professionale (codice SIAC, es. 04.012.013).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione della figura professionale in lingua inglese (sorgente FPC professional_description.description_en).', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'DescrizioneEng';


GO

