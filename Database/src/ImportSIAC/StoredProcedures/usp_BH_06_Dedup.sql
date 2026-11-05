-- ================================================================================
-- ImportSIAC.usp_BH_06_Dedup
-- Estratto dal monolite (step 06_DEDUP). Deduplica wrk_All_Resolved per mese
-- (tiene la versione piu' recente per pubblicazione/insert). Consuma wrk_All_Resolved
-- (la droppa) e produce wrk_MonthlyBest in columnstore.
-- ================================================================================
CREATE   PROCEDURE ImportSIAC.usp_BH_06_Dedup
    @BuildHistoryLogId INT,
    @RowsAffected BIGINT = NULL OUTPUT,
    @RigheDedup_PP INT = NULL OUTPUT,
    @RigheDedup_PRD INT = NULL OUTPUT,
    @RigheDedup_FPC INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @StepStart DATETIME2(7) = SYSUTCDATETIME();
    DECLARE @StepLogId INT, @Rows BIGINT = 0;

    -- CHECKPOINT: skip se wrk_MonthlyBest e' ancora valida
    DECLARE @CkValid BIT=0, @CkReason NVARCHAR(200);
    EXEC ImportSIAC.usp_BH_Checkpoint_Check @StepCode=N'06_DEDUP', @IsValid=@CkValid OUTPUT, @Reason=@CkReason OUTPUT;
    IF @CkValid = 1
    BEGIN
        SELECT @RigheDedup_PP=SUM(CASE WHEN Dominio='PP' THEN 1 ELSE 0 END),
               @RigheDedup_PRD=SUM(CASE WHEN Dominio='PRD' THEN 1 ELSE 0 END),
               @RigheDedup_FPC=SUM(CASE WHEN Dominio='FPC' THEN 1 ELSE 0 END)
        FROM ImportSIAC.wrk_MonthlyBest;
        SET @Rows = (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_MonthlyBest);
        SET @RowsAffected = @Rows;
        INSERT INTO ImportSIAC.BuildHistory_StepLog
            (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,FinishedAt,DurationMs,Status,RowsAffected,ExtraInfo)
        VALUES (@BuildHistoryLogId,6,N'06_DEDUP',N'Dedup mensile (RESUMED)',SYSUTCDATETIME(),SYSUTCDATETIME(),0,
                N'SUCCESS',@Rows,N'RESUMED da checkpoint: wrk_MonthlyBest gia valida.');
        PRINT CONCAT('STEP 06_DEDUP: RESUMED, ', @Rows);
        RETURN;
    END;

    INSERT INTO ImportSIAC.BuildHistory_StepLog (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,Status)
    VALUES (@BuildHistoryLogId,6,N'06_DEDUP',N'Dedup mensile',@StepStart,N'RUNNING');
    SET @StepLogId = SCOPE_IDENTITY();

    BEGIN TRY
        DROP TABLE IF EXISTS ImportSIAC.wrk_MonthlyBest;

        ;WITH Ranked AS (
            -- MIG_108: chiave business canonica
            SELECT r.*, kb.ChiaveBusinessHash,
                ROW_NUMBER() OVER (
                    PARTITION BY kb.ChiaveBusinessHash,
                                 r.SnapshotYear, r.SnapshotMonth
                    ORDER BY r.publication_date DESC, r.insertdate DESC, r.RawId DESC
                ) AS Rn
            FROM ImportSIAC.wrk_All_Resolved r
            CROSS APPLY ImportSIAC.tvf_ChiaveBusinessCertificazione
            (
                r.Dominio, r.NumeroCertificato,
                r.OrganizzazioneODCId, r.DataPrimoRilascio,
                r.fpc_fiscal_code, r.person_code,
                r.first_name, r.last_name, r.birth_date,
                r.birth_place, r.professional_code_json
            ) AS kb
        )
        SELECT * INTO ImportSIAC.wrk_MonthlyBest FROM Ranked WHERE Rn = 1 OPTION (MAXDOP 8, MIN_GRANT_PERCENT = 25);

        SET @RigheDedup_PP  = (SELECT COUNT(*) FROM ImportSIAC.wrk_MonthlyBest WHERE Dominio = 'PP');
        SET @RigheDedup_PRD = (SELECT COUNT(*) FROM ImportSIAC.wrk_MonthlyBest WHERE Dominio = 'PRD');
        SET @RigheDedup_FPC = (SELECT COUNT(*) FROM ImportSIAC.wrk_MonthlyBest WHERE Dominio = 'FPC');
        -- MIG_117: conserva output 05_RESOLVE

        CREATE CLUSTERED COLUMNSTORE INDEX CCI_MonthlyBest ON ImportSIAC.wrk_MonthlyBest;

        SET @Rows = (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_MonthlyBest);
        SET @RowsAffected = @Rows;

        UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
            DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
            Status=N'SUCCESS', RowsAffected=@Rows
        WHERE BuildHistoryStepLogId=@StepLogId;
        PRINT CONCAT('STEP 06_DEDUP: ', @Rows);

        EXEC ImportSIAC.usp_BH_Checkpoint_Mark
            @StepCode=N'06_DEDUP', @OutputTable=N'ImportSIAC.wrk_MonthlyBest',
            @RowCountAtSave=@Rows, @Notes=N'Dedup mensile: 1 riga per mese/certificato (piu recente).';
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) = LEFT(CONCAT(N'ERR ',ERROR_NUMBER(),': ',ERROR_MESSAGE()),4000);
        UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
            DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
            Status=N'FAILED', ErrorMessage=@ErrMsg
        WHERE BuildHistoryStepLogId=@StepLogId;
        THROW;
    END CATCH;
END;

GO

