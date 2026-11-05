CREATE TABLE [Organizzazioni].[OrganoSocialeComponenteStorico] (
    [OrganoSocialeComponenteId]        INT              NOT NULL,
    [OrganoSocialeId]                  INT              NOT NULL,
    [PersonaId]                        INT              NOT NULL,
    [OrganizzazioneRappresentataId]    INT              NULL,
    [OrganizzazioneRappresentataTesto] NVARCHAR (250)   NULL,
    [Ruolo]                            NVARCHAR (150)   NOT NULL,
    [Posizione]                        INT              NULL,
    [CodiceInvio]                      NVARCHAR (20)    NULL,
    [Principale]                       BIT              NOT NULL,
    [DataInizio]                       DATE             NULL,
    [DataFine]                         DATE             NULL,
    [Note]                             NVARCHAR (2000)  NULL,
    [DataCreazione]                    DATETIME2 (7)    NOT NULL,
    [CreatoDa]                         INT              NULL,
    [DataModifica]                     DATETIME2 (7)    NULL,
    [ModificatoDa]                     INT              NULL,
    [DataCancellazione]                DATETIME2 (7)    NULL,
    [CancellatoDa]                     INT              NULL,
    [UniqueRowId]                      UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]               DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                 DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_OrganoSocialeComponenteStorico]
    ON [Organizzazioni].[OrganoSocialeComponenteStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

