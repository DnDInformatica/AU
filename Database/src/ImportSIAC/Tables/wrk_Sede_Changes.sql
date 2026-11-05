CREATE TABLE [ImportSIAC].[wrk_Sede_Changes] (
    [ChiaveBusinessHash]  BINARY (32)      NULL,
    [NumeroCertificato]   NVARCHAR (200)   NULL,
    [OrganizzazioneODCId] INT              NULL,
    [DataPrimoRilascio]   DATE             NULL,
    [SnapshotDate]        DATE             NULL,
    [SnapshotBusinessTs]  DATETIME2 (7)    NULL,
    [address]             NVARCHAR (1000)  NULL,
    [city]                NVARCHAR (400)   NULL,
    [zip]                 NVARCHAR (100)   NULL,
    [SedeId]              INT              NULL,
    [AmbitoIta]           NVARCHAR (MAX)   NULL,
    [AmbitoEng]           NVARCHAR (MAX)   NULL,
    [DataScadenzaSede]    DATE             NULL,
    [RowSig]              VARBINARY (8000) NULL,
    [SedeKeyNull]         NVARCHAR (1502)  NOT NULL,
    [SedeKeyNullHash]     VARBINARY (8000) NULL,
    [rnMB]                BIGINT           NULL,
    [PrevRowSig]          VARBINARY (8000) NULL,
    [MaxSnapshotDate]     DATE             NULL,
    [LastObsBusinessTs]   DATETIME2 (7)    NULL,
    [MaxSnapshotDateCert] DATE             NULL
);


GO

