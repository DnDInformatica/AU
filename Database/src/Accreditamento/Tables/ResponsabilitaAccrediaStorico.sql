CREATE TABLE [Accreditamento].[ResponsabilitaAccrediaStorico] (
    [ResponsabilitaAccrediaId] INT            NOT NULL,
    [UnitaOrganizzativaId]     INT            NOT NULL,
    [TipoResponsabilita]       NVARCHAR (50)  NOT NULL,
    [PersonaId]                INT            NULL,
    [DataInizio]               DATETIME2 (7)  NOT NULL,
    [DataFine]                 DATETIME2 (7)  NULL,
    [Note]                     NVARCHAR (MAX) NULL,
    [DataCreazione]            DATETIME2 (7)  NOT NULL,
    [CreatoDa]                 INT            NULL,
    [DataModifica]             DATETIME2 (7)  NULL,
    [ModificatoDa]             INT            NULL,
    [DataCancellazione]        DATETIME2 (7)  NULL,
    [CancellatoDa]             INT            NULL,
    [DataInizioValidita]       DATETIME2 (7)  NOT NULL,
    [DataFineValidita]         DATETIME2 (7)  NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ResponsabilitaAccrediaStorico]
    ON [Accreditamento].[ResponsabilitaAccrediaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

