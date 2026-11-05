CREATE TABLE [Certificazione].[CertificazionePRDProfiloTecnico] (
    [CertificazionePRDProfiloTecnicoId] BIGINT                                             IDENTITY (1, 1) NOT NULL,
    [CertificazionePRDId]               INT                                                NOT NULL,
    [ProfiloTecnicoProgrammaId]         INT                                                NOT NULL,
    [Ordinale]                          SMALLINT                                           NOT NULL,
    [ValoreOrigine]                     NVARCHAR (100)                                     NOT NULL,
    [DataInizioApplicabilita]           DATETIME2 (7)                                      NOT NULL,
    [DataFineApplicabilita]             DATETIME2 (7)                                      NULL,
    [OrigineSistema]                    NVARCHAR (200)                                     NOT NULL,
    [Attivo]                            BIT                                                CONSTRAINT [DF_CertificazionePRDProfiloTecnico_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                     DATETIME2 (7)                                      CONSTRAINT [DF_CertificazionePRDProfiloTecnico_Creazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                          INT                                                NULL,
    [DataModifica]                      DATETIME2 (7)                                      NULL,
    [ModificatoDa]                      INT                                                NULL,
    [DataCancellazione]                 DATETIME2 (7)                                      NULL,
    [CancellatoDa]                      INT                                                NULL,
    [UniqueRowId]                       UNIQUEIDENTIFIER                                   CONSTRAINT [DF_CertificazionePRDProfiloTecnico_RowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_CertificazionePRDProfiloTecnico_Inizio] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]                  DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_CertificazionePRDProfiloTecnico_Fine] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_CertificazionePRDProfiloTecnico] PRIMARY KEY CLUSTERED ([CertificazionePRDProfiloTecnicoId] ASC),
    CONSTRAINT [CK_CertificazionePRDProfiloTecnico_Cancellazione] CHECK ([DataCancellazione] IS NULL AND [CancellatoDa] IS NULL OR [DataCancellazione] IS NOT NULL),
    CONSTRAINT [CK_CertificazionePRDProfiloTecnico_Ordinale] CHECK ([Ordinale]>(0)),
    CONSTRAINT [CK_CertificazionePRDProfiloTecnico_Origine] CHECK (len(ltrim(rtrim([OrigineSistema])))>(0)),
    CONSTRAINT [CK_CertificazionePRDProfiloTecnico_Validita] CHECK ([DataFineApplicabilita] IS NULL OR [DataFineApplicabilita]>=[DataInizioApplicabilita]),
    CONSTRAINT [CK_CertificazionePRDProfiloTecnico_Valore] CHECK (len(ltrim(rtrim([ValoreOrigine])))>(0)),
    CONSTRAINT [FK_CertificazionePRDProfiloTecnico_PRD] FOREIGN KEY ([CertificazionePRDId]) REFERENCES [Certificazione].[CertificazionePRD] ([CertificazionePRDId]),
    CONSTRAINT [FK_CertificazionePRDProfiloTecnico_Profilo] FOREIGN KEY ([ProfiloTecnicoProgrammaId]) REFERENCES [Standard].[ProfiloTecnicoProgramma] ([ProfiloTecnicoProgrammaId]),
    CONSTRAINT [UQ_CertificazionePRDProfiloTecnico_Business] UNIQUE NONCLUSTERED ([CertificazionePRDId] ASC, [ProfiloTecnicoProgrammaId] ASC, [DataInizioApplicabilita] ASC),
    CONSTRAINT [UQ_CertificazionePRDProfiloTecnico_RowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Certificazione].[CertificazionePRDProfiloTecnicoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_CertificazionePRDProfiloTecnico_Corrente]
    ON [Certificazione].[CertificazionePRDProfiloTecnico]([CertificazionePRDId] ASC, [DataFineApplicabilita] ASC)
    INCLUDE([ProfiloTecnicoProgrammaId], [Ordinale], [ValoreOrigine]) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine della validita di business; NULL per l''associazione corrente.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRDProfiloTecnico', @level2type = N'COLUMN', @level2name = N'DataFineApplicabilita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sorgente dalla quale e stata ricostruita l''associazione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRDProfiloTecnico', @level2type = N'COLUMN', @level2name = N'OrigineSistema';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Relazione multivalore tra un certificato PRD e i profili tecnici validi in uno specifico intervallo di business.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRDProfiloTecnico';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo tecnico della relazione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRDProfiloTecnico', @level2type = N'COLUMN', @level2name = N'CertificazionePRDProfiloTecnicoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Certificazione PRD cui appartiene il profilo.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRDProfiloTecnico', @level2type = N'COLUMN', @level2name = N'CertificazionePRDId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Profilo tecnico contestualizzato alla versione del programma.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRDProfiloTecnico', @level2type = N'COLUMN', @level2name = N'ProfiloTecnicoProgrammaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ordine del codice nel valore multivalore ricevuto.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRDProfiloTecnico', @level2type = N'COLUMN', @level2name = N'Ordinale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio della validita di business ricostruita dagli snapshot SIAC.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRDProfiloTecnico', @level2type = N'COLUMN', @level2name = N'DataInizioApplicabilita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Token normalizzato ricavato dal campo sorgente separato da virgole.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'CertificazionePRDProfiloTecnico', @level2type = N'COLUMN', @level2name = N'ValoreOrigine';


GO

