CREATE TABLE [ImportSIAC].[MIG147_FingerprintPre] (
    [Dominio]        NVARCHAR (3)  NULL,
    [Righe]          BIGINT        NULL,
    [FallbackNorme]  BIGINT        NULL,
    [ClienteNonNull] INT           NULL,
    [SumODC]         BIGINT        NULL,
    [SumTipoCert]    BIGINT        NULL,
    [SumNorma]       BIGINT        NULL,
    [SumTipoQual]    BIGINT        NULL,
    [SumCliente]     BIGINT        NULL,
    [MinTs]          DATETIME2 (7) NULL,
    [MaxTs]          DATETIME2 (7) NULL,
    [Firma]          INT           NULL
);


GO

