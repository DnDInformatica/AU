CREATE TABLE [ImportSIAC].[wrk_FPC_MappaLivello] (
    [ProfiloCodice]    NVARCHAR (10)  NOT NULL,
    [ValoreAtteso]     NVARCHAR (500) NULL,
    [LivelloDigCompId] TINYINT        NULL
);


GO

CREATE UNIQUE CLUSTERED INDEX [CX_FPC_MappaLivello]
    ON [ImportSIAC].[wrk_FPC_MappaLivello]([ProfiloCodice] ASC, [ValoreAtteso] ASC);


GO

