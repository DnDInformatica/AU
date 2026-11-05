CREATE TABLE [Standard].[ProfiloProfessionaleVersioneSpecificaTecnica] (
    [ProfiloProfessionaleVersioneSpecificaTecnicaId] INT                                                IDENTITY (1, 1) NOT NULL,
    [ProfiloProfessionaleVersioneId]                 INT                                                NOT NULL,
    [Ordinale]                                       INT                                                NOT NULL,
    [SpecificaTecnicaIta]                            NVARCHAR (1000)                                    NOT NULL,
    [SpecificaTecnicaEng]                            NVARCHAR (1000)                                    NULL,
    [AnnoNorma]                                      INT                                                NULL,
    [NormaEdizioneId]                                INT                                                NULL,
    [OrigineSistema]                                 NVARCHAR (200)                                     NOT NULL,
    [ProfiloProfessionaleSpecificaTecnicaIdOrigine]  INT                                                NULL,
    [Attivo]                                         BIT                                                CONSTRAINT [DF_ProfiloProfessionaleVersioneSpecifica_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                                  DATETIME2 (7)                                      CONSTRAINT [DF_ProfiloProfessionaleVersioneSpecifica_Creazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                                       INT                                                NULL,
    [DataModifica]                                   DATETIME2 (7)                                      NULL,
    [ModificatoDa]                                   INT                                                NULL,
    [DataCancellazione]                              DATETIME2 (7)                                      NULL,
    [CancellatoDa]                                   INT                                                NULL,
    [UniqueRowId]                                    UNIQUEIDENTIFIER                                   CONSTRAINT [DF_ProfiloProfessionaleVersioneSpecifica_RowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                             DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_ProfiloProfessionaleVersioneSpecifica_Inizio] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]                               DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_ProfiloProfessionaleVersioneSpecifica_Fine] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_ProfiloProfessionaleVersioneSpecifica] PRIMARY KEY CLUSTERED ([ProfiloProfessionaleVersioneSpecificaTecnicaId] ASC),
    CONSTRAINT [CK_ProfiloProfessionaleVersioneSpecifica_Anno] CHECK ([AnnoNorma] IS NULL OR [AnnoNorma]>=(1800) AND [AnnoNorma]<=(2200)),
    CONSTRAINT [CK_ProfiloProfessionaleVersioneSpecifica_Cancellazione] CHECK ([DataCancellazione] IS NULL AND [CancellatoDa] IS NULL OR [DataCancellazione] IS NOT NULL),
    CONSTRAINT [CK_ProfiloProfessionaleVersioneSpecifica_Ordinale] CHECK ([Ordinale]>=(0)),
    CONSTRAINT [CK_ProfiloProfessionaleVersioneSpecifica_Origine] CHECK (len(ltrim(rtrim([OrigineSistema])))>(0)),
    CONSTRAINT [CK_ProfiloProfessionaleVersioneSpecifica_Testo] CHECK (len(ltrim(rtrim([SpecificaTecnicaIta])))>(0)),
    CONSTRAINT [FK_ProfiloProfessionaleVersioneSpecifica_Norma] FOREIGN KEY ([NormaEdizioneId]) REFERENCES [Standard].[NormaEdizione] ([NormaEdizioneId]),
    CONSTRAINT [FK_ProfiloProfessionaleVersioneSpecifica_Versione] FOREIGN KEY ([ProfiloProfessionaleVersioneId]) REFERENCES [Standard].[ProfiloProfessionaleVersione] ([ProfiloProfessionaleVersioneId]),
    CONSTRAINT [UQ_ProfiloProfessionaleVersioneSpecifica_RowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[ProfiloProfessionaleVersioneSpecificaTecnicaStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ProfiloProfessionaleVersioneSpecifica_Ordinale]
    ON [Standard].[ProfiloProfessionaleVersioneSpecificaTecnica]([ProfiloProfessionaleVersioneId] ASC, [Ordinale] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ProfiloProfessionaleVersioneSpecifica_Origine]
    ON [Standard].[ProfiloProfessionaleVersioneSpecificaTecnica]([OrigineSistema] ASC, [ProfiloProfessionaleSpecificaTecnicaIdOrigine] ASC) WHERE ([ProfiloProfessionaleSpecificaTecnicaIdOrigine] IS NOT NULL AND [DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ProfiloProfessionaleVersioneSpecifica_DataCancellazione]
    ON [Standard].[ProfiloProfessionaleVersioneSpecificaTecnica]([DataCancellazione] ASC)
    INCLUDE([ProfiloProfessionaleVersioneId], [Ordinale], [NormaEdizioneId]) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ProfiloProfessionaleVersioneSpecifica_CreatoDa]
    ON [Standard].[ProfiloProfessionaleVersioneSpecificaTecnica]([CreatoDa] ASC) WHERE ([CreatoDa] IS NOT NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Posizione della specifica nella sequenza del profilo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'Ordinale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Edizione normativa normalizzata quando la specifica e stata riconciliata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'NormaEdizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante UTC di creazione della riga.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante UTC della cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine tecnica della validita temporal SQL.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento testuale sorgente associato a una versione del profilo, conservato anche senza normalizzazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneSpecificaTecnica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Testo italiano acquisito dalla fonte.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'SpecificaTecnicaIta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sistema o tabella da cui proviene la specifica tecnica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'OrigineSistema';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''autore della creazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''autore della cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo tecnico della specifica testuale.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'ProfiloProfessionaleVersioneSpecificaTecnicaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Testo inglese acquisito dalla fonte.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'SpecificaTecnicaEng';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo della specifica nel sistema di origine.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'ProfiloProfessionaleSpecificaTecnicaIdOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante UTC dell''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo univoco della riga per integrazioni distribuite.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Versione del profilo cui si applica la specifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'ProfiloProfessionaleVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Anno indicato dalla fonte per la specifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'AnnoNorma';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se la riga e utilizzabile nei processi correnti.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''autore dell''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio tecnico della validita temporal SQL.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneSpecificaTecnica', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

