CREATE TABLE [Organizzazioni].[UnitaOrganizzativaIdentificativoEsterno] (
    [UnitaOrganizzativaIdentificativoEsternoId] BIGINT                                      IDENTITY (1, 1) NOT NULL,
    [UnitaOrganizzativaId]                      INT                                         NOT NULL,
    [TipoIdentificativoEsternoId]               INT                                         NOT NULL,
    [Valore]                                    NVARCHAR (200)                              NOT NULL,
    [ValoreNormalizzato]                        NVARCHAR (200)                              NOT NULL,
    [DataInizioEffetto]                         DATE                                        NULL,
    [DataFineEffetto]                           DATE                                        NULL,
    [Principale]                                BIT                                         CONSTRAINT [DF_UnitaOrgIdentEst_Principale] DEFAULT ((0)) NOT NULL,
    [Verificato]                                BIT                                         CONSTRAINT [DF_UnitaOrgIdentEst_Verificato] DEFAULT ((0)) NOT NULL,
    [MetodoVerifica]                            NVARCHAR (120)                              NULL,
    [Fonte]                                     NVARCHAR (400)                              NULL,
    [Note]                                      NVARCHAR (2000)                             NULL,
    [DataCreazione]                             DATETIME2 (7)                               CONSTRAINT [DF_UnitaOrgIdentEst_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                                  INT                                         NULL,
    [DataModifica]                              DATETIME2 (7)                               NULL,
    [ModificatoDa]                              INT                                         NULL,
    [DataCancellazione]                         DATETIME2 (7)                               NULL,
    [CancellatoDa]                              INT                                         NULL,
    [UniqueRowId]                               UNIQUEIDENTIFIER                            CONSTRAINT [DF_UnitaOrgIdentEst_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]                          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_UnitaOrgIdentEst] PRIMARY KEY CLUSTERED ([UnitaOrganizzativaIdentificativoEsternoId] ASC),
    CONSTRAINT [CK_UnitaOrgIdentEst_Date] CHECK ([DataFineEffetto] IS NULL OR [DataInizioEffetto] IS NULL OR [DataFineEffetto]>=[DataInizioEffetto]),
    CONSTRAINT [FK_UnitaOrgIdentEst_Tipo] FOREIGN KEY ([TipoIdentificativoEsternoId]) REFERENCES [Tipologica].[TipoIdentificativoEsterno] ([TipoIdentificativoEsternoId]),
    CONSTRAINT [FK_UnitaOrgIdentEst_Unita] FOREIGN KEY ([UnitaOrganizzativaId]) REFERENCES [Organizzazioni].[UnitaOrganizzativa] ([UnitaOrganizzativaId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Organizzazioni].[UnitaOrganizzativaIdentificativoEsternoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_UnitaOrgIdentEst_Ricerca]
    ON [Organizzazioni].[UnitaOrganizzativaIdentificativoEsterno]([TipoIdentificativoEsternoId] ASC, [ValoreNormalizzato] ASC)
    INCLUDE([UnitaOrganizzativaId], [Verificato]) WHERE ([DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_UnitaOrgIdentEst_Attivo]
    ON [Organizzazioni].[UnitaOrganizzativaIdentificativoEsterno]([UnitaOrganizzativaId] ASC, [TipoIdentificativoEsternoId] ASC, [ValoreNormalizzato] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE   TRIGGER Organizzazioni.TR_UnitaOrganizzativaIdentificativoEsterno_Ambito ON Organizzazioni.UnitaOrganizzativaIdentificativoEsterno AFTER INSERT,UPDATE AS
BEGIN SET NOCOUNT ON; IF EXISTS(SELECT 1 FROM inserted i JOIN Tipologica.TipoIdentificativoEsterno t ON t.TipoIdentificativoEsternoId=i.TipoIdentificativoEsternoId WHERE t.AmbitoIdentificativo<>N'UNITA_ORGANIZZATIVA') THROW 52202,N'Tipologia non applicabile a una unita organizzativa.',1; END;

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativi esterni di divisioni, laboratori e altre unita organizzative; ammette solo tipologie con ambito UNITA_ORGANIZZATIVA.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'UnitaOrganizzativaIdentificativoEsterno';


GO

