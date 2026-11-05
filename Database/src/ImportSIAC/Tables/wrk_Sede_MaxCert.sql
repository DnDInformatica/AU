CREATE TABLE [ImportSIAC].[wrk_Sede_MaxCert] (
    [ChiaveBusinessHash]  BINARY (32) NULL,
    [MaxSnapshotDateCert] DATE        NULL
);


GO

CREATE CLUSTERED INDEX [CX_Sede_MaxCert]
    ON [ImportSIAC].[wrk_Sede_MaxCert]([ChiaveBusinessHash] ASC);


GO

