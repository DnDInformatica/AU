CREATE TABLE [Tipologica].[FasciaLivelloDigComp] (
    [FasciaLivelloDigCompId] INT                                         NOT NULL,
    [ScalaLivelloDigCompId]  INT                                         NOT NULL,
    [Codice]                 NVARCHAR (40)                               NOT NULL,
    [Descrizione]            NVARCHAR (400)                              NOT NULL,
    [DescrizioneEng]         NVARCHAR (400)                              NULL,
    [Ordine]                 INT                                         NULL,
    [Attivo]                 BIT                                         CONSTRAINT [DF_FasciaLDC_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]          DATETIME2 (7)                               CONSTRAINT [DF_FasciaLDC_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]               INT                                         NULL,
    [DataModifica]           DATETIME2 (7)                               NULL,
    [ModificatoDa]           INT                                         NULL,
    [DataCancellazione]      DATETIME2 (7)                               NULL,
    [CancellatoDa]           INT                                         NULL,
    [UniqueRowId]            UNIQUEIDENTIFIER                            CONSTRAINT [DF_FasciaLDC_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]     DATETIME2 (7) GENERATED ALWAYS AS ROW START CONSTRAINT [DF_FasciaLivelloDigComp_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW END   CONSTRAINT [DF_FasciaLivelloDigComp_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_FasciaLivelloDigComp] PRIMARY KEY CLUSTERED ([FasciaLivelloDigCompId] ASC),
    CONSTRAINT [FK_FasciaLivelloDigComp_Scala] FOREIGN KEY ([ScalaLivelloDigCompId]) REFERENCES [Tipologica].[ScalaLivelloDigComp] ([ScalaLivelloDigCompId]),
    CONSTRAINT [UQ_FasciaLDC_Id_Scala] UNIQUE NONCLUSTERED ([FasciaLivelloDigCompId] ASC, [ScalaLivelloDigCompId] ASC),
    CONSTRAINT [UQ_FasciaLivelloDigComp] UNIQUE NONCLUSTERED ([ScalaLivelloDigCompId] ASC, [Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Tipologica].[FasciaLivelloDigCompStorico], DATA_CONSISTENCY_CHECK=ON));


GO

