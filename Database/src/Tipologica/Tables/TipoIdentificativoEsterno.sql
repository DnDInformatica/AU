CREATE TABLE [Tipologica].[TipoIdentificativoEsterno] (
    [TipoIdentificativoEsternoId] INT                                         IDENTITY (1, 1) NOT NULL,
    [SistemaSorgente]             NVARCHAR (20)                               NOT NULL,
    [Codice]                      NVARCHAR (50)                               NOT NULL,
    [Descrizione]                 NVARCHAR (500)                              NOT NULL,
    [PrefissoChiave]              NCHAR (1)                                   NULL,
    [Condivisibile]               BIT                                         CONSTRAINT [DF_TipoIdentificativoEsterno_Condivisibile] DEFAULT ((0)) NOT NULL,
    [UtilizzabilePerMatching]     BIT                                         CONSTRAINT [DF_TipoIdentificativoEsterno_Matching] DEFAULT ((0)) NOT NULL,
    [PrioritaMatching]            TINYINT                                     NULL,
    [FormatoRegex]                NVARCHAR (300)                              NULL,
    [LunghezzaMin]                SMALLINT                                    NULL,
    [LunghezzaMax]                SMALLINT                                    NULL,
    [Attivo]                      BIT                                         CONSTRAINT [DF_TipoIdentificativoEsterno_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]               DATETIME2 (7)                               CONSTRAINT [DF_TipoIdentificativoEsterno_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                    INT                                         NULL,
    [DataModifica]                DATETIME2 (7)                               NULL,
    [ModificatoDa]                INT                                         NULL,
    [DataCancellazione]           DATETIME2 (7)                               NULL,
    [CancellatoDa]                INT                                         NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER                            CONSTRAINT [DF_TipoIdentificativoEsterno_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita]          DATETIME2 (7) GENERATED ALWAYS AS ROW START CONSTRAINT [DF_TipoIdentificativoEsterno_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]            DATETIME2 (7) GENERATED ALWAYS AS ROW END   CONSTRAINT [DF_TipoIdentificativoEsterno_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    [AmbitoIdentificativo]        NVARCHAR (40)                               CONSTRAINT [DF_TipoIdentificativoEsterno_Ambito] DEFAULT (N'ORGANIZZAZIONE') NOT NULL,
    CONSTRAINT [PK_TipoIdentificativoEsterno] PRIMARY KEY CLUSTERED ([TipoIdentificativoEsternoId] ASC),
    CONSTRAINT [CK_TipoIdentificativoEsterno_Ambito] CHECK ([AmbitoIdentificativo]=N'SEDE' OR [AmbitoIdentificativo]=N'UNITA_ORGANIZZATIVA' OR [AmbitoIdentificativo]=N'ORGANIZZAZIONE'),
    CONSTRAINT [CK_TipoIdentificativoEsterno_Lunghezze] CHECK (([LunghezzaMin] IS NULL OR [LunghezzaMin]>(0)) AND ([LunghezzaMax] IS NULL OR [LunghezzaMax]>(0)) AND ([LunghezzaMin] IS NULL OR [LunghezzaMax] IS NULL OR [LunghezzaMin]<=[LunghezzaMax])),
    CONSTRAINT [CK_TipoIdentificativoEsterno_Priorita] CHECK ([PrioritaMatching] IS NULL OR [PrioritaMatching]>=(1) AND [PrioritaMatching]<=(100)),
    CONSTRAINT [CK_TipoIdentificativoEsterno_Sistema] CHECK ([SistemaSorgente]=N'ESTERO' OR [SistemaSorgente]=N'SDI' OR [SistemaSorgente]=N'SIAT' OR [SistemaSorgente]=N'SIA' OR [SistemaSorgente]=N'GAMMA' OR [SistemaSorgente]=N'GIDAS'),
    CONSTRAINT [UQ_TipoIdentificativoEsterno_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Tipologica].[TipoIdentificativoEsternoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_TipoIdentificativoEsterno_SistemaCodice_Attivo]
    ON [Tipologica].[TipoIdentificativoEsterno]([SistemaSorgente] ASC, [Codice] ASC) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipologie governate degli identificativi attribuiti alle organizzazioni da sistemi esterni.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoIdentificativoEsterno';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Livello semantico ammesso: ORGANIZZAZIONE, UNITA_ORGANIZZATIVA o SEDE.', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'TipoIdentificativoEsterno', @level2type = N'COLUMN', @level2name = N'AmbitoIdentificativo';


GO

