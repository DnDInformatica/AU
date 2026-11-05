CREATE TABLE [Certificazione].[ProfiloProfessionaleSpecificaTecnica] (
    [ProfiloProfessionaleSpecificaTecnicaId] INT                                                IDENTITY (1, 1) NOT NULL,
    [ProfiloProfessionaleId]                 INT                                                NOT NULL,
    [Ordinale]                               INT                                                NOT NULL,
    [SpecificaTecnicaIta]                    NVARCHAR (1000)                                    NOT NULL,
    [SpecificaTecnicaEng]                    NVARCHAR (1000)                                    NULL,
    [AnnoNorma]                              INT                                                NULL,
    [Attivo]                                 BIT                                                CONSTRAINT [DF_ProfiloProfessionaleSpecificaTecnica_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                          DATETIME2 (7)                                      CONSTRAINT [DF_ProfiloProfessionaleSpecificaTecnica_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                               INT                                                NULL,
    [DataModifica]                           DATETIME2 (7)                                      NULL,
    [ModificatoDa]                           INT                                                NULL,
    [DataCancellazione]                      DATETIME2 (7)                                      NULL,
    [CancellatoDa]                           INT                                                NULL,
    [UniqueRowId]                            UNIQUEIDENTIFIER                                   CONSTRAINT [DF_ProfiloProfessionaleSpecificaTecnica_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                     DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]                       DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    [NormaEdizioneId]                        INT                                                NULL,
    CONSTRAINT [PK_ProfiloProfessionaleSpecificaTecnica] PRIMARY KEY CLUSTERED ([ProfiloProfessionaleSpecificaTecnicaId] ASC),
    CONSTRAINT [FK_ProfiloProfessionaleSpecificaTecnica_NormaEdizioneId] FOREIGN KEY ([NormaEdizioneId]) REFERENCES [Standard].[NormaEdizione] ([NormaEdizioneId]),
    CONSTRAINT [FK_ProfiloProfessionaleSpecificaTecnica_ProfiloProfessionale] FOREIGN KEY ([ProfiloProfessionaleId]) REFERENCES [Certificazione].[ProfiloProfessionale] ([ProfiloProfessionaleId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Certificazione].[ProfiloProfessionaleSpecificaTecnicaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_ProfiloProfessionaleSpecificaTecnica_Profilo_Ordinale]
    ON [Certificazione].[ProfiloProfessionaleSpecificaTecnica]([ProfiloProfessionaleId] ASC, [Ordinale] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ProfiloProfessionaleSpecificaTecnica_NormaEdizioneId]
    ON [Certificazione].[ProfiloProfessionaleSpecificaTecnica]([NormaEdizioneId] ASC);


GO

CREATE   TRIGGER [Certificazione].[TR_MIG123_Freeze_ProfiloProfessionaleSpecificaTecnica] ON [Certificazione].[ProfiloProfessionaleSpecificaTecnica] AFTER INSERT, UPDATE, DELETE AS
                   BEGIN
                       SET NOCOUNT ON;
                       THROW 62331,
                           'MIG_123: catalogo legacy congelato; usare Standard.',
                           1;
                   END;

GO

EXECUTE sp_addextendedproperty @name = N'Accredia.DecommissionState', @value = N'ARCHIVED_AWAITING_EXTERNAL_APPROVAL', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleSpecificaTecnica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Deprecated', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleSpecificaTecnica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Posizione (0-based) dell''elemento nell''array della base normativa in sorgente; garantisce l''allineamento IT<->EN.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'Ordinale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Specifica tecnica / riferimento normativo in inglese (verbatim dalla sorgente law_regulation_en); NULL se assente in sorgente.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'SpecificaTecnicaEng';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Edizione normativa di riferimento della specifica tecnica: FK a Standard.NormaEdizione (livello edizione, es. ISO/IEC 17024:2012). Collegamento figura-norma strutturato che sostituisce/affianca AnnoNorma; da NormaEdizione si deriva la norma di accreditamento.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'NormaEdizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.ArchiveTable', @value = N'[ArchiveSIAC].[Legacy_Certificazione_ProfiloProfessionaleSpecificaTecnica]', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleSpecificaTecnica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"status":"Deprecated","reason":"Catalogo profilo professionale legacy duplicato nel modello canonico Standard","replacement":"Standard.ProfiloProfessionaleVersioneSpecificaTecnica","write_policy":"Nessun nuovo consumer o nuovo utilizzo; sola conservazione transitoria","decommission_gate":"Preservare provenienza identificativi, classificare history system-time e verificare consumer esterni prima della rimozione"}', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleSpecificaTecnica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dettaglio normalizzato (1NF) delle specifiche tecniche/base normativa di una figura professionale FPC, una riga per elemento dell''array sorgente, con testo in italiano e inglese.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleSpecificaTecnica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Testo descrittivo della specifica tecnica, norma professionale, schema o documento applicabile al profilo professionale. Campo verbatim/informativo utile per migrazione e pubblicazione, ma non sufficiente come riferimento normativo strutturato. Nel target deve essere affiancato da NormaEdizioneId quando la specifica corrisponde a una norma o documento versionabile.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'SpecificaTecnicaIta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Anno estratto o indicato per la specifica tecnica. Campo ausiliario e non deterministico: non identifica da solo una edizione normativa, non gestisce emendamenti, rettifiche, transizioni, ritiri o sostituzioni. Nel modello target va sostituito o affiancato da NormaEdizioneId verso Standard.NormaEdizione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'AnnoNorma';


GO

