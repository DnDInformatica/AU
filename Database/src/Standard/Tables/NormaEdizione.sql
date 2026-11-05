CREATE TABLE [Standard].[NormaEdizione] (
    [NormaEdizioneId]           INT                                                IDENTITY (1, 1) NOT NULL,
    [NormaFamigliaId]           INT                                                NOT NULL,
    [NormaAccreditamentoId]     INT                                                NULL,
    [CodiceVersione]            NVARCHAR (50)                                      NULL,
    [Riferimento]               NVARCHAR (300)                                     NOT NULL,
    [AnnoEdizione]              SMALLINT                                           NULL,
    [NumeroParte]               NVARCHAR (30)                                      NULL,
    [Amendment]                 NVARCHAR (50)                                      NULL,
    [TitoloIta]                 NVARCHAR (1000)                                    NULL,
    [TitoloEng]                 NVARCHAR (1000)                                    NULL,
    [StatoNormaId]              INT                                                NOT NULL,
    [TipoNormaAccreditamentoId] INT                                                NOT NULL,
    [CategoriaFonteNormaId]     INT                                                NOT NULL,
    [Attivo]                    BIT                                                DEFAULT ((1)) NOT NULL,
    [DataPubblicazione]         DATE                                               NULL,
    [DataRitiro]                DATE                                               NULL,
    [DataInizioTransizione]     DATE                                               NULL,
    [DataFineTransizione]       DATE                                               NULL,
    [LineaEditoriale]           NVARCHAR (100)                                     NULL,
    [TipoRecepimentoNorma]      NVARCHAR (50)                                      NULL,
    [SequenzaNormativa]         INT                                                NULL,
    [DataCreazione]             DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                  INT                                                NULL,
    [DataModifica]              DATETIME2 (7)                                      NULL,
    [ModificatoDa]              INT                                                NULL,
    [DataCancellazione]         DATETIME2 (7)                                      NULL,
    [CancellatoDa]              INT                                                NULL,
    [UniqueRowId]               UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]        DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]          DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_NormaEdizione] PRIMARY KEY CLUSTERED ([NormaEdizioneId] ASC),
    CONSTRAINT [CK_NormaEdizione_Anno] CHECK ([AnnoEdizione] IS NULL OR [AnnoEdizione]>=(1900) AND [AnnoEdizione]<=(2100)),
    CONSTRAINT [CK_NormaEdizione_Riferimento] CHECK (len(ltrim(rtrim([Riferimento])))>(0)),
    CONSTRAINT [CK_NormaEdizione_Ritiro] CHECK ([DataPubblicazione] IS NULL OR [DataRitiro] IS NULL OR [DataPubblicazione]<=[DataRitiro]),
    CONSTRAINT [CK_NormaEdizione_Transizione] CHECK ([DataInizioTransizione] IS NULL OR [DataFineTransizione] IS NULL OR [DataInizioTransizione]<=[DataFineTransizione]),
    CONSTRAINT [FK_NormaEdizione_CategoriaFonte] FOREIGN KEY ([CategoriaFonteNormaId]) REFERENCES [Standard].[CategoriaFonteNorma] ([CategoriaFonteNormaId]),
    CONSTRAINT [FK_NormaEdizione_StatoNorma] FOREIGN KEY ([StatoNormaId]) REFERENCES [Standard].[StatoNorma] ([StatoNormaId]),
    CONSTRAINT [FK_NormaEdizione_TipoNorma] FOREIGN KEY ([TipoNormaAccreditamentoId]) REFERENCES [Standard].[TipoNormaAccreditamento] ([TipoNormaAccreditamentoId]),
    CONSTRAINT [UQ_NormaEdizione_Riferimento] UNIQUE NONCLUSTERED ([Riferimento] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[NormaEdizioneStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stato dell''edizione normativa: vigente, ritirata, sostituita, in transizione o altro stato codificato. E lo stato da usare nei controlli target, non lo stato legacy di NormaAccreditamento.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizione', @level2type = N'COLUMN', @level2name = N'StatoNormaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave surrogata dell''edizione normativa nel Modello B target. Questa e la FK da preferire nei domini operativi quando serve identificare con certezza la norma/schema applicabile.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizione', @level2type = N'COLUMN', @level2name = N'NormaEdizioneId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio validita business del record in SIDAC. Distinto da DataPubblicazione, entrata in vigore normativa e inizio transizione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizione', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Anno dell''edizione normativa. Campo informativo e di ricerca; non identifica da solo l''edizione e non gestisce emendamenti, rettifiche o recepimenti nazionali.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizione', @level2type = N'COLUMN', @level2name = N'AnnoEdizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine validita business del record in SIDAC. Distinta da DataRitiro e DataFineTransizione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizione', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Titolo italiano dell''edizione. Puo differire dal titolo base della famiglia e deve essere usato quando si pubblica o si cita una specifica edizione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizione', @level2type = N'COLUMN', @level2name = N'TitoloIta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di inizio del periodo transitorio in cui piu edizioni possono essere applicabili contemporaneamente. Usare insieme a DataFineTransizione e alle relazioni fra edizioni.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizione', @level2type = N'COLUMN', @level2name = N'DataInizioTransizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di utilizzabilita del record nel sistema. Non sostituisce StatoNormaId, DataRitiro o le date di transizione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizione', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice interno o sorgente della specifica edizione. Deve essere interpretato insieme a NormaFamigliaId e Riferimento; non e una business key autonoma universale.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizione', @level2type = N'COLUMN', @level2name = N'CodiceVersione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di fine del periodo transitorio. Dopo questa data i controlli devono impedire o segnalare l''uso dell''edizione superata, salvo eccezioni documentate.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizione', @level2type = N'COLUMN', @level2name = N'DataFineTransizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento leggibile e univoco dell''edizione, ad esempio ISO 9001:2015 o UNI EN ISO 45001:2023. E la citazione operativa dell''edizione, ma le relazioni applicative devono usare NormaEdizioneId.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizione', @level2type = N'COLUMN', @level2name = N'Riferimento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di pubblicazione dell''edizione normativa, quando disponibile. Distinta dalla data di registrazione nel sistema e dalla validita business SIDAC.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizione', @level2type = N'COLUMN', @level2name = N'DataPubblicazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.TipoNormaAccreditamento. Classifica il ruolo dell''edizione: norma di accreditamento CAB, schema/norma di certificazione o norma con ruolo duplice. Serve a evitare confusione tra ISO/IEC 17024 e norme professionali/schemi certificabili.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizione', @level2type = N'COLUMN', @level2name = N'TipoNormaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.NormaFamiglia. Collega l''edizione alla famiglia normativa stabile. Piu edizioni possono appartenere alla stessa famiglia e coesistere durante periodi transitori.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizione', @level2type = N'COLUMN', @level2name = N'NormaFamigliaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di ritiro dell''edizione normativa, quando disponibile. Non equivale automaticamente alla fine di validita business o alla fine transizione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizione', @level2type = N'COLUMN', @level2name = N'DataRitiro';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK verso Standard.CategoriaFonteNorma. Classifica la fonte dell''edizione: quadro normativo di accreditamento, normativa europea, normativa italiana, standard internazionale, schema proprietario o altra categoria codificata.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizione', @level2type = N'COLUMN', @level2name = N'CategoriaFonteNormaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Bridge transitorio verso il Modello A legacy Standard.NormaAccreditamento. NULL indica edizione senza corrispondenza legacy. Da non usare come chiave funzionale target; previsto per migrazione, riconciliazione e compatibilita fino alla dismissione del Modello A.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizione', @level2type = N'COLUMN', @level2name = N'NormaAccreditamentoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Titolo inglese dell''edizione. Puo differire dal titolo base della famiglia e deve essere usato quando si pubblica o si cita una specifica edizione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaEdizione', @level2type = N'COLUMN', @level2name = N'TitoloEng';


GO

