CREATE TABLE [ArchiveSIAC].[LegacyDecommissionManifest] (
    [LegacyDecommissionManifestId] INT             IDENTITY (1, 1) NOT NULL,
    [MigrationCode]                NVARCHAR (20)   NOT NULL,
    [SourceSchema]                 [sysname]       NOT NULL,
    [SourceTable]                  [sysname]       NOT NULL,
    [ArchiveSchema]                [sysname]       NOT NULL,
    [ArchiveTable]                 [sysname]       NOT NULL,
    [SnapshotAtUtc]                DATETIME2 (7)   NOT NULL,
    [SnapshotVerifiedAtUtc]        DATETIME2 (7)   NOT NULL,
    [SourceRows]                   BIGINT          NOT NULL,
    [ArchiveRows]                  BIGINT          NOT NULL,
    [RetentionPolicy]              NVARCHAR (1000) NOT NULL,
    [ExternalBackupReference]      NVARCHAR (1000) NULL,
    [ExternalBackupSHA256]         CHAR (64)       NULL,
    [ConsumerApprovalReference]    NVARCHAR (1000) NULL,
    [ApprovedBy]                   NVARCHAR (256)  NULL,
    [ApprovedAtUtc]                DATETIME2 (7)   NULL,
    [PhysicalDropAuthorized]       BIT             CONSTRAINT [DF_LegacyDecommissionManifest_Drop] DEFAULT ((0)) NOT NULL,
    [Note]                         NVARCHAR (2000) NULL,
    CONSTRAINT [PK_LegacyDecommissionManifest] PRIMARY KEY CLUSTERED ([LegacyDecommissionManifestId] ASC),
    CONSTRAINT [CK_LegacyDecommissionManifest_Authorization] CHECK ([PhysicalDropAuthorized]=(0) OR [ExternalBackupReference] IS NOT NULL AND [ExternalBackupSHA256] IS NOT NULL AND [ConsumerApprovalReference] IS NOT NULL AND [ApprovedBy] IS NOT NULL AND [ApprovedAtUtc] IS NOT NULL),
    CONSTRAINT [CK_LegacyDecommissionManifest_Rows] CHECK ([SourceRows]>=(0) AND [ArchiveRows]>=(0)),
    CONSTRAINT [CK_LegacyDecommissionManifest_SHA256] CHECK ([ExternalBackupSHA256] IS NULL OR len([ExternalBackupSHA256])=(64) AND NOT [ExternalBackupSHA256] like '%[^0-9A-Fa-f]%'),
    CONSTRAINT [UQ_LegacyDecommissionManifest_Source] UNIQUE NONCLUSTERED ([MigrationCode] ASC, [SourceSchema] ASC, [SourceTable] ASC)
);


GO

