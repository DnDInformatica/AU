CREATE TABLE [ImportSIAC].[wrk_CertificazioniDettagliFonte] (
    [ChiaveBusinessHash]                  BINARY (32)    NULL,
    [Dominio]                             NVARCHAR (3)   NULL,
    [RawId]                               BIGINT         NULL,
    [OrganizzazioneODCId]                 INT            NULL,
    [SnapshotYear]                        SMALLINT       NULL,
    [SnapshotMonth]                       TINYINT        NULL,
    [SnapshotDate]                        DATE           NULL,
    [suspended]                           BIT            NULL,
    [prev_cert_number]                    NVARCHAR (200) NULL,
    [sector_code]                         NVARCHAR (100) NULL,
    [sector_code_secondary_accredited]    NVARCHAR (MAX) NULL,
    [sector_code_secondary_notaccredited] NVARCHAR (MAX) NULL
);


GO

CREATE UNIQUE CLUSTERED INDEX [CX_wrk_CertificazioniDettagliFonte]
    ON [ImportSIAC].[wrk_CertificazioniDettagliFonte]([ChiaveBusinessHash] ASC);


GO

