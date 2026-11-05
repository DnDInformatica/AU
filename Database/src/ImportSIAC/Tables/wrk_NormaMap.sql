CREATE TABLE [ImportSIAC].[wrk_NormaMap] (
    [norma_raw]             NVARCHAR (300) NULL,
    [NormaAccreditamentoId] INT            NULL
);


GO

CREATE UNIQUE CLUSTERED INDEX [CX_NormaMap]
    ON [ImportSIAC].[wrk_NormaMap]([norma_raw] ASC);


GO

