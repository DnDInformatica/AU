CREATE TABLE [Reporting].[NISI_Snapshot] (
    [NISI_SnapshotId]                  BIGINT          IDENTITY (1, 1) NOT NULL,
    [Periodo]                          NVARCHAR (7)    NOT NULL,
    [AsOfDate]                         DATE            NOT NULL,
    [CertificazioneId]                 INT             NOT NULL,
    [SedeId]                           INT             NULL,
    [id_cert]                          NVARCHAR (20)   NOT NULL,
    [ragsoc]                           NVARCHAR (1100) NULL,
    [codfisc]                          NVARCHAR (32)   NULL,
    [fiscalcode]                       NVARCHAR (32)   NULL,
    [companyname]                      NVARCHAR (1100) NULL,
    [address]                          NVARCHAR (545)  NULL,
    [city]                             NVARCHAR (300)  NULL,
    [zipcode]                          NVARCHAR (20)   NULL,
    [issuedate]                        DATE            NULL,
    [scope_ita]                        NVARCHAR (3500) NULL,
    [regulation]                       NVARCHAR (200)  NULL,
    [id_companysitetype]               NVARCHAR (40)   NULL,
    [piva]                             NVARCHAR (22)   NULL,
    [region]                           NVARCHAR (100)  NULL,
    [istat_province_prcode]            NVARCHAR (10)   NULL,
    [iso_country_alpha2]               NVARCHAR (2)    NULL,
    [sector_code]                      NVARCHAR (20)   NULL,
    [sector_code_secondary_accredited] NVARCHAR (20)   NULL,
    [codente]                          NVARCHAR (40)   NULL,
    [ncertificate]                     NVARCHAR (50)   NOT NULL,
    [BuildLogId]                       INT             NOT NULL,
    [BuildAtUtc]                       DATETIME2 (3)   CONSTRAINT [DF_NISI_Snapshot_BuildAtUtc] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_NISI_Snapshot] PRIMARY KEY CLUSTERED ([NISI_SnapshotId] ASC),
    CONSTRAINT [FK_NISI_Snapshot_BuildLog] FOREIGN KEY ([BuildLogId]) REFERENCES [Reporting].[NISI_BuildLog] ([LogId])
);


GO

CREATE NONCLUSTERED INDEX [IX_NISI_Snapshot_Periodo]
    ON [Reporting].[NISI_Snapshot]([Periodo] ASC)
    INCLUDE([CertificazioneId], [codente], [regulation], [sector_code]);


GO

CREATE NONCLUSTERED INDEX [IX_NISI_Snapshot_Periodo_Codente]
    ON [Reporting].[NISI_Snapshot]([Periodo] ASC, [codente] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_NISI_Snapshot_CertificazioneId]
    ON [Reporting].[NISI_Snapshot]([CertificazioneId] ASC, [Periodo] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data alla quale e stato ricostruito il dato per lo snapshot. Serve a rispondere al contenuto visto a una data di riferimento del reporting, non necessariamente alla pubblicazione web effettiva.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'AsOfDate';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo della certificazione sorgente da cui deriva la riga snapshot. Non deve essere modificato sulla base del formato export.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'CertificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Snapshot denormalizzato per esportazione/reporting NISI a una data/periodo. E una proiezione storicizzata del dato operativo per pubblicazione/reporting; non deve diventare la fonte primaria delle certificazioni o delle anagrafiche.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata della riga snapshot NISI.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'NISI_SnapshotId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Periodo dello snapshot/export NISI. Campo testuale operativo; deve essere coerente con FromPeriod/ToPeriod del build log.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'Periodo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice fiscale in formato italiano/esportazione. Dato denormalizzato per reporting, non fonte primaria anagrafica.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'codfisc';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fiscal code in formato export/inglese. Dato denormalizzato per reporting.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'fiscalcode';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo della sede collegata alla certificazione nello snapshot, quando disponibile.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'SedeId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo certificato nel formato richiesto dall''export NISI. Dato denormalizzato derivato dalla certificazione sorgente.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'id_cert';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ragione sociale in formato italiano/esportazione. Dato denormalizzato per reporting, non fonte primaria anagrafica.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'ragsoc';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero certificato riportato nell''export. Deve derivare dalla business key certificato nel perimetro corretto.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'ncertificate';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice settore secondario/accreditato riportato nell''export. Dato denormalizzato; non sostituisce relazioni settore strutturate.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'sector_code_secondary_accredited';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice ente/ODC riportato nell''export. Deve derivare dall''organismo emittente/accreditato sorgente.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'codente';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di scrittura della riga snapshot. Distinto da AsOfDate e dalla data effettiva di eventuale pubblicazione esterna.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'BuildAtUtc';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Reporting.NISI_BuildLog che identifica il processo di build che ha prodotto la riga snapshot.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'BuildLogId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Comune/citta della sede in formato export. Dato denormalizzato.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'city';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Denominazione organizzazione in formato export/inglese. Dato denormalizzato per reporting.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'companyname';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indirizzo sede in formato export. Dato denormalizzato e dipendente dalla sede sorgente.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'address';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Testo italiano dello scopo o oggetto certificato nel formato export. Campo denormalizzato: non sostituisce voci di scopo/certificazione strutturate.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'scope_ita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Norma/regolamento riportato nell''export. Campo denormalizzato derivato da norme/edizioni sorgenti; non deve essere usato come unica fonte normativa.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'regulation';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'CAP o codice postale in formato export. Dato denormalizzato.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'zipcode';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data emissione del certificato nel formato export. Deve derivare dalla data strutturata della certificazione sorgente.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'issuedate';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Regione riportata nell''export. Dato denormalizzato derivato dalla sede.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'region';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice tipo sede/relazione aziendale nel formato export. Deve derivare da tipologica strutturata se usato per controlli.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'id_companysitetype';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Partita IVA riportata nell''export. Dato denormalizzato per reporting, non fonte primaria anagrafica.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'piva';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice settore principale riportato nell''export. Dato denormalizzato derivato dal settore strutturato della certificazione.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'sector_code';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice provincia ISTAT o provincia in formato export. Dato denormalizzato derivato dalla sede/classificazione territoriale.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'istat_province_prcode';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice paese ISO alpha-2 nel formato export. Deve derivare da classificazione paese strutturata quando disponibile.', @level0type = N'SCHEMA', @level0name = N'Reporting', @level1type = N'TABLE', @level1name = N'NISI_Snapshot', @level2type = N'COLUMN', @level2name = N'iso_country_alpha2';


GO

