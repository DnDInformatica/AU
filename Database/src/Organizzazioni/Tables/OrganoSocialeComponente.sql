CREATE TABLE [Organizzazioni].[OrganoSocialeComponente] (
    [OrganoSocialeComponenteId]        INT                                                IDENTITY (1, 1) NOT NULL,
    [OrganoSocialeId]                  INT                                                NOT NULL,
    [PersonaId]                        INT                                                NOT NULL,
    [OrganizzazioneRappresentataId]    INT                                                NULL,
    [OrganizzazioneRappresentataTesto] NVARCHAR (250)                                     NULL,
    [Ruolo]                            NVARCHAR (150)                                     NOT NULL,
    [Posizione]                        INT                                                NULL,
    [CodiceInvio]                      NVARCHAR (20)                                      NULL,
    [Principale]                       BIT                                                DEFAULT ((0)) NOT NULL,
    [DataInizio]                       DATE                                               NULL,
    [DataFine]                         DATE                                               NULL,
    [Note]                             NVARCHAR (2000)                                    NULL,
    [DataCreazione]                    DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                         INT                                                NULL,
    [DataModifica]                     DATETIME2 (7)                                      NULL,
    [ModificatoDa]                     INT                                                NULL,
    [DataCancellazione]                DATETIME2 (7)                                      NULL,
    [CancellatoDa]                     INT                                                NULL,
    [UniqueRowId]                      UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]               DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]                 DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_OrganoSocialeComponente] PRIMARY KEY CLUSTERED ([OrganoSocialeComponenteId] ASC),
    CONSTRAINT [FK_OrganoSocialeComponente_OrganizzazioneRappresentata] FOREIGN KEY ([OrganizzazioneRappresentataId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId]),
    CONSTRAINT [FK_OrganoSocialeComponente_OrganoSociale] FOREIGN KEY ([OrganoSocialeId]) REFERENCES [Organizzazioni].[OrganoSociale] ([OrganoSocialeId]),
    CONSTRAINT [FK_OrganoSocialeComponente_Persona] FOREIGN KEY ([PersonaId]) REFERENCES [Persone].[Persona] ([PersonaId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Organizzazioni].[OrganoSocialeComponenteStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'CONFIGURAZIONE', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganoSocialeComponente';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Componente di un organo sociale con ruolo, posizione, organizzazione rappresentata e metadati di invio/convocazione.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganoSocialeComponente';


GO

