CREATE TABLE [ImportSIAC].[MapNormaAccreditamento] (
    [MapNormaAccreditamentoId]    INT             IDENTITY (1, 1) NOT NULL,
    [SistemaOrigine]              NVARCHAR (50)   NOT NULL,
    [SourceValue]                 NVARCHAR (200)  NOT NULL,
    [NormalizedValue]             NVARCHAR (500)  NULL,
    [TargetNormaAccreditamentoId] INT             NULL,
    [TargetNormaEdizioneId]       INT             NULL,
    [IsApproved]                  BIT             CONSTRAINT [DF_MapNorma_Appr] DEFAULT ((0)) NOT NULL,
    [Notes]                       NVARCHAR (1000) NULL,
    [DataCreazione]               DATETIME2 (7)   CONSTRAINT [DF_MapNorma_Data] DEFAULT (sysutcdatetime()) NOT NULL,
    PRIMARY KEY CLUSTERED ([MapNormaAccreditamentoId] ASC),
    CONSTRAINT [FK_MapNorma_NormaAccr] FOREIGN KEY ([TargetNormaAccreditamentoId]) REFERENCES [Standard].[NormaAccreditamento] ([NormaAccreditamentoId])
);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_MapNorma_Sistema_Source]
    ON [ImportSIAC].[MapNormaAccreditamento]([SistemaOrigine] ASC, [SourceValue] ASC);


GO

