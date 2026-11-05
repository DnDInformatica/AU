CREATE TABLE [Organizzazioni].[UnitaOrganizzativaIdentificativoEsternoStorico] (
    [UnitaOrganizzativaIdentificativoEsternoId] BIGINT           NOT NULL,
    [UnitaOrganizzativaId]                      INT              NOT NULL,
    [TipoIdentificativoEsternoId]               INT              NOT NULL,
    [Valore]                                    NVARCHAR (200)   NOT NULL,
    [ValoreNormalizzato]                        NVARCHAR (200)   NOT NULL,
    [DataInizioEffetto]                         DATE             NULL,
    [DataFineEffetto]                           DATE             NULL,
    [Principale]                                BIT              NOT NULL,
    [Verificato]                                BIT              NOT NULL,
    [MetodoVerifica]                            NVARCHAR (120)   NULL,
    [Fonte]                                     NVARCHAR (400)   NULL,
    [Note]                                      NVARCHAR (2000)  NULL,
    [DataCreazione]                             DATETIME2 (7)    NOT NULL,
    [CreatoDa]                                  INT              NULL,
    [DataModifica]                              DATETIME2 (7)    NULL,
    [ModificatoDa]                              INT              NULL,
    [DataCancellazione]                         DATETIME2 (7)    NULL,
    [CancellatoDa]                              INT              NULL,
    [UniqueRowId]                               UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                        DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                          DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_UnitaOrganizzativaIdentificativoEsternoStorico]
    ON [Organizzazioni].[UnitaOrganizzativaIdentificativoEsternoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

