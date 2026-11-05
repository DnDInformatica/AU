CREATE TABLE [ImportSIAC].[wrk_PP_Sedi_Raw] (
    [NumeroCertificato]       NVARCHAR (200)  NULL,
    [OrganizzazioneODCId]     INT             NULL,
    [DataPrimoRilascio]       DATE            NULL,
    [SnapshotYear]            SMALLINT        NULL,
    [SnapshotMonth]           TINYINT         NULL,
    [SnapshotDate]            DATE            NULL,
    [SnapshotBusinessTs]      DATETIME2 (7)   NULL,
    [OrganizzazioneClienteId] INT             NULL,
    [address]                 NVARCHAR (1000) NULL,
    [city]                    NVARCHAR (400)  NULL,
    [zip]                     NVARCHAR (100)  NULL,
    [raw_site_type]           NVARCHAR (50)   NULL,
    [raw_site_province]       NVARCHAR (100)  NULL,
    [raw_site_country]        NVARCHAR (100)  NULL,
    [AmbitoIta]               NVARCHAR (MAX)  NULL,
    [AmbitoEng]               NVARCHAR (MAX)  NULL,
    [DataScadenzaSede]        DATE            NULL
);


GO

CREATE NONCLUSTERED INDEX [CX_PP_Sedi_Raw]
    ON [ImportSIAC].[wrk_PP_Sedi_Raw]([NumeroCertificato] ASC, [OrganizzazioneODCId] ASC, [DataPrimoRilascio] ASC, [SnapshotDate] ASC)
    INCLUDE([OrganizzazioneClienteId], [address], [city], [zip], [AmbitoIta], [AmbitoEng], [DataScadenzaSede]);


GO

