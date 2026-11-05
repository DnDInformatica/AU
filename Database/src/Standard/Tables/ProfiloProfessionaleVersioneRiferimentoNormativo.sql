CREATE TABLE [Standard].[ProfiloProfessionaleVersioneRiferimentoNormativo] (
    [ProfiloProfessionaleVersioneRiferimentoNormativoId] INT                                                IDENTITY (1, 1) NOT NULL,
    [ProfiloProfessionaleVersioneId]                     INT                                                NOT NULL,
    [ProfiloProfessionaleVersioneSpecificaTecnicaId]     INT                                                NULL,
    [NormaEdizioneId]                                    INT                                                NULL,
    [SchemaCertificazioneVersioneId]                     INT                                                NULL,
    [TipoRelazione]                                      NVARCHAR (30)                                      NOT NULL,
    [Ordinale]                                           INT                                                CONSTRAINT [DF_ProfiloProfessionaleVersioneRif_Ordinale] DEFAULT ((1)) NOT NULL,
    [Obbligatoria]                                       BIT                                                CONSTRAINT [DF_ProfiloProfessionaleVersioneRif_Obbligatoria] DEFAULT ((0)) NOT NULL,
    [RiferimentoGrezzo]                                  NVARCHAR (2000)                                    NULL,
    [OrigineSistema]                                     NVARCHAR (200)                                     NOT NULL,
    [ProfiloProfessionaleRiferimentoNormativoIdOrigine]  INT                                                NULL,
    [Attivo]                                             BIT                                                CONSTRAINT [DF_ProfiloProfessionaleVersioneRif_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                                      DATETIME2 (7)                                      CONSTRAINT [DF_ProfiloProfessionaleVersioneRif_Creazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                                           INT                                                NULL,
    [DataModifica]                                       DATETIME2 (7)                                      NULL,
    [ModificatoDa]                                       INT                                                NULL,
    [DataCancellazione]                                  DATETIME2 (7)                                      NULL,
    [CancellatoDa]                                       INT                                                NULL,
    [UniqueRowId]                                        UNIQUEIDENTIFIER                                   CONSTRAINT [DF_ProfiloProfessionaleVersioneRif_RowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                                 DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_ProfiloProfessionaleVersioneRif_Inizio] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]                                   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_ProfiloProfessionaleVersioneRif_Fine] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_ProfiloProfessionaleVersioneRiferimento] PRIMARY KEY CLUSTERED ([ProfiloProfessionaleVersioneRiferimentoNormativoId] ASC),
    CONSTRAINT [CK_ProfiloProfessionaleVersioneRif_Cancellazione] CHECK ([DataCancellazione] IS NULL AND [CancellatoDa] IS NULL OR [DataCancellazione] IS NOT NULL),
    CONSTRAINT [CK_ProfiloProfessionaleVersioneRif_Ordinale] CHECK ([Ordinale]>(0)),
    CONSTRAINT [CK_ProfiloProfessionaleVersioneRif_Origine] CHECK (len(ltrim(rtrim([OrigineSistema])))>(0)),
    CONSTRAINT [CK_ProfiloProfessionaleVersioneRif_TargetXor] CHECK ((case when [NormaEdizioneId] IS NULL then (0) else (1) end+case when [SchemaCertificazioneVersioneId] IS NULL then (0) else (1) end)=(1)),
    CONSTRAINT [CK_ProfiloProfessionaleVersioneRif_Tipo] CHECK (len(ltrim(rtrim([TipoRelazione])))>(0)),
    CONSTRAINT [FK_ProfiloProfessionaleVersioneRif_Norma] FOREIGN KEY ([NormaEdizioneId]) REFERENCES [Standard].[NormaEdizione] ([NormaEdizioneId]),
    CONSTRAINT [FK_ProfiloProfessionaleVersioneRif_Schema] FOREIGN KEY ([SchemaCertificazioneVersioneId]) REFERENCES [Standard].[SchemaCertificazioneVersione] ([SchemaCertificazioneVersioneId]),
    CONSTRAINT [FK_ProfiloProfessionaleVersioneRif_Specifica] FOREIGN KEY ([ProfiloProfessionaleVersioneSpecificaTecnicaId]) REFERENCES [Standard].[ProfiloProfessionaleVersioneSpecificaTecnica] ([ProfiloProfessionaleVersioneSpecificaTecnicaId]),
    CONSTRAINT [FK_ProfiloProfessionaleVersioneRif_Versione] FOREIGN KEY ([ProfiloProfessionaleVersioneId]) REFERENCES [Standard].[ProfiloProfessionaleVersione] ([ProfiloProfessionaleVersioneId]),
    CONSTRAINT [UQ_ProfiloProfessionaleVersioneRif_RowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[ProfiloProfessionaleVersioneRiferimentoNormativoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_ProfiloProfessionaleVersioneRif_CreatoDa]
    ON [Standard].[ProfiloProfessionaleVersioneRiferimentoNormativo]([CreatoDa] ASC) WHERE ([CreatoDa] IS NOT NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ProfiloProfessionaleVersioneRif_Target]
    ON [Standard].[ProfiloProfessionaleVersioneRiferimentoNormativo]([ProfiloProfessionaleVersioneId] ASC, [NormaEdizioneId] ASC, [SchemaCertificazioneVersioneId] ASC, [TipoRelazione] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ProfiloProfessionaleVersioneRif_Origine]
    ON [Standard].[ProfiloProfessionaleVersioneRiferimentoNormativo]([OrigineSistema] ASC, [ProfiloProfessionaleRiferimentoNormativoIdOrigine] ASC) WHERE ([ProfiloProfessionaleRiferimentoNormativoIdOrigine] IS NOT NULL AND [DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_ProfiloProfessionaleVersioneRif_DataCancellazione]
    ON [Standard].[ProfiloProfessionaleVersioneRiferimentoNormativo]([DataCancellazione] ASC)
    INCLUDE([ProfiloProfessionaleVersioneId], [TipoRelazione], [Attivo]) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante UTC della cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine tecnica della validita temporal SQL.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Testo sorgente conservato per audit e riconciliazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'RiferimentoGrezzo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante UTC di creazione della riga.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Target normativo quando il riferimento riguarda una versione dello schema di certificazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'SchemaCertificazioneVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo tecnico del riferimento normativo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'ProfiloProfessionaleVersioneRiferimentoNormativoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''autore della cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sistema o tabella da cui proviene il riferimento normativo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'OrigineSistema';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''autore della creazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo semantico della relazione normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'TipoRelazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Versione del profilo cui appartiene il riferimento.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'ProfiloProfessionaleVersioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante UTC dell''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo univoco della riga per integrazioni distribuite.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del riferimento nel sistema di origine.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'ProfiloProfessionaleRiferimentoNormativoIdOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Specifica testuale sorgente da cui e stato normalizzato il riferimento.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'ProfiloProfessionaleVersioneSpecificaTecnicaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Posizione del riferimento nella sequenza della versione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'Ordinale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''autore dell''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio tecnico della validita temporal SQL.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se il riferimento e obbligatorio per la versione del profilo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'Obbligatoria';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se la riga e utilizzabile nei processi correnti.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Target normativo quando il riferimento riguarda una norma edizione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo', @level2type = N'COLUMN', @level2name = N'NormaEdizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Relazione normalizzata dalla versione del profilo verso una norma edizione oppure una versione dello schema di certificazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionaleVersioneRiferimentoNormativo';


GO

