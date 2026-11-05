
CREATE   PROCEDURE ImportSIAC.usp_BH_12A_PRD_ProfiliTecnici
    @BuildHistoryLogId int,
    @RowsAffected bigint = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- MIG_107: ricostruzione profili tecnici PRD multivalore.
    DECLARE @StepStart datetime2(7) = SYSUTCDATETIME();
    DECLARE @StepLogId int = NULL;
    DECLARE @Rows bigint = 0;
    DECLARE @sql nvarchar(max);
    DECLARE @HistoryTable nvarchar(300);

    IF @BuildHistoryLogId IS NULL
        THROW 60740, 'BuildHistoryLogId obbligatorio nello step 12A.', 1;

    IF OBJECT_ID(N'ImportSIAC.wrk_All_Src', N'U') IS NULL
        THROW 60741, 'wrk_All_Src assente nello step 12A.', 1;

    IF OBJECT_ID
       (
           N'Certificazione.CertificazionePRDProfiloTecnico',
           N'U'
       ) IS NULL
        THROW 60742, 'Applicare MIG_106 prima dello step 12A.', 1;

    SELECT @HistoryTable =
        QUOTENAME(hs.name) + N'.' + QUOTENAME(h.name)
    FROM sys.tables AS t
    JOIN sys.tables AS h
      ON h.object_id = t.history_table_id
    JOIN sys.schemas AS hs
      ON hs.schema_id = h.schema_id
    WHERE t.object_id =
          OBJECT_ID
          (
              N'Certificazione.CertificazionePRDProfiloTecnico'
          );

    IF @HistoryTable IS NULL
       AND OBJECT_ID
           (
               N'Certificazione.CertificazionePRDProfiloTecnicoStorico',
               N'U'
           ) IS NOT NULL
        SET @HistoryTable =
            N'[Certificazione].[CertificazionePRDProfiloTecnicoStorico]';

    IF @HistoryTable IS NULL
        THROW 60743, 'History table dei profili tecnici PRD non determinabile.', 1;

    INSERT INTO ImportSIAC.BuildHistory_StepLog
    (
        BuildHistoryLogId,
        StepNo,
        StepCode,
        StepName,
        StartedAt,
        Status
    )
    VALUES
    (
        @BuildHistoryLogId,
        12,
        N'12A_PRD_PROFILI',
        N'Rebuild profili tecnici PRD multivalore',
        @StepStart,
        N'RUNNING'
    );

    SET @StepLogId = SCOPE_IDENTITY();

    BEGIN TRY
        ;WITH Ranked AS
        (
            SELECT
                src.RawId,
                src.NumeroCertificato,
                -- MIG_108: chiave business canonica
                odc.OrganizzazioneId AS OrganizzazioneODCId,
                kb.ChiaveBusinessHash,
                src.DataPrimoRilascio,
                src.SnapshotYear,
                src.SnapshotMonth,
                DATEADD
                (
                    NANOSECOND,
                    -100,
                    DATEADD
                    (
                        DAY,
                        1,
                        CONVERT
                        (
                            datetime2(7),
                            EOMONTH
                            (
                                DATEFROMPARTS
                                (
                                    src.SnapshotYear,
                                    src.SnapshotMonth,
                                    1
                                )
                            )
                        )
                    )
                ) AS SnapshotBusinessTs,
                NULLIF
                (
                    LTRIM(RTRIM(src.enel_professional_profile)),
                    N''
                ) AS ProfiloRaw,
                nm.NormaAccreditamentoId,
                ROW_NUMBER() OVER
                (
                    PARTITION BY
                        src.NumeroCertificato,
                        odc.OrganizzazioneId,
                        src.DataPrimoRilascio,
                        src.SnapshotYear,
                        src.SnapshotMonth
                    ORDER BY
                        src.publication_date DESC,
                        src.insertdate DESC,
                        src.RawId DESC
                ) AS Rn
            FROM ImportSIAC.wrk_All_Src AS src
            JOIN Organizzazioni.Organizzazione AS odc
              ON odc.CodOrganizzazione = src.codente
             AND odc.DataCancellazione IS NULL
            LEFT JOIN ImportSIAC.wrk_NormaMap AS nm
              ON nm.norma_raw = src.norma_raw
            CROSS APPLY ImportSIAC.tvf_ChiaveBusinessCertificazione
            (
                N'PRD', src.NumeroCertificato,
                odc.OrganizzazioneId, src.DataPrimoRilascio,
                NULL, NULL, NULL, NULL, NULL, NULL, NULL
            ) AS kb
            WHERE src.Dominio = N'PRD'
              AND src.SnapshotYear BETWEEN 1900 AND 9998
              AND src.SnapshotMonth BETWEEN 1 AND 12
        ),
        Mapped AS
        (
            SELECT
                prd.CertificazionePRDId,
                r.SnapshotBusinessTs,
                r.ProfiloRaw,
                na.Riferimento AS CodiceProgramma
            FROM Ranked AS r
            JOIN Standard.NormaAccreditamento AS na
              ON na.NormaAccreditamentoId = r.NormaAccreditamentoId
             AND na.Riferimento IN (N'SP11', N'SP12', N'SP13')
            JOIN Certificazione.Certificazione AS c
              ON c.ChiaveBusinessHash = r.ChiaveBusinessHash
            JOIN Certificazione.CertificazionePRD AS prd
              ON prd.CertificazioneId = c.CertificazioneId
            WHERE r.Rn = 1
        )
        SELECT
            m.CertificazionePRDId,
            m.SnapshotBusinessTs,
            m.ProfiloRaw,
            m.CodiceProgramma,
            ROW_NUMBER() OVER
            (
                PARTITION BY m.CertificazionePRDId
                ORDER BY m.SnapshotBusinessTs
            ) AS SnapshotSeq
        INTO #Snapshots
        FROM Mapped AS m;

        IF EXISTS
        (
            SELECT 1
            FROM #Snapshots
            WHERE ProfiloRaw IS NULL
        )
            THROW 60744, 'PRD SP11/SP12/SP13 con profilo tecnico vuoto.', 1;

        SELECT
            s.CertificazionePRDId,
            s.SnapshotBusinessTs,
            s.SnapshotSeq,
            s.CodiceProgramma,
            CONVERT(smallint, token.ordinal) AS Ordinale,
            CONVERT
            (
                nvarchar(100),
                NULLIF(LTRIM(RTRIM(token.value)), N'')
            ) AS CodiceProfilo
        INTO #TokenRaw
        FROM #Snapshots AS s
        CROSS APPLY STRING_SPLIT(s.ProfiloRaw, N',', 1) AS token;

        IF EXISTS
        (
            SELECT 1
            FROM #TokenRaw
            WHERE CodiceProfilo IS NULL
        )
            THROW 60745, 'Token PRD vuoto nella lista dei profili tecnici.', 1;

        SELECT
            x.CertificazionePRDId,
            x.SnapshotBusinessTs,
            x.SnapshotSeq,
            x.Ordinale,
            x.CodiceProfilo,
            pt.ProfiloTecnicoProgrammaId,
            ROW_NUMBER() OVER
            (
                PARTITION BY
                    x.CertificazionePRDId,
                    x.SnapshotSeq,
                    pt.ProfiloTecnicoProgrammaId
                ORDER BY x.Ordinale
            ) AS TokenRn
        INTO #TokenMapped
        FROM #TokenRaw AS x
        JOIN Certificazione.ProgrammaCertificazione AS p
          ON p.Codice = x.CodiceProgramma
         AND p.DataCancellazione IS NULL
        JOIN Certificazione.ProgrammaCertificazioneVersione AS pv
          ON pv.ProgrammaCertificazioneId = p.ProgrammaCertificazioneId
         AND pv.VersioneCorrente = 1
         AND pv.DataCancellazione IS NULL
        LEFT JOIN Standard.ProfiloTecnicoProgramma AS pt
          ON pt.ProgrammaCertificazioneVersioneId =
             pv.ProgrammaCertificazioneVersioneId
         AND pt.Codice = x.CodiceProfilo
         AND pt.DataCancellazione IS NULL;

        IF EXISTS
        (
            SELECT 1
            FROM #TokenMapped
            WHERE ProfiloTecnicoProgrammaId IS NULL
        )
            THROW 60746, 'Codice profilo tecnico PRD non mappato nel catalogo contestuale.', 1;

        ;WITH TokenSequence AS
        (
            SELECT
                t.CertificazionePRDId,
                t.ProfiloTecnicoProgrammaId,
                t.CodiceProfilo,
                t.Ordinale,
                t.SnapshotSeq,
                t.SnapshotBusinessTs,
                LAG(t.SnapshotSeq) OVER
                (
                    PARTITION BY
                        t.CertificazionePRDId,
                        t.ProfiloTecnicoProgrammaId
                    ORDER BY t.SnapshotSeq
                ) AS PrevSeq,
                LAG(t.Ordinale) OVER
                (
                    PARTITION BY
                        t.CertificazionePRDId,
                        t.ProfiloTecnicoProgrammaId
                    ORDER BY t.SnapshotSeq
                ) AS PrevOrdinale
            FROM #TokenMapped AS t
            WHERE t.TokenRn = 1
        ),
        IslandStart AS
        (
            SELECT
                ts.*,
                CASE
                    WHEN ts.PrevSeq IS NULL
                      OR ts.SnapshotSeq <> ts.PrevSeq + 1
                      OR ts.Ordinale <> ts.PrevOrdinale
                    THEN 1
                    ELSE 0
                END AS NewIsland
            FROM TokenSequence AS ts
        ),
        IslandNumber AS
        (
            SELECT
                i.*,
                SUM(i.NewIsland) OVER
                (
                    PARTITION BY
                        i.CertificazionePRDId,
                        i.ProfiloTecnicoProgrammaId
                    ORDER BY i.SnapshotSeq
                    ROWS UNBOUNDED PRECEDING
                ) AS IslandNo
            FROM IslandStart AS i
        ),
        Islands AS
        (
            SELECT
                i.CertificazionePRDId,
                i.ProfiloTecnicoProgrammaId,
                i.CodiceProfilo,
                i.Ordinale,
                MIN(i.SnapshotSeq) AS StartSeq,
                MAX(i.SnapshotSeq) AS EndSeq,
                MIN(i.SnapshotBusinessTs) AS DataInizioApplicabilita
            FROM IslandNumber AS i
            GROUP BY
                i.CertificazionePRDId,
                i.ProfiloTecnicoProgrammaId,
                i.CodiceProfilo,
                i.Ordinale,
                i.IslandNo
        )
        SELECT
            i.CertificazionePRDId,
            i.ProfiloTecnicoProgrammaId,
            i.Ordinale,
            i.CodiceProfilo AS ValoreOrigine,
            i.DataInizioApplicabilita,
            CASE
                WHEN next_snapshot.SnapshotBusinessTs IS NULL
                THEN NULL
                ELSE DATEADD
                     (
                         NANOSECOND,
                         -100,
                         next_snapshot.SnapshotBusinessTs
                     )
            END AS DataFineApplicabilita
        INTO #Intervals
        FROM Islands AS i
        LEFT JOIN #Snapshots AS next_snapshot
          ON next_snapshot.CertificazionePRDId =
             i.CertificazionePRDId
         AND next_snapshot.SnapshotSeq = i.EndSeq + 1;

        BEGIN TRANSACTION;

        IF EXISTS
        (
            SELECT 1
            FROM sys.tables
            WHERE object_id =
                  OBJECT_ID
                  (
                      N'Certificazione.CertificazionePRDProfiloTecnico'
                  )
              AND temporal_type = 2
        )
        BEGIN
            SET @sql =
                N'ALTER TABLE Certificazione.CertificazionePRDProfiloTecnico '
                + N'SET (SYSTEM_VERSIONING = OFF)';
            EXEC sys.sp_executesql @sql;
        END;

        SET @sql = N'DELETE FROM ' + @HistoryTable;
        EXEC sys.sp_executesql @sql;

        DELETE
        FROM Certificazione.CertificazionePRDProfiloTecnico;

        INSERT INTO Certificazione.CertificazionePRDProfiloTecnico
        (
            CertificazionePRDId,
            ProfiloTecnicoProgrammaId,
            Ordinale,
            ValoreOrigine,
            DataInizioApplicabilita,
            DataFineApplicabilita,
            OrigineSistema,
            Attivo
        )
        SELECT
            i.CertificazionePRDId,
            i.ProfiloTecnicoProgrammaId,
            i.Ordinale,
            i.ValoreOrigine,
            i.DataInizioApplicabilita,
            i.DataFineApplicabilita,
            N'ImportSIAC.wrk_All_Src',
            1
        FROM #Intervals AS i;

        SET @Rows = (SELECT COUNT_BIG(*) FROM #Intervals); -- MIG_133: rowcount esplicito, immune a ERR 4083 (pattern MIG_129)

        SET @sql =
            N'ALTER TABLE Certificazione.CertificazionePRDProfiloTecnico '
            + N'SET (SYSTEM_VERSIONING = ON '
            + N'(HISTORY_TABLE = ' + @HistoryTable
            + N', DATA_CONSISTENCY_CHECK = ON))';
        EXEC sys.sp_executesql @sql;

        COMMIT TRANSACTION;

        SET @RowsAffected = @Rows;

        UPDATE ImportSIAC.BuildHistory_StepLog
           SET FinishedAt = SYSUTCDATETIME(),
               DurationMs =
                   DATEDIFF_BIG
                   (
                       MILLISECOND,
                       StartedAt,
                       SYSUTCDATETIME()
                   ),
               Status = N'SUCCESS',
               RowsAffected = @Rows,
               ExtraInfo =
                   N'Intervalli applicativi da profili PRD separati da virgola.'
        WHERE BuildHistoryStepLogId = @StepLogId;

        PRINT CONCAT(N'STEP 12A_PRD_PROFILI: ', @Rows);
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg nvarchar(4000) =
            LEFT
            (
                CONCAT
                (
                    N'ERR ',
                    ERROR_NUMBER(),
                    N': ',
                    ERROR_MESSAGE()
                ),
                4000
            );

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        BEGIN TRY
            IF NOT EXISTS
            (
                SELECT 1
                FROM sys.tables
                WHERE object_id =
                      OBJECT_ID
                      (
                          N'Certificazione.CertificazionePRDProfiloTecnico'
                      )
                  AND temporal_type = 2
            )
            BEGIN
                SET @sql =
                    N'ALTER TABLE Certificazione.CertificazionePRDProfiloTecnico '
                    + N'SET (SYSTEM_VERSIONING = ON '
                    + N'(HISTORY_TABLE = ' + @HistoryTable
                    + N', DATA_CONSISTENCY_CHECK = OFF))';
                EXEC sys.sp_executesql @sql;
            END;
        END TRY
        BEGIN CATCH
        END CATCH;

        IF @StepLogId IS NOT NULL
            UPDATE ImportSIAC.BuildHistory_StepLog
               SET FinishedAt = SYSUTCDATETIME(),
                   DurationMs =
                       DATEDIFF_BIG
                       (
                           MILLISECOND,
                           StartedAt,
                           SYSUTCDATETIME()
                       ),
                   Status = N'FAILED',
                   ErrorMessage = @ErrMsg
            WHERE BuildHistoryStepLogId = @StepLogId;

        THROW;
    END CATCH;
END;

GO

