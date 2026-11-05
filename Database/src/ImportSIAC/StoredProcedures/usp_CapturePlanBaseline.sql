
-- -----------------------------------------------------------------------------
-- 2. PROCEDURA DI CATTURA
--    Correla ogni step (finestra StartedAt..FinishedAt) con le runtime stats
--    di Query Store che cadono in quella finestra.
-- -----------------------------------------------------------------------------
CREATE   PROCEDURE ImportSIAC.usp_CapturePlanBaseline
    @BuildHistoryLogId INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM ImportSIAC.BuildHistory_StepLog WHERE BuildHistoryLogId=@BuildHistoryLogId)
    BEGIN
        RAISERROR('Nessuno StepLog per BuildHistoryLogId %d.', 16, 1, @BuildHistoryLogId);
        RETURN;
    END;

    -- Evita doppioni: rimuovo eventuale cattura precedente dello stesso log
    DELETE FROM ImportSIAC.PipelinePlanBaseline WHERE BuildHistoryLogId=@BuildHistoryLogId;

    DECLARE @SLO NVARCHAR(50) = CAST(DATABASEPROPERTYEX(DB_NAME(),'ServiceObjective') AS NVARCHAR(50));

    ;WITH Steps AS (
        SELECT StepNo, StepCode, StepName, Status, StartedAt, FinishedAt, DurationMs, RowsAffected, ExtraInfo
        FROM ImportSIAC.BuildHistory_StepLog
        WHERE BuildHistoryLogId = @BuildHistoryLogId
    ),
    -- Query Store: runtime stats con finestra di esecuzione
    QS AS (
        SELECT
            rs.plan_id,
            CAST(SWITCHOFFSET(rsi.start_time,0) AS DATETIME2(7)) AS start_time,
            CAST(SWITCHOFFSET(rsi.end_time,0) AS DATETIME2(7))   AS end_time,
            rs.count_executions,
            rs.avg_cpu_time, rs.avg_duration,
            rs.avg_logical_io_reads, rs.avg_logical_io_writes,
            rs.avg_query_max_used_memory,   -- pagine 8KB (memory grant)
            rs.avg_tempdb_space_used        -- pagine 8KB (spill) - colonna disponibile su Azure
        FROM sys.query_store_runtime_stats rs
        JOIN sys.query_store_runtime_stats_interval rsi ON rsi.runtime_stats_interval_id = rs.runtime_stats_interval_id
        WHERE rsi.start_time >= (SELECT DATEADD(MINUTE,-5,MIN(StartedAt)) FROM Steps)
          AND rsi.start_time <= (SELECT DATEADD(MINUTE, 5,MAX(ISNULL(FinishedAt,SYSUTCDATETIME()))) FROM Steps)
    )
    INSERT INTO ImportSIAC.PipelinePlanBaseline (
        BuildHistoryLogId, ServiceObjective, StepNo, StepCode, StepName, Status,
        StartedAt, FinishedAt, DurationMs, RowsAffected, ExtraInfo,
        QS_QueryCount, QS_TotCpuSec, QS_TotDurationSec, QS_TotLogicalReads, QS_TotLogicalWrites,
        QS_MaxTempdbMB, QS_MaxQueryMemMB, QS_AnyRowgoalOrSpill
    )
    SELECT
        @BuildHistoryLogId, @SLO, s.StepNo, s.StepCode, s.StepName, s.Status,
        s.StartedAt, s.FinishedAt, s.DurationMs, s.RowsAffected, s.ExtraInfo,
        COUNT(DISTINCT q.plan_id),
        CAST(SUM(q.avg_cpu_time * q.count_executions)/1000000.0 AS DECIMAL(18,2)),
        CAST(SUM(q.avg_duration * q.count_executions)/1000000.0 AS DECIMAL(18,2)),
        CAST(SUM(q.avg_logical_io_reads * q.count_executions) AS BIGINT),
        CAST(SUM(q.avg_logical_io_writes * q.count_executions) AS BIGINT),
        CAST(MAX(q.avg_tempdb_space_used)*8.0/1024 AS DECIMAL(18,2)),
        CAST(MAX(q.avg_query_max_used_memory)*8.0/1024 AS DECIMAL(18,2)),
        CASE WHEN MAX(q.avg_tempdb_space_used)*8.0/1024 > 1000 THEN 1 ELSE 0 END  -- >1GB spill = sospetto
    FROM Steps s
    LEFT JOIN QS q
        ON q.start_time >= s.StartedAt
       AND q.start_time <= ISNULL(s.FinishedAt, SYSUTCDATETIME())
    GROUP BY s.StepNo, s.StepCode, s.StepName, s.Status, s.StartedAt, s.FinishedAt, s.DurationMs, s.RowsAffected, s.ExtraInfo;

    PRINT CONCAT('Baseline catturata per LogId=', @BuildHistoryLogId, ' (', @@ROWCOUNT, ' step).');

    SELECT StepNo, StepCode, Status,
        DurationSec, RowsAffected,
        QS_TotCpuSec, QS_TotLogicalReads, QS_MaxTempdbMB, QS_MaxQueryMemMB, QS_AnyRowgoalOrSpill
    FROM ImportSIAC.PipelinePlanBaseline
    WHERE BuildHistoryLogId=@BuildHistoryLogId
    ORDER BY StepNo;
END;

GO

