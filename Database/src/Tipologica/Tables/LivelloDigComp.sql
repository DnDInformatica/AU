CREATE TABLE [Tipologica].[LivelloDigComp] (
    [LivelloDigCompId]       TINYINT                                            NOT NULL,
    [Fascia]                 NVARCHAR (30)                                      NOT NULL,
    [DescrizioneIta]         NVARCHAR (100)                                     NOT NULL,
    [DescrizioneEng]         NVARCHAR (100)                                     NOT NULL,
    [ValoriSiacAttesi]       NVARCHAR (500)                                     NULL,
    [Attivo]                 BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]          DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]               INT                                                NULL,
    [DataModifica]           DATETIME2 (7)                                      NULL,
    [ModificatoDa]           INT                                                NULL,
    [DataCancellazione]      DATETIME2 (7)                                      NULL,
    [CancellatoDa]           INT                                                NULL,
    [UniqueRowId]            UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [TipoScala]              NVARCHAR (20)                                      DEFAULT ('DIGCOMP_1_8') NOT NULL,
    [DataInizioValidita]     DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_LivelloDigComp_DataInizioValidita] DEFAULT (sysutcdatetime()) NOT NULL,
    [DataFineValidita]       DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_LivelloDigComp_DataFineValidita] DEFAULT (CONVERT([datetime2](7),'9999-12-31 23:59:59.9999999')) NOT NULL,
    [ScalaLivelloDigCompId]  INT                                                NOT NULL,
    [FasciaLivelloDigCompId] INT                                                NOT NULL,
    CONSTRAINT [PK_LivelloDigComp] PRIMARY KEY CLUSTERED ([LivelloDigCompId] ASC),
    CONSTRAINT [FK_LivelloDigComp_Fascia] FOREIGN KEY ([FasciaLivelloDigCompId]) REFERENCES [Tipologica].[FasciaLivelloDigComp] ([FasciaLivelloDigCompId]),
    CONSTRAINT [FK_LivelloDigComp_FasciaCoerente] FOREIGN KEY ([FasciaLivelloDigCompId], [ScalaLivelloDigCompId]) REFERENCES [Tipologica].[FasciaLivelloDigComp] ([FasciaLivelloDigCompId], [ScalaLivelloDigCompId]),
    CONSTRAINT [FK_LivelloDigComp_Scala] FOREIGN KEY ([ScalaLivelloDigCompId]) REFERENCES [Tipologica].[ScalaLivelloDigComp] ([ScalaLivelloDigCompId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Tipologica].[LivelloDigCompStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Tipologica","table":"LivelloDigComp","temporal":true,"temporal_type":2,"history_table":"Tipologica.LivelloDigCompStorico","soft_delete":true,"audit":true,"doc":{"ms_description":"MS_Description"}}', @level0type = N'SCHEMA', @level0name = N'Tipologica', @level1type = N'TABLE', @level1name = N'LivelloDigComp';


GO

