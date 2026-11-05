CREATE TABLE [Organizzazioni].[OrganizzazioneIdentificativoEsterno] (
    [OrganizzazioneIdentificativoEsternoId] BIGINT                                      IDENTITY (1, 1) NOT NULL,
    [OrganizzazioneId]                      INT                                         NOT NULL,
    [TipoIdentificativoEsternoId]           INT                                         NOT NULL,
    [Valore]                                NVARCHAR (200)                              NOT NULL,
    [ValoreNormalizzato]                    NVARCHAR (200)                              NOT NULL,
    [DataInizioEffetto]                     DATE                                        NULL,
    [DataFineEffetto]                       DATE                                        NULL,
    [Principale]                            BIT                                         CONSTRAINT [DF_OrganizzazioneIdentificativoEsterno_Principale] DEFAULT ((0)) NOT NULL,
    [Verificato]                            BIT                                         CONSTRAINT [DF_OrganizzazioneIdentificativoEsterno_Verificato] DEFAULT ((0)) NOT NULL,
    [MetodoVerifica]                        NVARCHAR (60)                               NULL,
    [Fonte]                                 NVARCHAR (200)                              NULL,
    [Note]                                  NVARCHAR (2000)                             NULL,
    [DataCreazione]                         DATETIME2 (7)                               CONSTRAINT [DF_OrganizzazioneIdentificativoEsterno_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                              INT                                         NULL,
    [DataModifica]                          DATETIME2 (7)                               NULL,
    [ModificatoDa]                          INT                                         NULL,
    [DataCancellazione]                     DATETIME2 (7)                               NULL,
    [CancellatoDa]                          INT                                         NULL,
    [UniqueRowId]                           UNIQUEIDENTIFIER                            CONSTRAINT [DF_OrganizzazioneIdentificativoEsterno_UniqueRowId] DEFAULT (newsequentialid()) NOT NULL,
    [DataInizioValidita]                    DATETIME2 (7) GENERATED ALWAYS AS ROW START CONSTRAINT [DF_OrganizzazioneIdentificativoEsterno_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]                      DATETIME2 (7) GENERATED ALWAYS AS ROW END   CONSTRAINT [DF_OrganizzazioneIdentificativoEsterno_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_OrganizzazioneIdentificativoEsterno] PRIMARY KEY CLUSTERED ([OrganizzazioneIdentificativoEsternoId] ASC),
    CONSTRAINT [CK_OrgIdentEst_Date] CHECK ([DataFineEffetto] IS NULL OR [DataInizioEffetto] IS NULL OR [DataFineEffetto]>=[DataInizioEffetto]),
    CONSTRAINT [CK_OrgIdentEst_Valore] CHECK (len(ltrim(rtrim([Valore])))>(0)),
    CONSTRAINT [CK_OrgIdentEst_ValoreNormalizzato] CHECK (len(ltrim(rtrim([ValoreNormalizzato])))>(0)),
    CONSTRAINT [FK_OrgIdentEst_Organizzazione] FOREIGN KEY ([OrganizzazioneId]) REFERENCES [Organizzazioni].[Organizzazione] ([OrganizzazioneId]),
    CONSTRAINT [FK_OrgIdentEst_Tipo] FOREIGN KEY ([TipoIdentificativoEsternoId]) REFERENCES [Tipologica].[TipoIdentificativoEsterno] ([TipoIdentificativoEsternoId]),
    CONSTRAINT [UQ_OrganizzazioneIdentificativoEsterno_UniqueRowId] UNIQUE NONCLUSTERED ([UniqueRowId] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Organizzazioni].[OrganizzazioneIdentificativoEsternoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE NONCLUSTERED INDEX [IX_OrgIdentEst_Ricerca]
    ON [Organizzazioni].[OrganizzazioneIdentificativoEsterno]([TipoIdentificativoEsternoId] ASC, [ValoreNormalizzato] ASC)
    INCLUDE([OrganizzazioneId], [Verificato], [Principale], [DataInizioEffetto], [DataFineEffetto]) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_OrgIdentEst_Organizzazione]
    ON [Organizzazioni].[OrganizzazioneIdentificativoEsterno]([OrganizzazioneId] ASC)
    INCLUDE([TipoIdentificativoEsternoId], [Valore], [ValoreNormalizzato], [Verificato]) WHERE ([DataCancellazione] IS NULL);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_OrgIdentEst_OrgTipoValore_Attivo]
    ON [Organizzazioni].[OrganizzazioneIdentificativoEsterno]([OrganizzazioneId] ASC, [TipoIdentificativoEsternoId] ASC, [ValoreNormalizzato] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE   TRIGGER Organizzazioni.TR_OrganizzazioneIdentificativoEsterno_Ambito ON Organizzazioni.OrganizzazioneIdentificativoEsterno AFTER INSERT,UPDATE AS
BEGIN SET NOCOUNT ON; IF EXISTS(SELECT 1 FROM inserted i JOIN Tipologica.TipoIdentificativoEsterno t ON t.TipoIdentificativoEsternoId=i.TipoIdentificativoEsternoId WHERE t.AmbitoIdentificativo<>N'ORGANIZZAZIONE') THROW 52201,N'Tipologia non applicabile a una organizzazione.',1; END;

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativi esterni associati a un''organizzazione SIDAC, con fonte, verifica, validita'' funzionale e storicizzazione temporale.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'OrganizzazioneIdentificativoEsterno';


GO

