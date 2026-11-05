CREATE TABLE [ImportSIAC].[MIG163_BaselinePre] (
    [SedeFinal_Righe]                BIGINT        NULL,
    [CertSede_Righe]                 BIGINT        NULL,
    [SedeFinal_Identita]             INT           NULL,
    [SedeFinal_Impronta]             INT           NULL,
    [MaxIntervalliPerIdentita]       BIGINT        NULL,
    [Correnti]                       INT           NULL,
    [IntervalliNonPositivi]          BIGINT        NULL,
    [CertSede_IntervalliNonPositivi] BIGINT        NULL,
    [CongelataIl]                    DATETIME2 (7) NOT NULL,
    [Origine]                        NVARCHAR (50) NULL
);


GO

