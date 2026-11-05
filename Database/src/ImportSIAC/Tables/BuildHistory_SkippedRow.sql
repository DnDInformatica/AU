CREATE TABLE [ImportSIAC].[BuildHistory_SkippedRow] (
    [BuildHistorySkippedId] BIGINT         IDENTITY (1, 1) NOT NULL,
    [BuildHistoryLogId]     INT            NOT NULL,
    [Dominio]               NVARCHAR (3)   NOT NULL,
    [RawId]                 BIGINT         NOT NULL,
    [SnapshotYear]          SMALLINT       NOT NULL,
    [SnapshotMonth]         TINYINT        NOT NULL,
    [Codente]               NVARCHAR (150) NULL,
    [NumeroCertificato]     NVARCHAR (200) NULL,
    [MotivoScarto]          NVARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_BuildHistory_SkippedRow] PRIMARY KEY CLUSTERED ([BuildHistorySkippedId] ASC)
);


GO

