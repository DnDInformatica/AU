CREATE TABLE [Standard].[NormaDesignazione] (
    [NormaDesignazioneId]     INT                                                IDENTITY (1, 1) NOT NULL,
    [NormaEdizioneId]         INT                                                NOT NULL,
    [RiferimentoDesignazione] NVARCHAR (300)                                     NOT NULL,
    [TipoDesignazione]        NVARCHAR (50)                                      NOT NULL,
    [EnteNormatoreId]         INT                                                NULL,
    [AnnoRecepimento]         SMALLINT                                           NULL,
    [Preferita]               BIT                                                DEFAULT ((0)) NOT NULL,
    [Attivo]                  BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]           DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                INT                                                NULL,
    [DataModifica]            DATETIME2 (7)                                      NULL,
    [ModificatoDa]            INT                                                NULL,
    [DataCancellazione]       DATETIME2 (7)                                      NULL,
    [CancellatoDa]            INT                                                NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]      DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]        DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_NormaDesignazione] PRIMARY KEY CLUSTERED ([NormaDesignazioneId] ASC),
    CONSTRAINT [CK_NormaDesignazione_AnnoRecepimento] CHECK ([AnnoRecepimento] IS NULL OR [AnnoRecepimento]>=(1900) AND [AnnoRecepimento]<=(2100)),
    CONSTRAINT [CK_NormaDesignazione_Riferimento] CHECK (len(ltrim(rtrim([RiferimentoDesignazione])))>(0)),
    CONSTRAINT [CK_NormaDesignazione_Tipo] CHECK ([TipoDesignazione]=N'Altro' OR [TipoDesignazione]=N'SchemaProprietario' OR [TipoDesignazione]=N'PrassiUNI' OR [TipoDesignazione]=N'DecretoMinisteriale' OR [TipoDesignazione]=N'RegolamentoUE' OR [TipoDesignazione]=N'DirettivaUE' OR [TipoDesignazione]=N'UNI_CEI_EN' OR [TipoDesignazione]=N'UNI_CEI' OR [TipoDesignazione]=N'UNI_EN' OR [TipoDesignazione]=N'UNI' OR [TipoDesignazione]=N'EN' OR [TipoDesignazione]=N'ISO_IEC' OR [TipoDesignazione]=N'IEC' OR [TipoDesignazione]=N'ISO' OR [TipoDesignazione]=N'Canonica'),
    CONSTRAINT [FK_NormaDesignazione_Edizione] FOREIGN KEY ([NormaEdizioneId]) REFERENCES [Standard].[NormaEdizione] ([NormaEdizioneId]),
    CONSTRAINT [FK_NormaDesignazione_EnteNormatore] FOREIGN KEY ([EnteNormatoreId]) REFERENCES [Standard].[EnteNormatore] ([EnteNormatoreId]),
    CONSTRAINT [UQ_NormaDesignazione_Riferimento] UNIQUE NONCLUSTERED ([RiferimentoDesignazione] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[NormaDesignazioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaDesignazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo di designazione o recepimento: internazionale, europea, nazionale, alias, schema proprietario o altra categoria convenzionale.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaDesignazione', @level2type = N'COLUMN', @level2name = N'TipoDesignazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaDesignazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Anno di recepimento o pubblicazione della designazione alternativa. Non sostituisce AnnoEdizione della NormaEdizione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaDesignazione', @level2type = N'COLUMN', @level2name = N'AnnoRecepimento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.NormaEdizione. Collega una designazione, recepimento o alias alla specifica edizione normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaDesignazione', @level2type = N'COLUMN', @level2name = N'NormaEdizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Designazione alternativa dell''edizione, ad esempio recepimento UNI/EN, sigla nazionale, alias o riferimento di citazione. Non crea una nuova edizione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaDesignazione', @level2type = N'COLUMN', @level2name = N'RiferimentoDesignazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Designazioni, recepimenti o denominazioni alternative della stessa edizione normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaDesignazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata della designazione o citazione alternativa di una edizione normativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaDesignazione', @level2type = N'COLUMN', @level2name = N'NormaDesignazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaDesignazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica la designazione preferita per citazione/pubblicazione quando esistono piu riferimenti alla stessa edizione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaDesignazione', @level2type = N'COLUMN', @level2name = N'Preferita';


GO

