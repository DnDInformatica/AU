
-- -----------------------------------------------------------------------------
-- 3. CONFRONTO A/B fra due run (parametrizza @LogA = run vecchia, @LogB = run nuova)
--    Evidenzia delta di durata, CPU, reads, spill per ogni step.
-- -----------------------------------------------------------------------------
/*
DECLARE @LogA INT = 13;   -- run di riferimento (baseline)
DECLARE @LogB INT = 17;   -- run da confrontare

SELECT
    COALESCE(a.StepCode, b.StepCode) AS StepCode,
    a.DurationSec        AS A_sec,
    b.DurationSec        AS B_sec,
    CAST(b.DurationSec - a.DurationSec AS DECIMAL(18,2)) AS Delta_sec,
    CASE WHEN a.DurationSec > 0
         THEN CAST((b.DurationSec - a.DurationSec)*100.0/a.DurationSec AS DECIMAL(6,1))
         END AS Delta_pct,
    a.QS_TotLogicalReads AS A_reads,
    b.QS_TotLogicalReads AS B_reads,
    a.QS_MaxTempdbMB     AS A_tempdbMB,
    b.QS_MaxTempdbMB     AS B_tempdbMB,
    a.RowsAffected       AS A_rows,
    b.RowsAffected       AS B_rows
FROM (SELECT * FROM ImportSIAC.PipelinePlanBaseline WHERE BuildHistoryLogId=@LogA) a
FULL OUTER JOIN (SELECT * FROM ImportSIAC.PipelinePlanBaseline WHERE BuildHistoryLogId=@LogB) b
    ON b.StepCode = a.StepCode
ORDER BY COALESCE(a.StepNo, b.StepNo);
*/

-- -----------------------------------------------------------------------------
-- 4. TREND storico di un singolo step su tutte le run catturate
-- -----------------------------------------------------------------------------
/*
SELECT BuildHistoryLogId, ServiceObjective, CapturedAt,
    DurationSec, RowsAffected, QS_TotCpuSec, QS_TotLogicalReads, QS_MaxTempdbMB
FROM ImportSIAC.PipelinePlanBaseline
WHERE StepCode = N'08_SCD2_CHILDREN'
ORDER BY CapturedAt;
*/

-- -----------------------------------------------------------------------------
-- 5. VISTA riepilogo: durata totale per run + step piu' lento
-- -----------------------------------------------------------------------------
CREATE   VIEW ImportSIAC.vw_PipelineRunSummary AS
SELECT
    BuildHistoryLogId,
    MIN(ServiceObjective) AS ServiceObjective,
    MIN(StartedAt) AS RunStart,
    MAX(FinishedAt) AS RunEnd,
    CAST(SUM(DurationSec) AS DECIMAL(18,1)) AS TotStepSec,
    CAST(SUM(DurationSec)/60.0 AS DECIMAL(18,1)) AS TotStepMin,
    SUM(QS_TotLogicalReads) AS TotReads,
    MAX(QS_MaxTempdbMB) AS MaxTempdbMB,
    SUM(CASE WHEN QS_AnyRowgoalOrSpill=1 THEN 1 ELSE 0 END) AS StepsConSpill
FROM ImportSIAC.PipelinePlanBaseline
GROUP BY BuildHistoryLogId;

GO

