CREATE   VIEW ArchiveSIAC.vw_LegacyDecommissionGate
          AS
          WITH Conteggi AS
          (
              SELECT N'ProfiloProfessionale' AS SourceTable,
                     COUNT_BIG(*) AS SourceRowsNow,
                     (SELECT COUNT_BIG(*) FROM
                      ArchiveSIAC.Legacy_Certificazione_ProfiloProfessionale)
                     AS ArchiveRowsNow
              FROM Certificazione.ProfiloProfessionale
              UNION ALL
              SELECT N'ProfiloProfessionaleStorico', COUNT_BIG(*),
                     (SELECT COUNT_BIG(*) FROM
                      ArchiveSIAC.Legacy_Certificazione_ProfiloProfessionaleStorico)
              FROM Certificazione.ProfiloProfessionaleStorico
              UNION ALL
              SELECT N'ProfiloProfessionaleSpecificaTecnica', COUNT_BIG(*),
                     (SELECT COUNT_BIG(*) FROM
                      ArchiveSIAC.Legacy_Certificazione_ProfiloProfessionaleSpecificaTecnica)
              FROM Certificazione.ProfiloProfessionaleSpecificaTecnica
              UNION ALL
              SELECT N'ProfiloProfessionaleSpecificaTecnicaStorico',
                     COUNT_BIG(*),
                     (SELECT COUNT_BIG(*) FROM
                      ArchiveSIAC.Legacy_Certificazione_ProfiloProfessionaleSpecificaTecnicaStorico)
              FROM Certificazione.ProfiloProfessionaleSpecificaTecnicaStorico
              UNION ALL
              SELECT N'ProfiloProfessionaleRiferimentoNormativo',
                     COUNT_BIG(*),
                     (SELECT COUNT_BIG(*) FROM
                      ArchiveSIAC.Legacy_Certificazione_ProfiloProfessionaleRiferimentoNormativo)
              FROM Certificazione.ProfiloProfessionaleRiferimentoNormativo
              UNION ALL
              SELECT N'ProfiloProfessionaleRiferimentoNormativoStorico',
                     COUNT_BIG(*),
                     (SELECT COUNT_BIG(*) FROM
                      ArchiveSIAC.Legacy_Certificazione_ProfiloProfessionaleRiferimentoNormativoStorico)
              FROM Certificazione.ProfiloProfessionaleRiferimentoNormativoStorico
              UNION ALL
              SELECT N'ProfiloProfessionaleIdentificativo', COUNT_BIG(*),
                     (SELECT COUNT_BIG(*) FROM
                      ArchiveSIAC.Legacy_Certificazione_ProfiloProfessionaleIdentificativo)
              FROM Certificazione.ProfiloProfessionaleIdentificativo
              UNION ALL
              SELECT N'ProfiloProfessionaleIdentificativoStorico',
                     COUNT_BIG(*),
                     (SELECT COUNT_BIG(*) FROM
                      ArchiveSIAC.Legacy_Certificazione_ProfiloProfessionaleIdentificativoStorico)
              FROM Certificazione.ProfiloProfessionaleIdentificativoStorico
          )
          SELECT
              m.LegacyDecommissionManifestId,
              m.MigrationCode,
              QUOTENAME(m.SourceSchema) + N'.' + QUOTENAME(m.SourceTable)
                  AS SourceObject,
              QUOTENAME(m.ArchiveSchema) + N'.' + QUOTENAME(m.ArchiveTable)
                  AS ArchiveObject,
              m.SnapshotAtUtc,
              m.SourceRows,
              c.SourceRowsNow,
              m.ArchiveRows,
              c.ArchiveRowsNow,
              CASE
                  WHEN m.SourceRows = c.SourceRowsNow
                   AND m.ArchiveRows = c.ArchiveRowsNow
                   AND c.SourceRowsNow = c.ArchiveRowsNow
                  THEN N'PASS' ELSE N'STALE'
              END AS CountGate,
              CASE
                  WHEN m.ExternalBackupReference IS NOT NULL
                   AND m.ExternalBackupSHA256 IS NOT NULL
                  THEN N'PASS' ELSE N'PENDING'
              END AS ExternalBackupGate,
              CASE
                  WHEN m.ConsumerApprovalReference IS NOT NULL
                   AND m.ApprovedBy IS NOT NULL
                   AND m.ApprovedAtUtc IS NOT NULL
                  THEN N'PASS' ELSE N'PENDING'
              END AS ConsumerApprovalGate,
              m.PhysicalDropAuthorized,
              CASE
                  WHEN m.SourceRows = c.SourceRowsNow
                   AND m.ArchiveRows = c.ArchiveRowsNow
                   AND c.SourceRowsNow = c.ArchiveRowsNow
                   AND m.ExternalBackupReference IS NOT NULL
                   AND m.ExternalBackupSHA256 IS NOT NULL
                   AND m.ConsumerApprovalReference IS NOT NULL
                   AND m.ApprovedBy IS NOT NULL
                   AND m.ApprovedAtUtc IS NOT NULL
                   AND m.PhysicalDropAuthorized = 1
                  THEN N'READY' ELSE N'BLOCKED'
              END AS PhysicalDropGate,
              m.RetentionPolicy
          FROM ArchiveSIAC.LegacyDecommissionManifest AS m
          JOIN Conteggi AS c ON c.SourceTable = m.SourceTable
          WHERE m.MigrationCode = N'MIG_123';

GO

