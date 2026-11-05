CREATE TABLE [Organizzazioni].[OrganoSociale] (
    [OrganoSocialeId]    INT                                                IDENTITY (1, 1) NOT NULL,
    [OrganizzazioneId]   INT                                                NOT NULL,
    [Codice]             NVARCHAR (50)                                      NOT NULL,
    [Denominazione]      NVARCHAR (250)                                     NOT NULL,
    [Descrizione]        NVARCHAR (1000)                                    NULL,
    [CategoriaOrgano]    NVARCHAR (100)                                     NULL,
    [Attivo]             BIT                                                DEFAULT ((1)) NOT NULL,
    [FlagDelibereCSA]    BIT                                                DEFAULT ((0)) NOT NULL,
    [DataInizio]         DATE                                               NULL,
    [DataFine]           DATE                                               NULL,
    [Note]               NVARCHAR (2000)                                    NULL,
    [DataCreazione]      DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]           INT                                                NULL,
    [DataModifica]       DATETIME2 (7)                                      NULL,
    [ModificatoDa]       INT                                                NULL,
    [DataCancellazione]  DATETIME2 (7)                                      NULL,
    [CancellatoDa]       INT                                                NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_OrganoSociale] PRIMARY KEY CLUSTERED ([OrganoSocialeId] ASC),
    CONSTRAINT [FK_OrganoSociale_Organizzazione] FOREIGN KEY ([OrganizzazioneId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId]),
    CONSTRAINT [UQ_OrganoSociale_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Organizzazioni].[OrganoSocialeStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Organo sociale di una organizzazione, ad esempio Assemblea, Consiglio Direttivo, Comitato o Organismo di Vigilanza.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganoSociale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'CONFIGURAZIONE', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganoSociale';


GO

