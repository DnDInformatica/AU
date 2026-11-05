CREATE TABLE [ImportSIAC].[wrk_Sede_MB] (
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
    [rnMB]                BIGINT           NULL
);


GO

CREATE CLUSTERED INDEX [CX_Sede_MB]
    ON [ImportSIAC].[wrk_Sede_MB]([ChiaveBusinessHash] ASC, [SedeId] ASC, [SedeKeyNullHash] ASC, [SnapshotDate] ASC);


GO

