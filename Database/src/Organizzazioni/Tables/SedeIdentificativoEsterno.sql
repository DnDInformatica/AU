CREATE TABLE [Organizzazioni].[SedeIdentificativoEsterno] (
    [SedeIdentificativoEsternoId] BIGINT                                      IDENTITY (1, 1) NOT NULL,
    [SedeId]                      INT                                         NOT NULL,
    [TipoIdentificativoEsternoId] INT                                         NOT NULL,
    [Valore]                      NVARCHAR (200)                              NOT NULL,
    [ValoreNormalizzato]          NVARCHAR (200)                              NOT NULL,
    [DataInizioEffetto]           DATE                                        NULL,
    [DataFineEffetto]             DATE                                        NULL,
    [Principale]                  BIT                                         CONSTRAINT [DF_SedeIdentEst_Principale] DEFAULT ((0)) NOT NULL,
    [Verificato]                  BIT                                         CONSTRAINT [DF_SedeIdentEst_Verificato] DEFAULT ((0)) NOT NULL,
    [MetodoVerifica]              NVARCHAR (120)                              NULL,
    [Fonte]                       NVARCHAR (400)                              NULL,
    [Note]                        NVARCHAR (2000)                             NULL,
    [DataCreazione]               DATETIME2 (7)                               CONSTRAINT [DF_SedeIdentEst_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                    INT                                         NULL,
    [DataModifica]                DATETIME2 (7)                               NULL,
    [ModificatoDa]                INT                                         NULL,
    [DataCancellazione]           DATETIME2 (7)                               NULL,
    [CancellatoDa]                INT                                         NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER                            CONSTRAINT [DF_SedeIdentEst_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]          DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]            DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_SedeIdentEst] PRIMARY KEY CLUSTERED ([SedeIdentificativoEsternoId] ASC),
    CONSTRAINT [CK_SedeIdentEst_Date] CHECK ([DataFineEffetto] IS NULL OR [DataInizioEffetto] IS NULL OR [DataFineEffetto]>=[DataInizioEffetto]),
    CONSTRAINT [FK_SedeIdentEst_Sede] FOREIGN KEY ([SedeId]) REFERENCES [Organizzazioni].[Sede] ([SedeId]),
    CONSTRAINT [FK_SedeIdentEst_Tipo] FOREIGN KEY ([TipoIdentificativoEsternoId]) REFERENCES [Tipologica].[TipoIdentificativoEsterno] ([TipoIdentificativoEsternoId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Organizzazioni].[SedeIdentificativoEsternoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_SedeIdentEst_Attivo]
    ON [Organizzazioni].[SedeIdentificativoEsterno]([SedeId] ASC, [TipoIdentificativoEsternoId] ASC, [ValoreNormalizzato] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_SedeIdentEst_Ricerca]
    ON [Organizzazioni].[SedeIdentificativoEsterno]([TipoIdentificativoEsternoId] ASC, [ValoreNormalizzato] ASC)
    INCLUDE([SedeId], [Verificato]) WHERE ([DataCancellazione] IS NULL);


GO

CREATE   TRIGGER Organizzazioni.TR_SedeIdentificativoEsterno_Ambito ON Organizzazioni.SedeIdentificativoEsterno AFTER INSERT,UPDATE AS
BEGIN SET NOCOUNT ON; IF EXISTS(SELECT 1 FROM inserted i JOIN Tipologica.TipoIdentificativoEsterno t ON t.TipoIdentificativoEsternoId=i.TipoIdentificativoEsternoId WHERE t.AmbitoIdentificativo<>N'SEDE') THROW 52203,N'Tipologia non applicabile a una sede.',1; END;

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativi esterni di luoghi fisici o unita locali; ammette solo tipologie con ambito SEDE.', @level0type = N'SCHEMA', @level0name = N'Organizzazioni', @level1type = N'TABLE', @level1name = N'SedeIdentificativoEsterno';


GO

