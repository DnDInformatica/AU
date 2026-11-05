CREATE TABLE [Standard].[DominioSemantico] (
    [DominioSemanticoId] INT                                         IDENTITY (1, 1) NOT NULL,
    [Codice]             NVARCHAR (120)                              NOT NULL,
    [Denominazione]      NVARCHAR (400)                              NOT NULL,
    [Descrizione]        NVARCHAR (2000)                             NULL,
    [IndiceOrdinamento]  INT                                         NULL,
    [Attivo]             BIT                                         CONSTRAINT [DF_DominioSemantico_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]      DATETIME2 (7)                               CONSTRAINT [DF_DominioSemantico_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]           INT                                         NULL,
    [DataModifica]       DATETIME2 (7)                               NULL,
    [ModificatoDa]       INT                                         NULL,
    [DataCancellazione]  DATETIME2 (7)                               NULL,
    [CancellatoDa]       INT                                         NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER                            CONSTRAINT [DF_DominioSemantico_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_DominioSemantico] PRIMARY KEY CLUSTERED ([DominioSemanticoId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[DominioSemanticoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_DominioSemantico_Codice]
    ON [Standard].[DominioSemantico]([Codice] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_DominioSemantico_CreatoDa]
    ON [Standard].[DominioSemantico]([CreatoDa] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell ultima modifica applicativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'DominioSemantico', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Denominazione leggibile del dominio semantico.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'DominioSemantico', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di attivazione del dominio semantico.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'DominioSemantico', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Vocabolario temporal dei domini semantici associabili alle classificazioni. Non rappresenta l applicabilita operativa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'DominioSemantico';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine del periodo di system-versioning gestito da Azure SQL.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'DominioSemantico', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'DominioSemantico', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio del periodo di system-versioning gestito da Azure SQL.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'DominioSemantico', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica; NULL per il record corrente.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'DominioSemantico', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'DominioSemantico', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ordine di presentazione del vocabolario.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'DominioSemantico', @level2type = N'COLUMN', @level2name = N'IndiceOrdinamento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice canonico e stabile del dominio, indipendente dalla fonte della classificazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'DominioSemantico', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'DominioSemantico', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo interno del dominio semantico.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'DominioSemantico', @level2type = N'COLUMN', @level2name = N'DominioSemanticoId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descrizione del perimetro concettuale del dominio.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'DominioSemantico', @level2type = N'COLUMN', @level2name = N'Descrizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore GUID stabile della riga.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'DominioSemantico', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell utente che ha effettuato l ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'DominioSemantico', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

