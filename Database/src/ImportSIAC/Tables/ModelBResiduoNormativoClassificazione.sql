CREATE TABLE [ImportSIAC].[ModelBResiduoNormativoClassificazione] (
    [ModelBResiduoNormativoClassificazioneId] INT              IDENTITY (1, 1) NOT NULL,
    [LegacyNormaFamigliaId]                   INT              NOT NULL,
    [CategoriaResiduo]                        VARCHAR (40)     NOT NULL,
    [TipoOggettoProposto]                     VARCHAR (80)     NOT NULL,
    [DominioTargetProposto]                   NVARCHAR (200)   NOT NULL,
    [TargetSchemaProposto]                    [sysname]        NULL,
    [TargetTableProposta]                     [sysname]        NULL,
    [TargetId]                                INT              NULL,
    [StatoClassificazione]                    VARCHAR (40)     CONSTRAINT [DF_ModelBResiduoNormativoClassificazione_Stato] DEFAULT ('DA_VALIDARE') NOT NULL,
    [BaseOriginale]                           NVARCHAR (800)   NOT NULL,
    [DesignazioneNormalizzata]                NVARCHAR (800)   NOT NULL,
    [CodiciLegacy]                            NVARCHAR (MAX)   NULL,
    [RiferimentiEdizioneLegacy]               NVARCHAR (MAX)   NULL,
    [TitoloOrigine]                           NVARCHAR (4000)  NULL,
    [NumeroEdizioni]                          INT              NOT NULL,
    [NumeroIdentificativi]                    INT              NOT NULL,
    [NumeroOrganismi]                         INT              NOT NULL,
    [AzioneProposta]                          NVARCHAR (400)   NOT NULL,
    [Note]                                    NVARCHAR (4000)  NULL,
    [DecisioneFunzionale]                     NVARCHAR (4000)  NULL,
    [Attivo]                                  BIT              CONSTRAINT [DF_ModelBResiduoNormativoClassificazione_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                           DATETIME2 (7)    CONSTRAINT [DF_ModelBResiduoNormativoClassificazione_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                                INT              NULL,
    [DataModifica]                            DATETIME2 (7)    NULL,
    [ModificatoDa]                            INT              NULL,
    [UniqueRowId]                             UNIQUEIDENTIFIER CONSTRAINT [DF_ModelBResiduoNormativoClassificazione_UniqueRowId] DEFAULT (newid()) NOT NULL,
    CONSTRAINT [PK_ModelBResiduoNormativoClassificazione] PRIMARY KEY CLUSTERED ([ModelBResiduoNormativoClassificazioneId] ASC),
    CONSTRAINT [CK_ModelBResiduoNormativoClassificazione_Categoria] CHECK ([CategoriaResiduo]='SCHEMA_PROGRAMMA' OR [CategoriaResiduo]='FONTE_LEGISLATIVA'),
    CONSTRAINT [CK_ModelBResiduoNormativoClassificazione_Counts] CHECK ([NumeroEdizioni]>=(0) AND [NumeroIdentificativi]>=(0) AND [NumeroOrganismi]>=(0)),
    CONSTRAINT [CK_ModelBResiduoNormativoClassificazione_Stato] CHECK ([StatoClassificazione]='SCARTATO' OR [StatoClassificazione]='MODELLATO' OR [StatoClassificazione]='VALIDATO' OR [StatoClassificazione]='DA_VALIDARE'),
    CONSTRAINT [UQ_ModelBResiduoNormativoClassificazione_Legacy] UNIQUE NONCLUSTERED ([LegacyNormaFamigliaId] ASC),
    CONSTRAINT [UQ_ModelBResiduoNormativoClassificazione_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_ModelBResiduoNormativoClassificazione_Target]
    ON [ImportSIAC].[ModelBResiduoNormativoClassificazione]([TargetSchemaProposto] ASC, [TargetTableProposta] ASC, [StatoClassificazione] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_ModelBResiduoNormativoClassificazione_Categoria]
    ON [ImportSIAC].[ModelBResiduoNormativoClassificazione]([CategoriaResiduo] ASC, [TipoOggettoProposto] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero di righe Standard.NormaFamigliaIdentificativo collegate al LegacyNormaFamigliaId.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'NumeroIdentificativi';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note tecniche e funzionali prodotte dalla classificazione automatica.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Macro-categoria del residuo: FONTE_LEGISLATIVA oppure SCHEMA_PROGRAMMA.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'CategoriaResiduo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tabella di governo della migrazione Model B per classificare gli oggetti legacy rimasti fuori da Standard.NormaFamiglia perche'' non rappresentano famiglie normative tecniche.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo globale della riga per integrazione e tracciabilita''.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Valore sorgente legacy usato per riconoscere il residuo.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'BaseOriginale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimenti presenti nelle NormaEdizione legacy rimaste fuori da NormaFamiglia.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'RiferimentiEdizioneLegacy';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codici legacy Nxx/PPA o equivalenti associati al residuo.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'CodiciLegacy';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero di righe Standard.NormaEdizione collegate al LegacyNormaFamigliaId.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'NumeroEdizioni';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Schema SQL target proposto per la futura entita'' di dominio.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'TargetSchemaProposto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC di creazione della riga.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stato della decisione funzionale: DA_VALIDARE, VALIDATO, MODELLATO o SCARTATO.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'StatoClassificazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''utente/applicazione che ha modificato la riga.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data e ora UTC dell''ultima modifica della riga.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''entita'' target definitiva quando sara'' creata o riconciliata.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'TargetId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Designazione normalizzata per confronto e decisione funzionale; non e'' una designazione normativa ufficiale.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'DesignazioneNormalizzata';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo legacy ancora presente su NormaEdizione/Identificativi/Organismi e non piu'' presente in Standard.NormaFamiglia. Non e'' una FK intenzionalmente.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'LegacyNormaFamigliaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Azione di modellazione consigliata per rimuovere il residuo dal modello legacy.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'AzioneProposta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione del dominio target verso cui modellare il residuo nel Modello B.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'DominioTargetProposto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se la classificazione e'' ancora utilizzabile nel percorso di migrazione.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Campo da compilare dopo verifica del responsabile di processo o del gruppo funzionale.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'DecisioneFunzionale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipologia funzionale proposta, ad esempio DECRETO_MINISTERIALE, DIRETTIVA_UE, REGOLAMENTO_UE, SCHEMA_PROPRIETARIO o DISCIPLINARE_SCHEMA.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'TipoOggettoProposto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata della classificazione del residuo normativo legacy.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'ModelBResiduoNormativoClassificazioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''utente/applicazione che ha creato la riga.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tabella target proposta o da creare nel modello definitivo.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'TargetTableProposta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Titolo o descrizione derivata dai dati legacy. Da validare prima dell''uso come titolo ufficiale.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'TitoloOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numero di righe Standard.NormaFamigliaOrganismo collegate al LegacyNormaFamigliaId.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'TABLE', @level1name = N'ModelBResiduoNormativoClassificazione', @level2type = N'COLUMN', @level2name = N'NumeroOrganismi';


GO

