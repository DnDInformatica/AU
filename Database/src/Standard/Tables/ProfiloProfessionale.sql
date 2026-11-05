CREATE TABLE [Standard].[ProfiloProfessionale] (
    [ProfiloProfessionaleId]        INT                                                IDENTITY (1, 1) NOT NULL,
    [Codice]                        NVARCHAR (100)                                     NOT NULL,
    [OrigineSistema]                NVARCHAR (200)                                     CONSTRAINT [DF_StandardProfiloProfessionale_Origine] DEFAULT (N'SIDAC') NOT NULL,
    [ProfiloProfessionaleIdOrigine] INT                                                NULL,
    [Attivo]                        BIT                                                CONSTRAINT [DF_StandardProfiloProfessionale_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                 DATETIME2 (7)                                      CONSTRAINT [DF_StandardProfiloProfessionale_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                      INT                                                NULL,
    [DataModifica]                  DATETIME2 (7)                                      NULL,
    [ModificatoDa]                  INT                                                NULL,
    [DataCancellazione]             DATETIME2 (7)                                      NULL,
    [CancellatoDa]                  INT                                                NULL,
    [UniqueRowId]                   UNIQUEIDENTIFIER                                   CONSTRAINT [DF_StandardProfiloProfessionale_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]            DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_StandardProfiloProfessionale_ValiditaInizio] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]              DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_StandardProfiloProfessionale_ValiditaFine] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_StandardProfiloProfessionale] PRIMARY KEY CLUSTERED ([ProfiloProfessionaleId] ASC),
    CONSTRAINT [CK_StandardProfiloProfessionale_Cancellazione] CHECK ([DataCancellazione] IS NULL AND [CancellatoDa] IS NULL OR [DataCancellazione] IS NOT NULL),
    CONSTRAINT [CK_StandardProfiloProfessionale_Codice] CHECK (len(ltrim(rtrim([Codice])))>(0)),
    CONSTRAINT [CK_StandardProfiloProfessionale_IdOrigine] CHECK ([ProfiloProfessionaleIdOrigine] IS NULL OR [ProfiloProfessionaleIdOrigine]>(0)),
    CONSTRAINT [CK_StandardProfiloProfessionale_Origine] CHECK (len(ltrim(rtrim([OrigineSistema])))>(0)),
    CONSTRAINT [UQ_StandardProfiloProfessionale_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[ProfiloProfessionaleStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_StandardProfiloProfessionale_Codice]
    ON [Standard].[ProfiloProfessionale]([Codice] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_StandardProfiloProfessionale_Origine]
    ON [Standard].[ProfiloProfessionale]([OrigineSistema] ASC, [ProfiloProfessionaleIdOrigine] ASC) WHERE ([ProfiloProfessionaleIdOrigine] IS NOT NULL AND [DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_StandardProfiloProfessionale_DataCancellazione]
    ON [Standard].[ProfiloProfessionale]([DataCancellazione] ASC)
    INCLUDE([Codice], [Attivo]) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_StandardProfiloProfessionale_CreatoDa]
    ON [Standard].[ProfiloProfessionale]([CreatoDa] ASC) WHERE ([CreatoDa] IS NOT NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''autore della creazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine tecnica della validita temporal SQL.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identita canonica e stabile di una figura professionale certificabile nel dominio FPC.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sistema o tabella da cui proviene l''identita durante la riconciliazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'OrigineSistema';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante UTC della cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo tecnico dell''identita canonica del profilo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'ProfiloProfessionaleId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante UTC dell''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo del profilo nel sistema di origine; non e una FK canonica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'ProfiloProfessionaleIdOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''autore della cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice canonico e univoco del profilo professionale.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo univoco della riga per integrazioni distribuite.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se la riga e utilizzabile nei processi correnti.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istante UTC di creazione della riga.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio tecnico della validita temporal SQL.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativo dell''autore dell''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ProfiloProfessionale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

