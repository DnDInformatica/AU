CREATE TABLE [Tipologica].[ScalaLivelloDigComp] (
    [ScalaLivelloDigCompId] INT                                         NOT NULL,
    [Codice]                NVARCHAR (40)                               NOT NULL,
    [Descrizione]           NVARCHAR (400)                              NOT NULL,
    [DescrizioneEng]        NVARCHAR (400)                              NULL,
    [NormaRiferimento]      NVARCHAR (200)                              NULL,
    [ValoreMinimo]          NVARCHAR (20)                               NULL,
    [ValoreMassimo]         NVARCHAR (20)                               NULL,
    [Ordine]                INT                                         NULL,
    [Attivo]                BIT                                         CONSTRAINT [DF_ScalaLDC_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]         DATETIME2 (7)                               CONSTRAINT [DF_ScalaLDC_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]              INT                                         NULL,
    [DataModifica]          DATETIME2 (7)                               NULL,
    [ModificatoDa]          INT                                         NULL,
    [DataCancellazione]     DATETIME2 (7)                               NULL,
    [CancellatoDa]          INT                                         NULL,
    [UniqueRowId]           UNIQUEIDENTIFIER                            CONSTRAINT [DF_ScalaLDC_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]    DATETIME2 (7) GENERATED ALWAYS AS ROW START CONSTRAINT [DF_ScalaLivelloDigComp_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]      DATETIME2 (7) GENERATED ALWAYS AS ROW END   CONSTRAINT [DF_ScalaLivelloDigComp_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_ScalaLivelloDigComp] PRIMARY KEY CLUSTERED ([ScalaLivelloDigCompId] ASC),
    CONSTRAINT [UQ_ScalaLivelloDigComp_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Tipologica].[ScalaLivelloDigCompStorico], DATA_CONSISTENCY_CHECK=ON));


GO

