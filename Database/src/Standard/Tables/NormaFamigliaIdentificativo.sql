CREATE TABLE [Standard].[NormaFamigliaIdentificativo] (
    [NormaFamigliaIdentificativoId] INT                                                IDENTITY (1, 1) NOT NULL,
    [NormaFamigliaId]               INT                                                NOT NULL,
    [TipoIdentificativo]            NVARCHAR (100)                                     NOT NULL,
    [ValoreIdentificativo]          NVARCHAR (600)                                     NOT NULL,
    [OrigineSistema]                NVARCHAR (200)                                     NOT NULL,
    [NormaFamigliaIdOrigine]        INT                                                NULL,
    [CodiceFamigliaOrigine]         NVARCHAR (200)                                     NULL,
    [SiglaBaseOrigine]              NVARCHAR (400)                                     NULL,
    [TitoloBaseItaOrigine]          NVARCHAR (2000)                                    NULL,
    [Note]                          NVARCHAR (2000)                                    NULL,
    [Attivo]                        BIT                                                CONSTRAINT [DF_NormaFamigliaIdentificativo_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                 DATETIME2 (7)                                      CONSTRAINT [DF_NormaFamigliaIdentificativo_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                      INT                                                NULL,
    [DataModifica]                  DATETIME2 (7)                                      NULL,
    [ModificatoDa]                  INT                                                NULL,
    [DataCancellazione]             DATETIME2 (7)                                      NULL,
    [CancellatoDa]                  INT                                                NULL,
    [UniqueRowId]                   UNIQUEIDENTIFIER                                   CONSTRAINT [DF_NormaFamigliaIdentificativo_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]            DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]              DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_NormaFamigliaIdentificativo] PRIMARY KEY CLUSTERED ([NormaFamigliaIdentificativoId] ASC),
    CONSTRAINT [CK_NormaFamigliaIdentificativo_Origine] CHECK (len(ltrim(rtrim([OrigineSistema])))>(0)),
    CONSTRAINT [CK_NormaFamigliaIdentificativo_Tipo] CHECK (len(ltrim(rtrim([TipoIdentificativo])))>(0)),
    CONSTRAINT [CK_NormaFamigliaIdentificativo_Valore] CHECK (len(ltrim(rtrim([ValoreIdentificativo])))>(0)),
    CONSTRAINT [UQ_NormaFamigliaIdentificativo_TargetTipoValoreOrigine] UNIQUE NONCLUSTERED ([NormaFamigliaId] ASC, [TipoIdentificativo] ASC, [ValoreIdentificativo] ASC, [OrigineSistema] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[NormaFamigliaIdentificativoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativi legacy, interni o alternativi associati a una famiglia normativa canonica del Modello B.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaIdentificativo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Famiglia normativa canonica a cui appartiene l''identificativo.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaIdentificativo', @level2type = N'COLUMN', @level2name = N'NormaFamigliaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo dell''identificativo: CodiceFamigliaLegacy, SiglaBaseLegacy, NormaFamigliaIdLegacy o altro codice sorgente.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'NormaFamigliaIdentificativo', @level2type = N'COLUMN', @level2name = N'TipoIdentificativo';


GO

