CREATE TABLE [ImportSIAC].[NormaFPCMap] (
    [NormaFPCMapId]                   INT            IDENTITY (1, 1) NOT NULL,
    [NormCodeSiac]                    NVARCHAR (50)  NOT NULL,
    [NormaAccreditamentoId]           INT            NOT NULL,
    [Note]                            NVARCHAR (500) NULL,
    [DataCreazione]                   DATETIME2 (7)  CONSTRAINT [DF_NFM_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CodiceSuccessore]                NVARCHAR (20)  NULL,
    [NormaAccreditamentoIdSuccessore] INT            NULL,
    CONSTRAINT [PK_NormaFPCMap] PRIMARY KEY CLUSTERED ([NormaFPCMapId] ASC),
    CONSTRAINT [UQ_NormaFPCMap_NormCode] UNIQUE NONCLUSTERED ([NormCodeSiac] ASC)
);


GO

